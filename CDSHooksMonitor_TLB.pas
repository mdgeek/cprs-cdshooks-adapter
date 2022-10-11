unit CDSHooksMonitor_TLB;

// ************************************************************************ //
// WARNING
// -------
// The types declared in this file were generated from data read from a
// Type Library. If this type library is explicitly or indirectly (via
// another type library referring to this type library) re-imported, or the
// 'Refresh' command of the Type Library Editor activated while editing the
// Type Library, the contents of this file will be regenerated and all
// manual modifications will be lost.
// ************************************************************************ //

// $Rev: 98336 $
// File generated on 10/10/2022 6:12:17 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: Y:\workspace\cprs-cdshooks-monitor\CDSHooksMonitor (1)
// LIBID: {20FC3652-766D-4DAF-95AC-30DCDB64955A}
// LCID: 0
// Helpfile:
// HelpString:
// DepndLst:
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleServer, Winapi.ActiveX;


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:
//   Type Libraries     : LIBID_xxxx
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  CDSHooksMonitorMajorVersion = 1;
  CDSHooksMonitorMinorVersion = 0;

  LIBID_CDSHooksMonitor: TGUID = '{20FC3652-766D-4DAF-95AC-30DCDB64955A}';

  IID_ICDSHooksMonitorCoClass: TGUID = '{B85BFA87-E22F-4244-8CB4-4E3CA52E600C}';
  CLASS_CDSHooksMonitorCoClass: TGUID = '{BCC5BB32-A45A-4BA5-A92E-E24B90214BA8}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  ICDSHooksMonitorCoClass = interface;
  ICDSHooksMonitorCoClassDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//
  CDSHooksMonitorCoClass = ICDSHooksMonitorCoClass;


// *********************************************************************//
// Interface: ICDSHooksMonitorCoClass
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B85BFA87-E22F-4244-8CB4-4E3CA52E600C}
// *********************************************************************//
  ICDSHooksMonitorCoClass = interface(IDispatch)
    ['{B85BFA87-E22F-4244-8CB4-4E3CA52E600C}']
    procedure Submit(const Request: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  ICDSHooksMonitorCoClassDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B85BFA87-E22F-4244-8CB4-4E3CA52E600C}
// *********************************************************************//
  ICDSHooksMonitorCoClassDisp = dispinterface
    ['{B85BFA87-E22F-4244-8CB4-4E3CA52E600C}']
    procedure Submit(const Request: WideString); dispid 201;
  end;

// *********************************************************************//
// The Class CoCDSHooksMonitorCoClass provides a Create and CreateRemote method to
// create instances of the default interface ICDSHooksMonitorCoClass exposed by
// the CoClass CDSHooksMonitorCoClass. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoCDSHooksMonitorCoClass = class
    class function Create: ICDSHooksMonitorCoClass;
    class function CreateRemote(const MachineName: string): ICDSHooksMonitorCoClass;
  end;

implementation

uses System.Win.ComObj;

class function CoCDSHooksMonitorCoClass.Create: ICDSHooksMonitorCoClass;
begin
  Result := CreateComObject(CLASS_CDSHooksMonitorCoClass) as ICDSHooksMonitorCoClass;
end;

class function CoCDSHooksMonitorCoClass.CreateRemote(const MachineName: string): ICDSHooksMonitorCoClass;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CDSHooksMonitorCoClass) as ICDSHooksMonitorCoClass;
end;

end.

