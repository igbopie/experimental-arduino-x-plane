library DelphiMenus;

{************* X-Plane SDK : Delphi Sample Code ***************************
file    : DelphiMenus.dpr
version : 1.0
author  : Billy Verreynne <vslabs@onwe.co.za>
licence : Code released as freeware without any restrictions.
Kylix Port : Sandy Barbour

DECSRIPTION
--------------------------------------------------------------------------------
This code demonstrates how to XPLM menu API works. Via the API you can create
your own menus, add submenus (either to your own, or the default PLUGIN menu),
add menu items and install a menu callback handler that is called when the user
selects your menu options.

When dealing with menus and menu items, we create our own menu structures. We
maintain them, handle them and dispose of them. The operation works as follows:

1. we create a global menu item structure containing what we want (a regular
   record structure, an object, a regular variable, whatever)

2. we tell XPLM we want a menu item and give it a pointer to our structure

3. when the user clicks our menu item in X-Plane, XPLM calls us, and gives us
   the applicable pointer (our pointer)

4. we deref this pointer and access the struct we've created for that menu
   item option



************* X-Plane SDK : Delphi Sample Code ***************************}

uses
{$IFDEF MSWINDOWS}
  Windows,
//  Graphics,
{$ENDIF}
  SysUtils,
  Classes,
{$IFDEF MSWINDOWS}
  XPLMDataAccess in '..\..\..\..\SDK\Delphi\XPLM\XPLMDataAccess.pas',
  XPLMDefs in '..\..\..\..\SDK\Delphi\XPLM\XPLMDefs.pas',
  XPLMMenus in '..\..\..\..\SDK\Delphi\XPLM\XPLMMenus.pas',
  XPLMCamera in '..\..\..\..\SDK\Delphi\XPLM\XPLMCamera.pas';
{$ELSE}
  XPLMDataAccess in '../../../../SDK/Delphi/XPLM/XPLMDataAccess.pas',
  XPLMDefs in '../../../../SDK/Delphi/XPLM/XPLMDefs.pas',
  XPLMMenus in '../../../../SDK/Delphi/XPLM/XPLMMenus.pas',
  XPLMCamera in '../../../../SDK/Delphi/XPLM/XPLMCamera.pas';
{$ENDIF}

{$E xpl}

// {$R *.res}


// we define a menu item structure
type
  TXPMenuItem = record
    id   : integer;      // menu item number
    name : Pchar;        // menu item name
  end;
  PXPMenuItem = ^TXPMenuItem;

var
  myMenu        : XPLMMenuID;    // unique menu id for our plug-in
  mySubMenuItem : integer;       // unique id for the sub-menu we create
  gDataRef      : XPLMDataRef;   // data ref for the NAV1 radio freq

  // our custom plug-in menu item structures
  myItemNavInc : TXPMenuItem;
  myItemNavDec : TXPMenuItem;



// ADD MENU ITEM
// This procedure populates a menu item struct and adds our menu item to
// X-Plane
procedure AddMenuItem( menuItem : PXPMenuItem;
                       itemID   : integer;
                       itemName : string );
begin
  menuItem^.id := itemID;
  menuItem^.name := PChar(itemName);
	XPLMAppendMenuItem(
						myMenu,
            menuItem^.name,
					  menuItem,
						1);
end;


// This procedure serves as the callback function to handle our custom menus
// in X-Plane. Note the CDECL declare!
procedure MyMenuHandler(
                   inMenuRef : Pointer;
                   inItemRef : Pointer
                       ); cdecl;
var
  pMenu : Pinteger;      // vars to use to typecast untyped pointer to
  pItem : PXPMenuItem;
begin
  pMenu := inmenuRef;  // typecasting an untyped/raw pointer
  pItem := inItemRef;

  // if we're dealing with a null pointer, we can not deref and thus we're not
  // interested (this should not be happening!)
  if pItem = nil then exit;

  if gDataRef <> nil then
    XPLMSetDatai(gDataRef, XPLMGetDatai(gDataRef) +  pItem^.id );

end;


function XPluginStart( outName : PChar;
                       outSig  : PChar;
                       outDesc : PChar ) : integer; cdecl;
begin
  StrPCopy( outName, 'DelphiMenu' );
  StrPCopy( outSig,  'Delphi\SampleCode\Menus' );
  StrPCopy( outDesc, 'Delphi Menu Example' );

	// we put a new menu item into the plugin menu, this menu item will contain a
  // submenu for us. *
	mySubMenuItem := XPLMAppendMenuItem(
						XPLMFindPluginsMenu(),	// Put in plugins menu
						'Delphi Sim Data',	    // Item Title
						nil,	  			          // Item Ref
						1);						          // Force English

	// Now create a submenu attached to our menu item.
	myMenu := XPLMCreateMenu(
						'Delphi Sim Data',
						XPLMFindPluginsMenu(),
						mySubMenuItem, 			     // Menu Item to attach to.
						@MyMenuHandler,       	 // The handler
						nil);	 				           // Handler Ref

	// Append a few menu items to our submenu.  We will use the refcon to
	// store the amount we want to change the radio by.
  AddMenuItem( @myItemNavInc,  1000, 'Nav +');
  AddMenuItem( @myItemNavDec, -1000, 'Nav -');

	// Look up our data ref.  You find the string name of the data ref
	// in the master list of data refs, including in HTML form in the
	// plugin SDK.  In this case, we want the nav1 frequency.
	gDataRef := XPLMFindDataRef('sim/cockpit/radios/nav1_freq_hz');

  if gDataRef = nil then
  begin
    // we failed to get a ref to the nav1 freq - typically you will
    // put exception handling code here
  end;

  result := 1;
end;


// XPLUGINSTOP
// This method is called when the the Plug-In Manager terminates and X-Plane
// exits. It is the last call we get from X-Plane. We can consider
// this as the "destructor" for our plug-in DLL.
procedure XPluginStop; cdecl;
begin
  // MessageDlg( 'XpluginStop() called', mtInformation, [mbOK], 0 );
end;


// XPLUGINENABLE
// This method is called when the the Plug-In Manager gives us the okay
// to do our thing. This is the 2nd call we get from X-Plane. We can consider
// this as being activated
function XPluginEnable : integer; cdecl;
begin
  result := 1;
end;

// XPLUGINDISABLE
// This method is called when the the Plug-In Manager tell us to stop doing
// our thing. This is (usually?) the 2nd last call we get from X-Plane (the one
// just before being told to stop). This is similar to the TFORM class's CLOSE
// method (which gets called before the class's destructor).
procedure XPluginDisable; cdecl;
begin
  //MessageDlg( 'XpluginDisable() called', mtInformation, [mbOK], 0 );
end;

// XPluginReceiveMessage
// We don't have to do anything in our receive message handler, but we
// must provide one.
procedure XPluginReceiveMessage(
   					inFromWho : XPLMPluginID;
	   				inMessage : longint;
		  			inParam   : pointer); cdecl;
begin

end;



exports
  XPluginStop,
  XPluginStart,
  XPluginReceiveMessage,
  XPluginEnable,
  XPluginDisable;


begin
  // add enter DLL load code in here
end.


