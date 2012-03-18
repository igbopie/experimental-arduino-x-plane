#include <string.h>
#include <math.h>
#include "XPLMDisplay.h"
#include "XPLMGraphics.h"
#include "XPLMCamera.h"
#include "XPLMPlanes.h"
#include "XPLMUtilities.h"
#include "XPLMDataAccess.h"
#if LIN
#include <GL/gl.h>
#else
#if __GNUC__
#include <OpenGL/gl.h>
#else
#include <gl.h>
#endif
#endif
#include "AircraftUtils.h"

XPLMDataRef		gPlaneX = NULL;
XPLMDataRef		gPlaneY = NULL;
XPLMDataRef		gPlaneZ = NULL;
XPLMDataRef		gPlaneTheta = NULL;
XPLMDataRef		gPlanePhi = NULL;
XPLMDataRef		gPlanePsi = NULL;
XPLMDataRef		gOverRidePlanePosition = NULL;
XPLMDataRef		gAGL = NULL;

const	double	kMaxPlaneDistance = 5280.0 / 3.2 * 10.0;
const	double	kFullPlaneDist = 5280.0 / 3.2 * 3.0;

static	inline float sqr(float a) { return a * a; }

static	inline	float	CalcDist3D(float x1, float y1, float z1, float x2, float y2, float z2)
{
	return sqrt(sqr(x2-x1) + sqr(y2-y1) + sqr(z2-z1));
}

const	double	kFtToMeters = 0.3048;

static	XPLMDataRef	gFOVDataRef = NULL;
char *pAircraft[9];

Aircraft Aircraft1(1);
Aircraft Aircraft2(2);
Aircraft Aircraft3(3);
Aircraft Aircraft4(4);
Aircraft Aircraft5(5);
Aircraft Aircraft6(6);
Aircraft Aircraft7(7);

int	AircraftDrawCallback(	XPLMDrawingPhase     inPhase,    
                            int                  inIsBefore,    
                            void *               inRefcon);

PLUGIN_API int XPluginStart(	char *		outName,
								char *		outSig,
								char *		outDesc)
{
	int	planeCount;
	XPLMCountAircraft(&planeCount, 0, 0);


	strcpy(outName, "DrawAircraft");
	strcpy(outSig, "xplanesdk.examples.drawaircraft");
	strcpy(outDesc, "A plugin that draws aircraft.");

	/* Prefetch the sim variables we will use. */
	gPlaneX = XPLMFindDataRef("sim/flightmodel/position/local_x");
	gPlaneY = XPLMFindDataRef("sim/flightmodel/position/local_y");
	gPlaneZ = XPLMFindDataRef("sim/flightmodel/position/local_z");
	gPlaneTheta = XPLMFindDataRef("sim/flightmodel/position/theta");
	gPlanePhi = XPLMFindDataRef("sim/flightmodel/position/phi");
	gPlanePsi = XPLMFindDataRef("sim/flightmodel/position/psi");
	gOverRidePlanePosition = XPLMFindDataRef("sim/operation/override/override_planepath");
	gAGL = XPLMFindDataRef("sim/flightmodel/position/y_agl");

	/* Next register the drawing callback.  We want to be drawn
	 * after X-Plane draws its 3-d objects. */
	XPLMRegisterDrawCallback(
					AircraftDrawCallback,
					xplm_Phase_Objects, 	/* Draw when sim is doing objects */
					0,						/* After objects */
					NULL);					/* No refcon needed */

/*
	char FileName[256], AircraftPath[256];

	for (long index = 0; index < planeCount; ++index)
	{
		XPLMGetNthAircraftModel(index, FileName, AircraftPath);
		pAircraft[index] = (char *)AircraftPath;

		if (XPLMAcquirePlanes((char **)&pAircraft, NULL, NULL))
			XPLMSetAircraftModel(index, AircraftPath);
	}
*/

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

PLUGIN_API void XPluginReceiveMessage(	XPLMPluginID	inFromWho,
										long			inMessage,
										void *			inParam)
{
}

/*
 * AircraftDrawCallback
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

int	AircraftDrawCallback(	XPLMDrawingPhase     inPhase,
                            int                  inIsBefore,
                            void *               inRefcon)
{
	int	GearState;

	double	x,y,z,theta,phi,psi;

	double Lat = 34.09, Lon = -117.25, Alt = 1170;
	float Heading = 0, Pitch = 0, Roll = 0, Altitude;

	x = XPLMGetDataf(gPlaneX);
	y = XPLMGetDataf(gPlaneY);
	z = XPLMGetDataf(gPlaneZ);
	theta = XPLMGetDataf(gPlaneTheta);
	phi = XPLMGetDataf(gPlanePhi);
	psi = XPLMGetDataf(gPlanePsi);
	Altitude = XPLMGetDataf(gAGL);

	Aircraft1.plane_x = x + 50.0;
	Aircraft1.plane_y = y;
	Aircraft1.plane_z = z + 50.0;
	Aircraft1.plane_the = theta;
	Aircraft1.plane_phi = phi;
	Aircraft1.plane_psi = psi;

	Aircraft2.plane_x = x - 50.0;
	Aircraft2.plane_y = y;
	Aircraft2.plane_z = z - 50.0;
	Aircraft2.plane_the = theta;
	Aircraft2.plane_phi = phi;
	Aircraft2.plane_psi = psi;

	Aircraft3.plane_x = x + 50.0;
	Aircraft3.plane_y = y;
	Aircraft3.plane_z = z - 50.0;
	Aircraft3.plane_the = theta;
	Aircraft3.plane_phi = phi;
	Aircraft3.plane_psi = psi;

	Aircraft4.plane_x = x - 50.0;
	Aircraft4.plane_y = y;
	Aircraft4.plane_z = z + 50.0;
	Aircraft4.plane_the = theta;
	Aircraft4.plane_phi = phi;
	Aircraft4.plane_psi = psi;

	Aircraft5.plane_x = x + 100.0;
	Aircraft5.plane_y = y;
	Aircraft5.plane_z = z + 100.0;
	Aircraft5.plane_the = theta;
	Aircraft5.plane_phi = phi;
	Aircraft5.plane_psi = psi;

	Aircraft6.plane_x = x - 100.0;
	Aircraft6.plane_y = y;
	Aircraft6.plane_z = z - 100.0;
	Aircraft6.plane_the = theta;
	Aircraft6.plane_phi = phi;
	Aircraft6.plane_psi = psi;

	Aircraft7.plane_x = x + 100.0;
	Aircraft7.plane_y = y;
	Aircraft7.plane_z = z - 100.0;
	Aircraft7.plane_the = theta;
	Aircraft7.plane_phi = phi;
	Aircraft7.plane_psi = psi;

	if (Altitude > 200)
		GearState = 0;
	else
		GearState = 1;

	/// Changed from 5 to 6 - Sandy Barbour 18/01/2005
	/// This will be changed to handle versions when the
	/// increase to 10 is implemented in the glue.
	for (int Gear=0; Gear<6; Gear++)
	{
		Aircraft1.plane_gear_deploy[Gear] = GearState;
		Aircraft2.plane_gear_deploy[Gear] = GearState;
		Aircraft3.plane_gear_deploy[Gear] = GearState;
		Aircraft4.plane_gear_deploy[Gear] = GearState;
		Aircraft5.plane_gear_deploy[Gear] = GearState;
		Aircraft6.plane_gear_deploy[Gear] = GearState;
		Aircraft7.plane_gear_deploy[Gear] = GearState;
	}

	Aircraft1.SetAircraftData();
	Aircraft2.SetAircraftData();
	Aircraft3.SetAircraftData();
	Aircraft4.SetAircraftData();
	Aircraft5.SetAircraftData();
	Aircraft6.SetAircraftData();
	Aircraft7.SetAircraftData();

	return 1;
}
