/*
 * DrawingHook.c
 * 
 * DrawingHook draws a 3-d set of purple axes along the OpenGL coordinate axes centered on the 
 * user's plane.  This effect is easily seen from the external 'a' or '|' views.
 * 
 */

#if IBM
#include <windows.h>
#endif
#if LIN
#include <GL/gl.h>
#else
#if __GNUC__
#include <OpenGL/gl.h>
#else
#include <gl.h>
#endif
#endif
#include <string.h>
#include "XPLMDisplay.h"
#include "XPLMDataAccess.h"
#include "XPLMGraphics.h"

/* We have 3 data refs for the position along 3 axes of the plane in 
 * OpenGL coordinate space. */

XPLMDataRef		gPlaneX;
XPLMDataRef		gPlaneY;
XPLMDataRef		gPlaneZ;

int	MyDrawCallback(
                                   XPLMDrawingPhase     inPhase,    
                                   int                  inIsBefore,    
                                   void *               inRefcon);

PLUGIN_API int XPluginStart(
						char *		outName,
						char *		outSig,
						char *		outDesc)
{
	/* First record our plugin information. */
	strcpy(outName, "DrawingHook");
	strcpy(outSig, "xplanesdk.examples.drawinghook");
	strcpy(outDesc, "A plugin that draws at a low level.");
	
	/* Next register teh drawing callback.  We want to be drawn 
	 * after X-Plane draws its 3-d objects. */
	XPLMRegisterDrawCallback(
					MyDrawCallback,	
					xplm_Phase_Objects, 	/* Draw when sim is doing objects */
					0,						/* After objects */
					NULL);					/* No refcon needed */
					
	/* Also look up our data refs. */
	gPlaneX = XPLMFindDataRef("sim/flightmodel/position/local_x");
	gPlaneY = XPLMFindDataRef("sim/flightmodel/position/local_y");
	gPlaneZ = XPLMFindDataRef("sim/flightmodel/position/local_z");

	return 1;
}

PLUGIN_API void	XPluginStop(void)
{
	/* Unregitser the callback on quit. */
	XPLMUnregisterDrawCallback(
					MyDrawCallback,
					xplm_Phase_LastCockpit, 
					0,
					NULL);	
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

/*
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
 */

int	MyDrawCallback(
                                   XPLMDrawingPhase     inPhase,    
                                   int                  inIsBefore,    
                                   void *               inRefcon)
{
		float planeX, planeY, planeZ;

	/* If any data refs are missing, do not draw. */
	if (!gPlaneX || !gPlaneY || !gPlaneZ)
		return 1;
		
	/* Fetch the plane's location at this instant in OGL coordinates. */	
	planeX = XPLMGetDataf(gPlaneX);
	planeY = XPLMGetDataf(gPlaneY);
	planeZ = XPLMGetDataf(gPlaneZ);
	
	/* Reset the graphics state.  This turns off fog, texturing, lighting,
	 * alpha blending or testing and depth reading and writing, which
	 * guarantees that our axes will be seen no matter what. */
	XPLMSetGraphicsState(0, 0, 0, 0, 0, 0, 0);

	/* Set the color to magenta.  Note that magenta is NOT naturally 
	 * transparent when pluings draw!!  The magenta=transparent 
	 * convention is provided by X-Plane for some bitmaps only.  */
	glColor3f(1.0, 0.0, 1.0);
	
	/* Do the actual drawing.  use GL_LINES to draw sets of discrete lines.
	 * Each one will go 100 meters in any direction from the plane. */
	glBegin(GL_LINES);
	glVertex3f(planeX - 100, planeY, planeZ);
	glVertex3f(planeX + 100, planeY, planeZ);
	glVertex3f(planeX, planeY - 100, planeZ);
	glVertex3f(planeX, planeY + 100, planeZ);
	glVertex3f(planeX, planeY, planeZ - 100);
	glVertex3f(planeX, planeY, planeZ + 100);
	glEnd();
		
	return 1;
}                                   
