unit CPRSCDSHooksAdapterImpl;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, Classes, ActiveX, CPRSCDSHooksAdapter_TLB, StdVcl, Dialogs, CPRSChart_TLB,
  IdBaseComponent, IdComponent, SysUtils, IdTCPConnection, IdTCPClient, IdHTTP;

type
  TCPRSCDSHooksAdapterCoClass = class(TAutoObject, ICPRSCDSHooksAdapterCoClass, ICPRSExtension)
  private
    procedure Alert(message: String);
  protected
    function Execute(const CPRSBroker: ICPRSBroker; const CPRSState: ICPRSState; const Param1,
          Param2, Param3: WideString; var Data1, Data2: WideString): WordBool;
          safecall;
  public
    procedure Initialize; override;
    destructor Destroy; override;
    procedure SubmitRequest(data: TStringList);
  end;

implementation

uses ComServ, Windows, ShellAPI;

const
  urlRoot = 'http://localhost:8080/cdshooks-demo/cdshooks-proxy/';

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

    TThread.CreateAnonymousThread(procedure
    begin
      SubmitRequest(data);
    end).Start;
  except
    On e:Exception do begin
      ShowMessage('Error: ' + e.Message);
    end;
  end;
end;

procedure TCPRSCDSHooksAdapterCoClass.SubmitRequest(data: TStringList);
var
  httpClient: TIdHTTP;
  hookInstance: String;
  cprsHandle: String;
  url: String;
  i: Integer;
begin
  Alert('Sending:' + #13 + data.GetText);
  cprsHandle := data.Values['handle'];
  httpClient := TIdHTTP.Create;
  httpClient.Request.ContentType := 'application/x-www-form-urlencoded';
  httpClient.Request.Accept := 'text/plain';
  httpClient.Post(urlRoot + 'forward', data);
  data.Free;
  httpClient.Request.ContentType := 'text/plain';
  Alert('polling');
  i := 0;

  while i < 20 do begin
    hookInstance := httpClient.Get(urlRoot + 'next/' + cprsHandle);

    if httpClient.Response.ResponseCode <> 200 then break;

    if (hookInstance = '') then begin
      Sleep(500);
      i := i + 1;
    end else begin
      i := 0;
      url := urlRoot + 'launch?handle=' + cprsHandle + '&instance=' + hookInstance;
      Alert('launching browser');
      ShellExecute(0, 'open', PWideChar(url), nil, nil, SW_SHOWNORMAL);
    end;
  end;

  Alert('thread terminated');
  httpClient.Free;

end;

procedure TCPRSCDSHooksAdapterCoClass.Alert(message: String);
begin
  OutputDebugString(PWideChar(message));
end;

initialization
  TAutoObjectFactory.Create(ComServer, TCPRSCDSHooksAdapterCoClass, Class_CPRSCDSHooksAdapterCoClass,
    ciMultiInstance, tmApartment);
end.
