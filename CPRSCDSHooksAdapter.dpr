library CPRSCDSHooksAdapter;

uses
  ComServ,
  CPRSCDSHooksAdapter_TLB in 'CPRSCDSHooksAdapter_TLB.pas',
  CPRSCDSHooksAdapterImpl in 'CPRSCDSHooksAdapterImpl.pas' {CPRSCDSHooksAdapterCoClass: CoClass};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer,
  DllInstall;

{$R *.TLB}

{$R *.RES}

begin
end.
