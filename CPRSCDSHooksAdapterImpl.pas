unit CPRSCDSHooksAdapterImpl;
{$WARN SYMBOL_PLATFORM OFF}
interface
uses
  ComObj, Classes, ActiveX, CPRSCDSHooksAdapter_TLB, StdVcl, Dialogs, CPRSChart_TLB,
  IdBaseComponent, IdComponent, SysUtils, IdTCPConnection, IdTCPClient, IdHTTP;
type
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

uses ComServ, Windows, ShellAPI;

function getSystemParams(broker: ICPRSBroker): TStringList;
var
  rpcResult: String;
begin
  Result := TStringList.Create;
  Result.Delimiter := #10;
  broker.SetContext('CDSP');
  broker.ClearParameters;
  broker.CallRPC('CDSP GETPARAMS');
  rpcResult := broker.Results;
  rpcResult := StringReplace(rpcResult, 'CDSP ', '', [rfReplaceAll]);
  rpcResult := LowerCase(rpcResult);
  rpcResult := StringReplace(rpcResult, ' ', '_', [rfReplaceAll]);
  Result.Text := rpcResult;
end;

function pathJoin(first: String; second: String): String;
begin
  if not first.EndsWith('/') then first := first + '/';
  if second.StartsWith('/') then second := second.Substring(2);
  Result := first + second;
end;

function appendQueryString(path: String; qs: String): String;
begin
  if path.Contains('?') then Result := path + '&' + qs
  else Result := path + '?' + qs;
end;

function toHWND(handle: String): HWND;
var
  i: Integer;
begin
  try
    i := Pos('x', handle);
    handle := '$' + Copy(handle, i + 1);
    Result := StrToInt(handle);
  except
    Result := 0;
  end;
end;

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
  params: TStringList;
  hookType: String;
  url: String;
  httpClient: TIdHTTP;
  endPoint: String;
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
    params := getSystemParams(CPRSBroker);
    data.addStrings(params);
    endpoint := data.Values['cdshook_proxy_endpoint'];
    ShowMessage(data.Text);
    httpClient := TIdHTTP.Create;
    httpClient.Post(pathJoin(endpoint, 'forward'), data);
    url := appendQueryString(data.Values['cdshook_client_endpoint'], 'handle=' + CPRSState.Handle);
    ShellExecute(ToHWND(CPRSState.Handle), 'open', PWideChar(url), nil, nil, SW_SHOWNORMAL);
  except
    On e:Exception do begin
      ShowMessage('Error: ' + e.Message);
    end;
  end;

  FreeAndNil(data);
  FreeAndNil(params);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TCPRSCDSHooksAdapterCoClass, Class_CPRSCDSHooksAdapterCoClass,
    ciMultiInstance, tmApartment);
end.
