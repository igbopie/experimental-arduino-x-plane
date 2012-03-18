library DelphiTimedProcessing;

{************* X-Plane SDK : Delphi Sample Code ***************************
file    : DelphiTimedProcessing.dpr
version : 1.0
author  : Sandy Barbour <sandybarbour@btinternet.com>
licence : Code released as freeware without any restrictions.
Kylix Port : Sandy Barbour

DECSRIPTION
 * DelphiTimedProcessing registers a flight loop callback

 --------------------------------------------------------------------------------

************* X-Plane SDK : Delphi Sample Code ***************************}

uses
{$IFDEF MSWINDOWS}
  Windows,
//  Graphics,
{$ENDIF}
  SysUtils,
  Classes,
{$IFDEF MSWINDOWS}
  XPLMDefs in '..\..\..\..\SDK\Delphi\XPLM\XPLMDefs.pas',
  XPLMDisplay in '..\..\..\..\SDK\Delphi\XPLM\XPLMDisplay.pas',
  XPLMProcessing in '..\..\..\..\SDK\Delphi\XPLM\XPLMProcessing.pas',
  XPLMUtilities in '..\..\..\..\SDK\Delphi\XPLM\XPLMUtilities.pas',
  XPLMDataAccess in '..\..\..\..\SDK\Delphi\XPLM\XPLMDataAccess.pas';
{$ELSE}
  XPLMDefs in '../../../../SDK/Delphi/XPLM/XPLMDefs.pas',
  XPLMDisplay in '../../../../SDK/Delphi/XPLM/XPLMDisplay.pas',
  XPLMProcessing in '../../../../SDK/Delphi/XPLM/XPLMProcessing.pas',
  XPLMUtilities in '../../../../SDK/Delphi/XPLM/XPLMUtilities.pas',
  XPLMDataAccess in '../../../../SDK/Delphi/XPLM/XPLMDataAccess.pas';
{$ENDIF}

// The Delphi Compiler must create a file with a .XPL extention. The default
// extention for a Delphi library is .DLL - thus we use the $E compiler
// directive to override the default and change it to .XPL
{$E xpl}

// Default directive to include any RESOURCE files our project may have
//{$R *.res}

var
 gLatitutde : XPLMDataRef;
 gLongitude : XPLMDataRef;
 gElevation : XPLMDataRef;
 gFileHandle: Integer;

function MyFlightLoopCallback(inElapsedSinceLastCall    : Single;
                              inElapsedTimeSinceLastFlightLoop : Single;
                              inCounter : LongInt;
                              inRefcon   : pointer ) : Single; cdecl;
var
  Latitude,
  Longitude,
  Elevation,
  Elapsed : Single;
  Buffer : string[255];
begin
  //* If any data refs are missing, do not proceed.
  if (gLatitutde = nil) or (gLongitude = nil) or (gElevation = nil) then
  begin
    result := 1;
    exit;
  end;

	Elapsed := XPLMGetElapsedTime();
	Latitude := XPLMGetDataf(gLatitutde);
	Longitude := XPLMGetDataf(gLongitude);
	Elevation := XPLMGetDataf(gElevation);

	{/* Write the data to a file. */}
  Buffer := 'Time = ' +  FloatToStr(Elapsed) + ' : Latitude = ' + FloatToStr(Latitude) +
            ' : Longitude = ' + FloatToStr(Longitude) + ' : Elevation = ' + FloatToStr(Elevation) + #13#10;
  FileWrite(gFileHandle, Buffer[1], Length(Buffer));

  result := 1;
end;

{/*
 * XPluginStart
 *
 * Our start routine registers our callback and does any other initialization we
 * must do.
 *
 */}
function XPluginStart( outName : PChar;
                       outSig  : PChar;
                       outDesc : PChar ) : integer; cdecl;
var
  Buffer : string[255];
  outputPath : PChar;
begin

  //* First record our plugin information.
  StrPCopy(outName, 'DelphiTimedProcessing');
  StrPCopy( outSig,  'Delphi\SampleCode\TimedProcessing' );
  StrPCopy(outDesc, 'A plugin that records sim data.');

	{/*
  * Open a file to write to.
  * Locate the X-System directory then concatenate the file name.
  */}

  outputPath := @Buffer;
	XPLMGetSystemPath(outputPath);
	StrCat(outputPath, 'DelphiTimedProcessing.txt');
  gFileHandle := FileCreate(outputPath);

	{/* Find the data refs we want to record. */}
	gLatitutde := XPLMFindDataRef('sim/flightmodel/position/latitude');
	gLongitude := XPLMFindDataRef('sim/flightmodel/position/longitude');
	gElevation := XPLMFindDataRef('sim/flightmodel/position/elevation');

	XPLMRegisterFlightLoopCallback( MyFlightLoopCallback,	// Callback
           			                  1.0,	                // Interval
                                  nil);	                // refcon not used.

  result := 1
end;

{/*
 * XPluginStop
 *
 * Our cleanup routine unregistering our callback.
 *
 */}
procedure XPluginStop; cdecl;
begin
	{/* Unregister the callback */}
	XPLMUnregisterFlightLoopCallback(MyFlightLoopCallback, nil);
	{/* Close the file */}
	FileClose(gFileHandle);
end;

{/*
 * XPluginDisable
 *
 * We do not need to do anything when we are disabled, but we must provide the handler.
 *
 */}
procedure XPluginDisable; cdecl;
begin
  // nothing to do
end;

{/*
 * XPluginEnable.
 *
 * We don't do any enable-specific initialization, but we must return 1 to indicate
 * that we may be enabled at this time.
 *
 */}
function XPluginEnable : integer; cdecl;
begin
  result := 1;
end;

{/*
 * XPluginReceiveMessage
 *
 * We don't have to do anything in our receive message handler, but we must provide one.
 *
 */}
procedure XPluginReceiveMessage(   inFromWho : XPLMPluginID;
                                   inMessage : longint;
                                   inParam   : pointer); cdecl;
begin
  // nothing to do
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
