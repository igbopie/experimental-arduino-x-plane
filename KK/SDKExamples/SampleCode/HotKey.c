/*
 * HotKey.c
 * 
 * This code shows how to implement a trivial hot key.  A hot key is a mappable command
 * key the user can press; in this case, this plugin maps F1 being pressed down to getting 
 * the sim to say stuff.
 * 
 */

#include <string.h>
#include "XPLMDisplay.h"
#include "XPLMUtilities.h"

XPLMHotKeyID	gHotKey = NULL;

void	MyHotKeyCallback(void *               inRefcon);    

PLUGIN_API int XPluginStart(
						char *		outName,
						char *		outSig,
						char *		outDesc)
{
	strcpy(outName, "HotKey");
	strcpy(outSig, "xplanesdk.examples.hotkey");
	strcpy(outDesc, "A plugin that talks in response to a hot key.");

	/* Setting up a hot key is quite easy; we simply register a callback.
	 * We also provide a text description so that the plugin manager can
	 * list the hot key in the hot key mapping dialog box. */
	gHotKey = XPLMRegisterHotKey(XPLM_VK_F1, xplm_DownFlag, 
				"Says 'Hello World'",
				MyHotKeyCallback,
				NULL);
	return 1;
}

PLUGIN_API void	XPluginStop(void)
{
	XPLMUnregisterHotKey(gHotKey);
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

void	MyHotKeyCallback(void *               inRefcon)
{
	/* This is our hot key handler.  Note that we don't know what key stroke
	 * was pressed!  We can identify our hot key by the 'refcon' value though.
	 * This is because our hot key could have been remapped by the user and we 
	 * wouldn't know it. */
	XPLMSpeakString("Hello World!");
}