library DrawingHook;

{************* X-Plane SDK : Delphi Sample Code ***************************
file    : DrawingHook.dpr
version : 1.0
author  : Billy Verreynne <vslabs@onwe.co.za>
licence : Code released as freeware without any restrictions.
Kylix port : Sandy Barbour


DECSRIPTION
 * DrawingHook draws a 3-d set of purple axes along the OpenGL coordinate axes
 * centered on the user's plane.  This effect is easily seen from the external
 * 'a' or '|' views.

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
  XPLMGraphics in '..\..\..\..\SDK\Delphi\XPLM\XPLMGraphics.pas',
  XPLMDataAccess in '..\..\..\..\SDK\Delphi\XPLM\XPLMDataAccess.pas',
  OpenGL12 in '..\..\OpenGL\OpenGL12.pas';
{$ELSE}
  XPLMDefs in '../../../../SDK/Delphi/XPLM/XPLMDefs.pas',
  XPLMDisplay in '../../../../SDK/Delphi/XPLM/XPLMDisplay.pas',
  XPLMGraphics in '../../../../SDK/Delphi/XPLM/XPLMGraphics.pas',
  XPLMDataAccess in '../../../../SDK/Delphi/XPLM/XPLMDataAccess.pas',
  OpenGL12 in '../../OpenGL/OpenGL12.pas';
{$ENDIF}

// The Delphi Compiler must create a file with a .XPL extention. The default
// extention for a Delphi library is .DLL - thus we use the $E compiler
// directive to override the default and change it to .XPL
{$E xpl}

// Default directive to include any RESOURCE files our project may have
// {$R *.res}

{/*
 * Global Variables.  We will store our single window globally.  We also record
 * whether the mouse is down from our mouse handler.  The drawing handler looks
 * at this information and draws the appropriate display.
 *
 */}


{/* We have 3 data refs for the position along 3 axes of the plane in
 * OpenGL coordinate space. */}
var
 gPlaneX : XPLMDataRef;
 gPlaneY : XPLMDataRef;
 gPlaneZ : XPLMDataRef;



 {/*
 * MyDrawCallback
 *
 * This is the actual drawing callback that does the work; for us it will
 * be called after X-Plane has drawn its 3-d objects.  The coordinate system
 * is 'normal' for 3-d drawing, meaning 0,0,0 is at the earth's surface at the
 * lat/lon reference point, with +Y = up, +Z = South, +X = East.  (Note that
 * these relationships are only true at 0,0,0 due to the Earth's curvature!!)
 *
 * Drawing hooks that draw before X-Plane return 1 to let X-Plane draw or 0
 * to inhibit drawing.  For drawing hooks that run after X-Plane, this return
 * value is ignored but we will return 1 anyway.
 *
 */}
function MyDrawCallback( inPhase    : XPLMDrawingPhase;
                         inIsBefore : integer;
                         inRefcon   : pointer ) : integer; cdecl;
var
  planeX,
  planeY,
  planeZ : single;   // IEEE float is called single in Pascal
begin
  //* If any data refs are missing, do not draw.
  if (gPlaneX = nil) or (gPlaneY = nil) or (gPlaneZ = nil) then
  begin
    result := 1;
    exit;
  end;

  //* Fetch the plane's location at this instant in OGL coordinates.
  planeX := XPLMGetDataf(gPlaneX);
  planeY := XPLMGetDataf(gPlaneY);
  planeZ := XPLMGetDataf(gPlaneZ);

  //* Reset the graphics state.  This turns off fog, texturing, lighting,
  //* alpha blending or testing and depth reading and writing, which
  //* guarantees that our axes will be seen no matter what.
  XPLMSetGraphicsState(0, 0, 0, 0, 0, 0, 0);

  //* Set the color to magenta.  Note that magenta is NOT naturally
  //* transparent when pluings draw!!  The magenta=transparent
  //* convention is provided by X-Plane for some bitmaps only.
  glColor3f(1.0, 0.0, 1.0);

  //* Do the actual drawing.  use GL_LINES to draw sets of discrete lines.
  //* Each one will go 100 meters in any direction from the plane.
  glBegin(GL_LINES);
  glVertex3f(planeX - 100, planeY, planeZ);
  glVertex3f(planeX + 100, planeY, planeZ);
  glVertex3f(planeX, planeY - 100, planeZ);
  glVertex3f(planeX, planeY + 100, planeZ);
  glVertex3f(planeX, planeY, planeZ - 100);
  glVertex3f(planeX, planeY, planeZ + 100);
  glEnd();

  result := 1;
end;



{/*
 * MyHandleKeyCallback
 *
 * Our key handling callback does nothing in this plugin.  This is ok;
 * we simply don't use keyboard input.
 *
 */}
procedure MyHandleKeyCallback(   inFromWho : XPLMPluginID;
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

  //* First record our plugin information.
  StrPCopy(outName, 'DrawingHook');
  StrPCopy( outSig,  'Delphi\SampleCode\DrawingHook' );
  StrPCopy(outDesc, 'A plugin that draws at a low level.');

  //* Next register teh drawing callback.  We want to be drawn
  //* after X-Plane draws its 3-d objects.
  XPLMRegisterDrawCallback(  MyDrawCallback,
                             xplm_Phase_Objects,     //* Draw when sim is doing objects
                             0,                      //* After objects
                             nil);                   //* No refcon needed

  //* Also look up our data refs.
  gPlaneX := XPLMFindDataRef('sim/flightmodel/position/local_x');
  gPlaneY := XPLMFindDataRef('sim/flightmodel/position/local_y');
  gPlaneZ := XPLMFindDataRef('sim/flightmodel/position/local_z');

  //* We must return 1 to indicate successful initialization, otherwise we
  //* will not be called back again.
  if LoadOpenGL then  // we need to initiliase the Delphi OpenGL Wrapper Library
     result := 1
  else
     result := 0;
end;



{/*
 * XPluginStop
 *
 * Our cleanup routine deallocates our window.
 *
 */}
procedure XPluginStop; cdecl;
begin
  //
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
