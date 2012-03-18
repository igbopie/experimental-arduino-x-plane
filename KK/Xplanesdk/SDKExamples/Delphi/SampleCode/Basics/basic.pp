library basic;

{************* X-Plane SDK : Delphi Sample Code ***************************
file    : basic.dpr
version : 1.0
author  : Billy Verreynne <vslabs@onwe.co.za>
licence : Code released as freeware without any restrictions.
Kylix Port : Sandy Barbour

DECSRIPTION
--------------------------------------------------------------------------------
This sample code shows the very basic template you need to define for
writing a Delphi Plug-In for X-Plane.

You can compile this source, create the BASIC.XPL DLL file, and include it
in your X-Plane's plug-in folder. However, please note that this plug-in
does nothing.

The following is demonstrated:
- creating the 5 functions required by the X-Plane SDK for hooking our DLL
  into X-Plane
- exporting the 5 functions, making it visible (and callable) to EXEs and
  other DLLs (like the XPLM DLL that will be calling us)
- DLL unload chaining (WARNING: it may not work correctly on non-Delphi 7
  versions - you do NOT need to use DLL unload chaining for X-Plane plug-in
  DLLs. If it does not work for you, or if you do not need it, please discard
  it.)


DEBUGGING:
--------------------------------------------------------------------------------
To debug your plug-in, you need to define a HOST application (i.e. the app that
will be loading and calling your DLL).

1. In the Delphi IDE, click on RUN | PARAMETERS and select the X-Plane
   executable as the HOST application. Click OK.

2. Click on PROJECT | OPTIONS and select the X-Plane PLUGINS folder as the
   OUTPUT DIRECTORY for your project (i.e. the .XPL compiled file must be
   created there).

3. Insert your breakpoints in your code.

4. Click on the RUN icon or press F9. X-Plane will be launched by the Delphi
   debugger.

5. Debug as normal.


COMPILER WARNINGS:
--------------------------------------------------------------------------------
Note that the Delphi 1.5 compiler (shipping with Delphi7) includes very strict
pointer and type def checking, as per the Microsoft .NET security standards.

Quote. "You have used a data type or operation for which static code analysis
cannot prove that it does not overwrite memory. In a secured execution
environment such as .NET, such code is assumed to be unsafe and a potential
security risk." Unquote.

As the XPLM does not conform to .NET security standards wrt pointers, you can
expect numerous of these warnings.

You can disable these warnings via PROJECT | OPTIONS | COMPILER MESSAGES. These
checks and warning generation can drastically increase compilation time.


************* X-Plane SDK : Delphi Sample Code ***************************}


uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  SysUtils,
{$IFDEF MSWINDOWS}
  XPLMDefs in '..\..\..\..\SDK\Delphi\XPLM\XPLMDefs.pas',
  XPLMUtilities in '..\..\..\..\SDK\Delphi\XPLM\XPLMUtilities.pas';
{$ELSE}
  XPLMDefs in '../../../../SDK/Delphi/XPLM/XPLMDefs.pas',
  XPLMUtilities in '../../../../SDK/Delphi/XPLM/XPLMUtilities.pas';
{$ENDIF}
  // add whatever other units you need here, e.g. Classes etc.


// The Delphi Compiler must create a file with a .XPL extention. The default
// extention for a Delphi library is .DLL - thus we use the $E compiler
// directive to override the default and change it to .XPL
{$E xpl}

// Default directive to include any RESOURCE files our project may have
// {$R *.res}

// we need a single type def for the basic integration with XPLM
// (note!! this is replaced by including the plug-in Pascal headers
// when doing regular plugin programming)
type  XPLMPluginID = integer;

// XPLUGINSTART
// This method is called when the X-Plane loads and the Plug-In Manager
// initialises. It is the first call we get from X-Plane. We can consider
// this as the "contructor call" for our plug-in DLL.
//
// NOTE! : All our communication functions (i.e. the functions and procedures
//         we are exporting so that these can be called by XPLM) _MUST_ be
//         declared as CDECL (C DECLARE) functions. The XPLM uses the (slower)
//         CDECL calling method. The Windows kernel/system uses the slightly
//         faster STDCALL method. Using the incorrect calling method for XPLM
//         callbacks will result in memory/pointer ref errors. Ye have been
//         warneth! :-)
function XPluginStart( outName : PChar;
                       outSig  : PChar;
                       outDesc : PChar ) : integer; cdecl;
begin
  // We need to return our Name, Signature and Description to the XPLM.
  // We use the StrPCopy function to convert our text into PCHARs.
  StrPCopy( outName, 'Delphi_BASIC' );
  StrPCopy( outSig,  'Delphi\SampleCode\Basics' );
  StrPCopy( outDesc, 'Delphi Basic Example' );
  XPLMDebugString('Test' + #13#10);
  // we return 1, informing XPLM that we're have been successfully called
  // and initialised
  result := 1;
end;


// XPLUGINSTOP
// This method is called when the the Plug-In Manager terminates and X-Plane
// exits. It is the last call we get from X-Plane. We can consider
// this as the "destructor call" for our plug-in DLL.
procedure XPluginStop; cdecl;
begin
  // insert clean up code here
end;


// XPLUGINENABLE
// This method is called when the the Plug-In Manager gives us the okay
// to do our thing. This is the 2nd call we get from X-Plane.
function XPluginEnable : integer; cdecl;
begin
  // must return an OKAY to the XPLM
  result := 1;
end;


// XPLUGINDISABLE
// This method is called when the the Plug-In Manager tell us to stop doing
// our thing. This is (usually?) the 2nd last call we get from X-Plane (the one
// just before being told to stop). This is similar to the TFORM class's CLOSE
// method (which gets called before the class's destructor).
procedure XPluginDisable; cdecl;
begin
  // code
end;


// XPluginReceiveMessage
// This is the XPLM message handler. It works in a similar fashion as the
// standard Windows message queue that deals with keypresses, mouse messages
// and so on.
procedure XPluginReceiveMessage(
   					inFromWho : XPLMPluginID;
	   				inMessage : longint;
		  			inParam   : pointer); cdecl;
begin
  // code
end;


// In order to make these calls in our DLL visible to the outside world, we
// need to export them.
exports
  XPluginStop,
  XPluginStart,
  XPluginReceiveMessage,
  XPluginEnable,
  XPluginDisable;


begin
end.

//eof
