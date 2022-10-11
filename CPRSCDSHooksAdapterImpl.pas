unit CPRSCDSHooksAdapterImpl;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, Classes, ActiveX, CPRSCDSHooksAdapter_TLB, StdVcl, Dialogs, CPRSChart_TLB,
  IdBaseComponent, IdComponent, SysUtils, IdTCPConnection, IdTCPClient, IdHTTP,
  CDSHooksMonitor_TLB;

type
  TCPRSCDSHooksAdapterCoClass = class(TAutoObject, ICPRSCDSHooksAdapterCoClass, ICPRSExtension)
  private
    monitor: ICDSHooksMonitorCoClass;
  protected
    function Execute(const CPRSBroker: ICPRSBroker; const CPRSState: ICPRSState; const Param1,
          Param2, Param3: WideString; var Data1, Data2: WideString): WordBool;
          safecall;
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

implementation

uses ComServ, Windows, ShellAPI;

const
  URL_ROOT = 'http://localhost:8080/cdshooks-demo/cdshooks-proxy/';

// ============== TCPRSCDSHooksAdapterCoClass ==============

procedure TCPRSCDSHooksAdapterCoClass.Initialize;
begin
  inherited;
  monitor := CoCDSHooksMonitorCoClass.Create;
end;

destructor TCPRSCDSHooksAdapterCoClass.Destroy;
begin
  inherited;
  monitor := nil;
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
    data.AddPair('endpoint', URL_ROOT);
    monitor.Submit(data.Text);
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
