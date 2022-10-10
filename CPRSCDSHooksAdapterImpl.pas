unit CPRSCDSHooksAdapterImpl;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, Classes, ActiveX, CPRSCDSHooksAdapter_TLB, StdVcl, Dialogs, CPRSChart_TLB,
  IdBaseComponent, IdComponent, SysUtils, IdTCPConnection, IdTCPClient, IdHTTP;

type
  TWorkerThread = class(TThread)
  private
    httpClient: TIdHTTP;
    procedure Alert(message: String);
  protected
    procedure Execute(); override;
  public
    constructor Create(data: TStringList);
    destructor Destroy; override;
  end;

  TCPRSCDSHooksAdapterCoClass = class(TAutoObject, ICPRSCDSHooksAdapterCoClass, ICPRSExtension)
  protected
    function Execute(const CPRSBroker: ICPRSBroker; const CPRSState: ICPRSState; const Param1,
          Param2, Param3: WideString; var Data1, Data2: WideString): WordBool;
          safecall;
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

implementation

uses ComServ;

const
  urlRoot = 'http://localhost:8080/cdshooks-demo/cdshooks-proxy/';

var
  cprsHandle: String;

// ============== TWorkerThread ==============

constructor TWorkerThread.Create(data: TStringList);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  httpClient := TIdHTTP.Create();
  Alert('Thread created');
  httpClient.Request.ContentType := 'application/x-www-form-urlencoded';
  httpClient.Request.Accept := 'text/plain';
  httpClient.Post(urlRoot + 'forward', data);
  data.Free;
  Start;
end;

destructor TWorkerThread.Destroy();
begin
  Alert('Thread destroyed');
  inherited;
  httpClient.Free;
end;

procedure TWorkerThread.Execute;
var
  hookInstance: String;
  response: String;
begin
  Alert('Thread started!');
  httpClient.Request.ContentType := 'text/plain';

  while not Terminated do begin
    httpClient.Request.Accept := 'text/plain';
    hookInstance := httpClient.Get(urlRoot + 'next/' + cprsHandle);

    if httpClient.Response.ResponseCode <> 200 then break;

    if (hookInstance = '') then begin
      Sleep(500);
    end else begin
      httpClient.Request.Accept := 'application/json';
      response := httpClient.Get(urlRoot + 'response/' + cprsHandle + '/' + hookInstance);
      Alert(response);
    end;

  end;

  Alert('Thread terminated');
end;

procedure TWorkerThread.Alert(message: String);
begin
  Queue(procedure
  begin
    ShowMessage(message);
  end);
end;

// ============== TCPRSCDSHooksAdapterCoClass ==============

procedure TCPRSCDSHooksAdapterCoClass.Initialize;
begin
  inherited;
end;

destructor TCPRSCDSHooksAdapterCoClass.Destroy;
begin
  inherited;
end;

function TCPRSCDSHooksAdapterCoClass.Execute(const CPRSBroker: ICPRSBroker; const CPRSState: ICPRSState;
          const Param1, Param2, Param3: WideString; var Data1,
          Data2: WideString): WordBool;
var
  data: TStringList;
  hookType: String;
begin
  try
    data := TStringList.Create;
    data.Delimiter := #10;
    cprsHandle := CPRSState.Handle;
    data.Clear;

    if Param2[1] = 'P'
    then hookType := 'patient-view'
    else if Param2[1] = 'O'
    then begin
      hookType := 'order-select';
      data.AddPair('orderId', Copy(Param2, 3, 999));
    end else Exit;

    data.AddPair('hook', hookType);
    data.AddPair('param1', Param1);
    data.AddPair('param2', Param2);
    data.AddPair('param3', Param3);
    data.AddPair('handle', CPRSState.Handle);
    data.AddPair('userId', CPRSState.UserDUZ);
    data.AddPair('userName', CPRSState.UserName);
    data.AddPair('patientId', CPRSState.PatientDFN);
    data.AddPair('patientName', CPRSState.PatientName);
    data.AddPair('patientDob', CPRSState.PatientDOB);
    data.AddPair('locationId', IntToStr(CPRSState.LocationIEN));
    data.AddPair('locationName', CPRSState.LocationName);

    ShowMessage('Sending:' + #13 + data.GetText);
    TWorkerThread.Create(data);
  except
    On e:Exception do begin
      ShowMessage('Error: ' + e.Message);
    end;
  end;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TCPRSCDSHooksAdapterCoClass, Class_CPRSCDSHooksAdapterCoClass,
    ciMultiInstance, tmApartment);
end.
