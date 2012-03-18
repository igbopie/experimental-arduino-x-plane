library helloWorld;

{************* X-Plane SDK : Delphi Sample Code ***************************
file    : helloWorld.dpr
version : 1.0
author  : Billy Verreynne <vslabs@onwe.co.za>
licence : Code released as freeware without any restrictions.
Kylix Port : Sandy Barbour

DECSRIPTION
 * This plugin implements the canonical first program.  In this case, we will
 * create a window that has the text hello-world in it.  As an added bonus
 * the  text will change to 'This is a plugin' while the mouse is held down
 * in the window.
 *
 * This plugin demonstrates creating a window and writing mouse and drawing
 * callbacks for that window.

--------------------------------------------------------------------------------

************* X-Plane SDK : Delphi Sample Code ***************************}

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  SysUtils,
  Classes,
{$IFDEF MSWINDOWS}
  XPLMDefs in '..\..\..\..\SDK\Delphi\XPLM\XPLMDefs.pas',
  XPLMDisplay in '..\..\..\..\SDK\Delphi\XPLM\XPLMDisplay.pas',
  XPLMGraphics in '..\..\..\..\SDK\Delphi\XPLM\XPLMGraphics.pas';
{$ELSE}
  XPLMDefs in '../../../../SDK/Delphi/XPLM/XPLMDefs.pas',
  XPLMDisplay in '../../../../SDK/Delphi/XPLM/XPLMDisplay.pas',
  XPLMGraphics in '../../../../SDK/Delphi/XPLM/XPLMGraphics.pas';
{$ENDIF}


// The Delphi Compiler must create a file with a .XPL extention. The default
// extention for a Delphi library is .DLL - thus we use the $E compiler
// directive to override the default and change it to .XPL
{$E xpl}

// Default directive to include any RESOURCE files our project may have
{$R *.res}

{/*
 * Global Variables.  We will store our single window globally.  We also record
 * whether the mouse is down from our mouse handler.  The drawing handler looks
 * at this information and draws the appropriate display.
 *
 */}


// The Delphi Compiler is kewl. This is proven by the fact that in C++ you
// need to code defaults (as shown below) for var's to initialise them (and
// prevent a pointer to point to some arbritary random address). Delphi does
// this for you - pointers are defaulted to null for example. However, Delphi
// allows you to assign your own defaults, like below.
// Now is that kewl, or what? C++ drools. Delphi rules! :-)
var
  gWindow   : XPLMWindowID = nil;
  gClicked  : boolean      = false;

{/*
 * MyDrawingWindowCallback
 *
 * This callback does the work of drawing our window once per sim cycle each time
 * it is needed.  It dynamically changes the text depending on the saved mouse
 * status.  Note that we don't have to tell X-Plane to redraw us when our text
 * changes; we are redrawn by the sim continuously.
 *
 */}
procedure MyDrawWindowCallback(  inWindowID : XPLMWindowID;
                                 inRefcon   : pointer ); cdecl;
var
  left, top, right, bottom : integer;
  color : array[0..2] of single;
begin

  //* First we get the location of the window passed in to us.
  XPLMGetWindowGeometry(inWindowID, @left, @top, @right, @bottom);

  {/* We now use an XPLMGraphics routine to draw a translucent dark
    * rectangle that is our window's shape. */}
  XPLMDrawTranslucentDarkBox(left, top, right, bottom);

  {/* Finally we draw the text into the window, also using XPLMGraphics
    * routines.  The NULL indicates no word wrapping. */}
  color[0] := 1;
  color[1] := 1;
  color[2] := 1;

  if gClicked then
   	XPLMDrawString(
                  @color,           // color
                  left + 5,         // X offset
                  top - 20,         // Y offset
                  'I''m a plugin',  // char
                  nil,              // wordwrap?
                  xplmFont_Basic )  // font
  else
   	XPLMDrawString(
                  @color,           // color
                  left + 5,         // X offset
                  top - 20,         // Y offset
                  'Hello World',    // char
                  nil,              // wordwrap?
                  xplmFont_Basic ); // font

end;

{/*
 * MyHandleKeyCallback
 *
 * Our key handling callback does nothing in this plugin.  This is ok;
 * we simply don't use keyboard input.
 *
 */}
procedure MyHandleKeyCallback(  inFromWho : XPLMPluginID;
                                inMessage : longint;
                                inParam   : pointer); cdecl;
begin
  // nothing to do
end;


{*
 * MyHandleMouseClickCallback
 *
 * Our mouse click callback toggles the status of our mouse variable
 * as the mouse is clicked.  We then update our text on the next sim
 * cycle.
 *
 *}
function MyHandleMouseClickCallback(
                                   inWindowID : XPLMWindowID;
                                   x          : integer;
                                   y          : integer;
                                   inMouse    : XPLMMouseStatus;
                                   inRefcon   : pointer ) : integer;
                                   cdecl;
begin
  {/* If we get a down or up, toggle our status click.  We will
    * never get a down without an up if we accept the down. */}
  if (inMouse = xplm_MouseDown) or (inMouse = xplm_MouseUp) then
     gClicked := not( gClicked );

  {/* Returning 1 tells X-Plane that we 'accepted' the click; otherwise
    * it would be passed to the next window behind us.  If we accept
    * the click we get mouse moved and mouse up callbacks, if we don't
    * we do not get any more callbacks.  It is worth noting that we
    * will receive mouse moved and mouse up even if the mouse is dragged
    * out of our window's box as long as the click started in our window's
    * box. */}
  result := 1;
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
  {/* First we must fill in the passed in buffers to describe our
    * plugin to the plugin-system. */}
  StrPCopy( outName, 'HelloWorld' );
  StrPCopy( outSig,  'Delphi\SampleCode\helloWord' );
  StrPCopy( outDesc, 'A Delphi plugin that makes a window.' );


  {/* Now we create a window.  We pass in a rectangle in left, top,
    * right, bottom screen coordinates.  We pass in three callbacks. */}

  gWindow := XPLMCreateWindow( 50, 600, 300, 200,      //* Area of the window.
                               1,                      //* Start visible.
                               @MyDrawWindowCallback,  //* Callbacks
                               @MyHandleKeyCallback,
                               @MyHandleMouseClickCallback,
                               nil );                  //* Refcon - not used.

  {/* We must return 1 to indicate successful initialization, otherwise we
    * will not be called back again. */}
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
  XPLMDestroyWindow(gWindow);
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
procedure XPluginReceiveMessage( inFromWho : XPLMPluginID;
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
