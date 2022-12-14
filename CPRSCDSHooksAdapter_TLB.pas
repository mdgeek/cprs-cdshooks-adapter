unit CPRSCDSHooksAdapter_TLB;

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
// File generated on 10/17/2022 5:35:51 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: Y:\workspace\cprs-cdshooks-adapter\CPRSCDSHooksAdapter (1)
// LIBID: {4FD695D9-2824-4594-A68F-7DCAD63BB4D1}
// LCID: 0
// Helpfile:
// HelpString:
// DepndLst:
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
//   (2) v1.0 CPRSChart, (C:\Users\dmartin\Desktop\VistA\CPRS\CPRSChart.exe)
// SYS_KIND: SYS_WIN32
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, CPRSChart_TLB, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleServer, Winapi.ActiveX;



// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:
//   Type Libraries     : LIBID_xxxx
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  CPRSCDSHooksAdapterMajorVersion = 1;
  CPRSCDSHooksAdapterMinorVersion = 0;

  LIBID_CPRSCDSHooksAdapter: TGUID = '{4FD695D9-2824-4594-A68F-7DCAD63BB4D1}';

  IID_ICPRSCDSHooksAdapterCoClass: TGUID = '{0361369F-BE91-4545-AB97-459DE79E0EB9}';
  CLASS_CPRSCDSHooksAdapterCoClass: TGUID = '{F0BF0E4D-D51C-41FA-9933-E2A54CCAD216}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  ICPRSCDSHooksAdapterCoClass = interface;
  ICPRSCDSHooksAdapterCoClassDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//
  CPRSCDSHooksAdapterCoClass = ICPRSCDSHooksAdapterCoClass;


// *********************************************************************//
// Interface: ICPRSCDSHooksAdapterCoClass
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0361369F-BE91-4545-AB97-459DE79E0EB9}
// *********************************************************************//
  ICPRSCDSHooksAdapterCoClass = interface(IDispatch)
    ['{0361369F-BE91-4545-AB97-459DE79E0EB9}']
  end;

// *********************************************************************//
// DispIntf:  ICPRSCDSHooksAdapterCoClassDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0361369F-BE91-4545-AB97-459DE79E0EB9}
// *********************************************************************//
  ICPRSCDSHooksAdapterCoClassDisp = dispinterface
    ['{0361369F-BE91-4545-AB97-459DE79E0EB9}']
  end;

// *********************************************************************//
// The Class CoCPRSCDSHooksAdapterCoClass provides a Create and CreateRemote method to
// create instances of the default interface ICPRSCDSHooksAdapterCoClass exposed by
// the CoClass CPRSCDSHooksAdapterCoClass. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoCPRSCDSHooksAdapterCoClass = class
    class function Create: ICPRSCDSHooksAdapterCoClass;
    class function CreateRemote(const MachineName: string): ICPRSCDSHooksAdapterCoClass;
  end;

implementation

uses System.Win.ComObj;

class function CoCPRSCDSHooksAdapterCoClass.Create: ICPRSCDSHooksAdapterCoClass;
begin
  Result := CreateComObject(CLASS_CPRSCDSHooksAdapterCoClass) as ICPRSCDSHooksAdapterCoClass;
end;

class function CoCPRSCDSHooksAdapterCoClass.CreateRemote(const MachineName: string): ICPRSCDSHooksAdapterCoClass;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CPRSCDSHooksAdapterCoClass) as ICPRSCDSHooksAdapterCoClass;
end;

end.

