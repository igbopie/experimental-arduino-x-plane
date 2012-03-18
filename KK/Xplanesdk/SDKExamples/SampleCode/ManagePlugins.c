/*
 * ManagePlugins.c
 * 
 * This plugin demonstrates how to manage other plugins.  Most of the time you
 * won't have to do this.  In this plugin we either enable or disable all other
 * plugins.
 * 
 */

#include <stdio.h>
#include <string.h>
#include "XPLMPlugin.h"
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

	strcpy(outName, "ManagePlugins");
	strcpy(outSig, "xplanesdk.examples.manageplugins");
	strcpy(outDesc, "A plugin that manages other plugins.");

	/* Add menbu items to disable and enable plugins.  The refcon
	 * will distinguish which command we are doing. */

	mySubMenuItem = XPLMAppendMenuItem(
						XPLMFindPluginsMenu(),	/* Put in plugins menu */
						"Manage Plugins",				/* Item Title */
						0,						/* Item Ref */
						1);						/* Force English */
	
	myMenu = XPLMCreateMenu(
						"Manage Plugins", 
						XPLMFindPluginsMenu(), 
						mySubMenuItem, 			/* Menu Item to attach to. */
						MyMenuHandlerCallback,	/* The handler */
						0);						/* Handler Ref */

	XPLMAppendMenuItem(myMenu, "Disable Others", (void *) 0, 1);
	XPLMAppendMenuItem(myMenu, "Enable All", (void *) 1, 1);

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
	/* This is the menu handler.  We will go through each plugin. */

		long	n;

	for (n = 0; n < XPLMCountPlugins(); ++n)
	{
		char			str[128];
		XPLMPluginID	plugin = XPLMGetNthPlugin(n);
		XPLMPluginID	me = XPLMGetMyID();

		/* Check to see if the plugin is us.  If so, don't
		 * disable ourselves! */
		sprintf(str,"plugin=%d,me=%d\n",plugin, me);
		XPLMDebugString(str);
		if (plugin != me)
		{
			/* Disable based on the item ref for the menu. */
			if (inItemRef == NULL)
			{
				XPLMDisablePlugin(plugin);
			} else {
				XPLMEnablePlugin(plugin);
			}
		}
	}
}