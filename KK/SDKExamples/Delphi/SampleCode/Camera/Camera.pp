library Camera;

{************* X-Plane SDK : Delphi Sample Code ***************************
file    : Camera.dpr
version : 1.0
author  : Billy Verreynne <vslabs@onwe.co.za>
licence : Code released as freeware without any restrictions.
Kylix port : Sandy Barbour

--------------------------------------------------------------------------------
/*
 * Camera.c
 *
 * This plugin registers a new view with the sim that orbits the aircraft.
 * We do this by:
 *
 * 1. Registering a hotkey to engage the view.
 * 2. Setting the view to external when we are engaged.
 * 3. Registering a new camera control funcioin that ends when a new view is
 *    picked.
 *
 */

************* X-Plane SDK : Delphi Sample Code ***************************}

uses
{$IFDEF MSWINDOWS}
  Windows,
  //Graphics,
{$ENDIF}
  SysUtils,
  Classes,
  Math,
{$IFDEF MSWINDOWS}
  XPLMDefs in '..\..\..\..\SDK\Delphi\XPLM\XPLMDefs.pas',
  XPLMDisplay in '..\..\..\..\SDK\Delphi\XPLM\XPLMDisplay.pas',
  XPLMDataAccess in '..\..\..\..\SDK\Delphi\XPLM\XPLMDataAccess.pas',
  XPLMCamera in '..\..\..\..\SDK\Delphi\XPLM\XPLMCamera.pas',
  XPLMUtilities in '..\..\..\..\SDK\Delphi\XPLM\XPLMUtilities.pas';
{$ELSE}
  XPLMDefs in '../../../../SDK/Delphi/XPLM/XPLMDefs.pas',
  XPLMDisplay in '../../../../SDK/Delphi/XPLM/XPLMDisplay.pas',
  XPLMDataAccess in '../../../../SDK/Delphi/XPLM/XPLMDataAccess.pas',
  XPLMCamera in '../../../../SDK/Delphi/XPLM/XPLMCamera.pas',
  XPLMUtilities in '../../../../SDK/Delphi/XPLM/XPLMUtilities.pas';
{$ENDIF}

// The Delphi Compiler must create a file with a .XPL extention. The default
// extention for a Delphi library is .DLL - thus we use the $E compiler
// directive to override the default and change it to .XPL
{$E xpl}

// Default directive to include any RESOURCE files our project may have
// {$R *.res}


// Global variables
var
  gHotKey : XPLMHotKeyID;
  gPlaneX : XPLMDataRef;
  gPlaneY : XPLMDataRef;
  gPlaneZ : XPLMDataRef;


{/*
 * MyOrbitPlaneFunc
 *
 * This is the actual camera control function, the real worker of the plugin.
 * It is called each time X-Plane needs to draw a frame.
 *
 */}
function MyOrbitPlaneFunc(  outCameraPosition : PXPLMCameraPosition_t; // Can be NULL
                            inIsLosingControl : integer;
                            inRefcon          : pointer ) : integer;
                            cdecl;
var
  w, h, x, y : integer;
  dx, dz, dy, heading, pitch : single;   // float
begin
  if (outCameraPosition <> nil) and (inIsLosingControl=0) then
  begin
    //* First get the screen size and mouse location.  We will use this to decide
    //* what part of the orbit we are in.  The mouse will move us up-down and around.
    XPLMGetScreenSize(@w, @h);
    XPLMGetMouseLocation(@x, @y);
    heading := 360.0 * x / w;
    pitch   :=  20.0 * ((  y / h) * 2.0 - 1.0);

    {/* Now calculate where the camera should be positioned to be 200
      * meters from the plane and pointing at the plane at the pitch and
      * heading we wanted above. */}
    dx := -200.0 * sin(heading * 3.1415 / 180.0);
    dz := 200.0 * cos(heading * 3.1415 / 180.0);
    dy := -200 * tan(pitch * 3.1415 / 180.0);

    //* Fill out the camera position info.
    outCameraPosition.x := XPLMGetDataf(gPlaneX) + dx;
    outCameraPosition.y := XPLMGetDataf(gPlaneY) + dy;
    outCameraPosition.z := XPLMGetDataf(gPlaneZ) + dz;
    outCameraPosition.pitch := pitch;
    outCameraPosition.heading := heading;
    outCameraPosition.roll := 0;

  end;

  //* Return 1 to indicate we want to keep controlling the camera. 
  result := 1;
end;



procedure MyHotKeyCallback( inRefcon : pointer ); cdecl
begin
  //* This is the hotkey callback.  First we simulate a joystick press and
  // * release to put us in 'free view 1'.  This guarantees that no panels
  // * are showing and we are an external view. 
  XPLMCommandButtonPress(xplm_joy_v_fr1);
  XPLMCommandButtonRelease(xplm_joy_v_fr1);

  //* Now we control the camera until the view changes. 
  XPLMControlCamera(xplm_ControlCameraUntilViewChanges, @MyOrbitPlaneFunc, nil);
end;


procedure MyHandleKeyCallback(	inFromWho : XPLMPluginID;
	   			inMessage : longint;
		  		inParam   : pointer); cdecl;
begin
  // nothing to do
end;




{/*
 * XPluginStart
 *
 * Our start routine registers our window and does any other initialization we
 * must do.
 *
 */}
function XPluginStart( outName : PChar;
                       outSig  : PChar;
                       outDesc : PChar ) : integer; cdecl;
begin
  StrPCopy( outName, 'Camera' );
  StrPCopy( outSig,  'Delphi\SampleCode\Camera' );
  StrPCopy( outDesc, 'A plugin that adds a camera view. Press F8 for the view' );

  //* Prefetch the sim variables we will use. 
  gPlaneX := XPLMFindDataRef('sim/flightmodel/position/local_x');
  gPlaneY := XPLMFindDataRef('sim/flightmodel/position/local_y');
  gPlaneZ := XPLMFindDataRef('sim/flightmodel/position/local_z');

  //* Register our hot key for the new view.
  gHotKey := XPLMRegisterHotKey( Chr(XPLM_VK_F8), xplm_DownFlag,
                                 'Circling External View',
                                 @MyHotKeyCallback,
                                 nil);
  result :=1;
end;



{/*
 * XPluginStop
 *
 * Our cleanup routine deallocates our window.
 *
 */}
procedure XPluginStop; cdecl;
begin
  // cleanup code comes here
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
procedure XPluginReceiveMessage(  inFromWho : XPLMPluginID;
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
