/*
 * Navigation.c
 * 
 * This example demonstrates how to use the FMC and the navigation databases in 
 * X-Plane.  
 * 
 */


#include "XPLMDisplay.h"
#include "XPLMMenus.h"
#include <stdio.h>
#include <string.h>
#include "XPLMUtilities.h"
#include "XPLMNavigation.h"
#include "XPLMDataAccess.h"

enum {
	
	nearestAirport = 1,
	programFMC = 2
	
};

void	MyMenuHandlerCallback(
                                   void *               inMenuRef,    
                                   void *               inItemRef);    

PLUGIN_API int XPluginStart(
						char *		outName,
						char *		outSig,
						char *		outDesc)
{
		int				mySubMenuItem;
		XPLMMenuID		myMenu;
	
	strcpy(outName, "Navigation");
	strcpy(outSig, "xplanesdk.examples.navigation");
	strcpy(outDesc, "A plugin that controls the FMC.");

	/* Register a menu and some items.  We will both program
	 * the FMC and find the nearest airport. */
	mySubMenuItem = XPLMAppendMenuItem(
						XPLMFindPluginsMenu(),	/* Put in plugins menu */
						"Navigation",				/* Item Title */
						0,						/* Item Ref */
						1);						/* Force English */
	
	myMenu = XPLMCreateMenu(
						"Navigation", 
						XPLMFindPluginsMenu(), 
						mySubMenuItem, 			/* Menu Item to attach to. */
						MyMenuHandlerCallback,	/* The handler */
						0);						/* Handler Ref */
	XPLMAppendMenuItem(
						myMenu,
						"Say nearest airport",
						(void *) nearestAirport,
						1);
	XPLMAppendMenuItem(
						myMenu,
						"Program FMC",
						(void *) programFMC,
						1);



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
	switch((int) inItemRef) {	
/*
 * This code finds the nearest airport.  We find the sim's latitude and longitude and use the
 * XPLMFindNavAid function to locate the nearest airport via a type-limited search.  We
 * then print out the information.
 * 
 */
	case nearestAirport:
		{
			/* First find the plane's position. */
			float lat = XPLMGetDataf(XPLMFindDataRef("sim/flightmodel/position/latitude"));
			float lon = XPLMGetDataf(XPLMFindDataRef("sim/flightmodel/position/longitude"));
			/* Find the nearest airport to us. */
			XPLMNavRef	ref = XPLMFindNavAid(NULL, NULL, &lat, &lon, NULL, xplm_Nav_Airport);
			if (ref != XPLM_NAV_NOT_FOUND)
			{
				/* If we found one, get its information, and say it. */
				char	id[10];
				char	name[256];
				char	buf[256];
				XPLMGetNavAidInfo(ref, NULL, &lat, &lon, NULL, NULL, NULL, id, name, NULL);
				sprintf(buf,"The nearest airport is '%s', \"%s\"\n", id, name);
				XPLMSpeakString(buf);
				XPLMDebugString(buf);
			} else {
				XPLMSpeakString("No airports were found!");
				XPLMDebugString("No airports were found!\n");
			}
			break;
		}
		break;
	case programFMC:
/*
 * This code programs the flight management computer.  We simply set each entry to a navaid
 * that we find by searching by name or ID.
 * 
 */	
		XPLMSetFMSEntryInfo(0, XPLMFindNavAid(NULL, "KBOS", NULL, NULL, NULL, xplm_Nav_Airport), 3000);
		XPLMSetFMSEntryInfo(1, XPLMFindNavAid(NULL, "LUCOS", NULL, NULL, NULL, xplm_Nav_Fix), 20000);
		XPLMSetFMSEntryInfo(2, XPLMFindNavAid(NULL, "SEY", NULL, NULL, NULL, xplm_Nav_VOR), 20000);
		XPLMSetFMSEntryInfo(3, XPLMFindNavAid(NULL, "PARCH", NULL, NULL, NULL, xplm_Nav_Fix), 20000);
		XPLMSetFMSEntryInfo(4, XPLMFindNavAid(NULL, "CCC", NULL, NULL, NULL, xplm_Nav_VOR), 12000);
		XPLMSetFMSEntryInfo(5, XPLMFindNavAid(NULL, "ROBER", NULL, NULL, NULL, xplm_Nav_Fix), 9000);
		XPLMSetFMSEntryInfo(6, XPLMFindNavAid(NULL,  "KJFK", NULL, NULL, NULL, xplm_Nav_Airport), 3000);
		XPLMClearFMSEntry(7);
		XPLMClearFMSEntry(8);
		break;
	}
}

