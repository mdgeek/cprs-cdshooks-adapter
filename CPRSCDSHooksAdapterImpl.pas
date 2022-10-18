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
uses ComServ, Windows, ShellAPI, StrUtils;
function getSystemParams(broker: ICPRSBroker; state: ICPRSState): TStringList;
var
  rpcResult: String;
  i: Integer;
begin
  Result := TStringList.Create;
  Result.Delimiter := #10;
  broker.SetContext('CDSP');
  broker.ClearParameters;
  broker.ClearResults;
  broker.Param[0] := state.PatientDFN;
  broker.ParamType[0] := bptLiteral;
  broker.CallRPC('CDSP GETPARAMS');
  rpcResult := broker.Results;
  rpcResult := LowerCase(rpcResult);
  rpcResult := StringReplace(rpcResult, ' ', '_', [rfReplaceAll]);
  Result.Text := rpcResult;
  i := Result.IndexOfName('debug_user');

  if i > -1 then begin
    if Result.ValueFromIndex[i] = state.UserDUZ then Result.AddPair('debug', 'true');
    Result.Delete(i);
  end;
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
  qs: String;
  otherParams: String;
  showCommand: Integer;
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
    params := getSystemParams(CPRSBroker, CPRSState);
    data.addStrings(params);
    endpoint := data.Values['cdshook_proxy_endpoint'];

    if data.Values['debug'] <> '' then begin
      showCommand := SW_SHOWNORMAL;
      ShowMessage(data.Text);
    end else begin
      showCommand := SW_SHOWMINIMIZED;
    end;

    httpClient := TIdHTTP.Create;
    httpClient.Post(pathJoin(endpoint, 'forward'), data);
    otherParams := IfThen(data.Values['debug'] = 'true','debug&', '');
    qs := Format('%shandle=%s&proxy=%s', [otherParams, CPRSState.Handle, data.values['cdshook_proxy_endpoint']]);
    url := appendQueryString(data.Values['cdshook_client_endpoint'], qs);
    ShellExecute(ToHWND(CPRSState.Handle), 'open', PWideChar(url), nil, nil, showCommand);
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
