/*
 * Camera.c
 * 
 * This plugin registers a new view with the sim that orbits the aircraft.  We do this by:
 * 
 * 1. Registering a hotkey to engage the view.
 * 2. Setting the view to external when we are engaged.
 * 3. Registering a new camera control funcioin that ends when a new view is picked.
 * 
 */

#include <string.h>
#include "XPLMDisplay.h"
#include "XPLMUtilities.h"
#include "XPLMCamera.h"
#include "XPLMDataAccess.h"
#include "XPLMDisplay.h"
#include <stdio.h>
#include <math.h>

XPLMHotKeyID	gHotKey = NULL;
XPLMDataRef		gPlaneX = NULL;
XPLMDataRef		gPlaneY = NULL;
XPLMDataRef		gPlaneZ = NULL;


void	MyHotKeyCallback(void *               inRefcon);    
int 	MyOrbitPlaneFunc(
                                   XPLMCameraPosition_t * outCameraPosition,  
                                   int                  inIsLosingControl,    
                                   void *               inRefcon);    


PLUGIN_API int XPluginStart(
						char *		outName,
						char *		outSig,
						char *		outDesc)
{
	strcpy(outName, "Camera");
	strcpy(outSig, "xplanesdk.examples.camera");
	strcpy(outDesc, "A plugin that adds a camera view.");

	/* Prefetch the sim variables we will use. */
	gPlaneX = XPLMFindDataRef("sim/flightmodel/position/local_x");
	gPlaneY = XPLMFindDataRef("sim/flightmodel/position/local_y");
	gPlaneZ = XPLMFindDataRef("sim/flightmodel/position/local_z");

	/* Register our hot key for the new view. */
	gHotKey = XPLMRegisterHotKey(XPLM_VK_F8, xplm_DownFlag, 
				"Circling External View",
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
	/* This is the hotkey callback.  First we simulate a joystick press and
	 * release to put us in 'free view 1'.  This guarantees that no panels
	 * are showing and we are an external view. */
	XPLMCommandButtonPress(xplm_joy_v_fr1);
	XPLMCommandButtonRelease(xplm_joy_v_fr1);
	
	/* Now we control the camera until the view changes. */
	XPLMControlCamera(xplm_ControlCameraUntilViewChanges, MyOrbitPlaneFunc, NULL);
}

/*
 * MyOrbitPlaneFunc
 * 
 * This is the actual camera control function, the real worker of the plugin.  It is 
 * called each time X-Plane needs to draw a frame.
 * 
 */
int 	MyOrbitPlaneFunc(
                                   XPLMCameraPosition_t * outCameraPosition,   
                                   int                  inIsLosingControl,    
                                   void *               inRefcon)
{
	if (outCameraPosition && !inIsLosingControl)
	{
			int	w, h, x, y;
			float dx, dz, dy, heading, pitch;
			char	buf[256];
		
		/* First get the screen size and mouse location.  We will use this to decide
		 * what part of the orbit we are in.  The mouse will move us up-down and around. */
		XPLMGetScreenSize(&w, &h);
		XPLMGetMouseLocation(&x, &y);
		heading = 360.0 * (float) x / (float) w;
		pitch = 20.0 * (((float) y / (float) h) * 2.0 - 1.0);
		
		/* Now calculate where the camera should be positioned to be 200
		 * meters from the plane and pointing at the plane at the pitch and
		 * heading we wanted above. */
		dx = -200.0 * sin(heading * 3.1415 / 180.0);
		dz = 200.0 * cos(heading * 3.1415 / 180.0);
		dy = -200 * tan(pitch * 3.1415 / 180.0);
		
		/* Fill out the camera position info. */
		outCameraPosition->x = XPLMGetDataf(gPlaneX) + dx;
		outCameraPosition->y = XPLMGetDataf(gPlaneY) + dy;
		outCameraPosition->z = XPLMGetDataf(gPlaneZ) + dz;
		outCameraPosition->pitch = pitch;
		outCameraPosition->heading = heading;
		outCameraPosition->roll = 0;		

	}
	
	/* Return 1 to indicate we want to keep controlling the camera. */
	return 1;
}                                   
