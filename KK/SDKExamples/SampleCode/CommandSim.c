/*
 * CommandSim.c
 * 
 * This function demonstrates how to send commands to the sim.  Commands allow you to simulate
 * any keystroke or joystick button press or release.
 * 
 */

#include <stdio.h>
#include <string.h>
#include "XPLMMenus.h"
#include "XPLMUtilities.h"

void	MyMenuHandlerCallback(
                                   void *               inMenuRef,    
                                   void *               inItemRef);    

PLUGIN_API int XPluginStart(
						char *		outName,
						char *		outSig,
						char *		outDesc)
{
	XPLMMenuID	myMenu;
	int			mySubMenuItem;

	strcpy(outName, "CommandSim");
	strcpy(outSig, "xplanesdk.examples.commandsim");
	strcpy(outDesc, "A plugin that makes the command do things.");
	
	/* Create a menu for ourselves.  */
	mySubMenuItem = XPLMAppendMenuItem(
						XPLMFindPluginsMenu(),	/* Put in plugins menu */
						"Command Sim",				/* Item Title */
						0,						/* Item Ref */
						1);						/* Force English */
	
	myMenu = XPLMCreateMenu(
						"Command Sim", 
						XPLMFindPluginsMenu(), 
						mySubMenuItem, 			/* Menu Item to attach to. */
						MyMenuHandlerCallback,	/* The handler */
						0);						/* Handler Ref */

	/* For each command, we set the item refcon to be the key command ID we wnat
	 * to run.   Our callback will use this item refcon to do the right command.
	 * This allows us to write only one callback for the menu. */	 
	XPLMAppendMenuItem(myMenu, "Pause", (void *) xplm_key_pause, 1);
	XPLMAppendMenuItem(myMenu, "Reverse Thrust", (void *) xplm_key_revthrust, 1);
	XPLMAppendMenuItem(myMenu, "Jettison", (void *) xplm_key_jettison, 1);
	XPLMAppendMenuItem(myMenu, "Brakes (Regular)", (void *) xplm_key_brakesreg, 1);
	XPLMAppendMenuItem(myMenu, "Brakes (Full)", (void *) xplm_key_brakesmax, 1);
	XPLMAppendMenuItem(myMenu, "Landing Gear", (void *) xplm_key_gear, 1);
	return 1;
}

PLUGIN_API void	XPluginStop(void)
{
}

PLUGIN_API void XPluginDisable(void)
{
}

PLUGIN_API int XPluginEnable(void)
{
	return 1;
}

PLUGIN_API void XPluginReceiveMessage(
					XPLMPluginID	inFromWho,
					long			inMessage,
					void *			inParam)
{
}

void	MyMenuHandlerCallback(
                                   void *               inMenuRef,    
                                   void *               inItemRef)
{
	/* This is the menu callback.  We simply turn the item ref back
	 * into a command ID and tell the sim to do it. */
	XPLMCommandKeyStroke((XPLMCommandKeyID) inItemRef);
}
                                   
