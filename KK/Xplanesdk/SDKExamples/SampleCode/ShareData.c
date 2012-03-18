/*
 * ShareData.c
 * 
 * This is an example plugin that demonstrates how to share data, both owned
 * by a plugin and shared.
 * 
 * Data can be published in two ways: a plugin can publish data it owns.
 * In this case, it provides callbacks to read (and optionally write) the
 * data.  As other plugins access the data ref, the SDK calls back the
 * accessors.
 * 
 * Data can also be shared.  In this case, the SDK allocates the memory
 * for the data.  Each plugin that shares it registers a callback that is
 * called by the SDK when any plugin writes the data.
 * 
 * We use the xplanesdk namespace to allocate unique data refs.  When creating
 * your own datarefs, make sure to prefix the data ref with a domain unique to
 * your organization.  'sim' is the domain for the main simulator.
 * 
 */

#include <stdio.h>
#include <string.h>
#include "XPLMDataAccess.h"
#include "XPLMUtilities.h"

/* This is the storage for the data we own. */
double	gOwnedData = 0.0;


XPLMDataRef	gOwnedDataRef = NULL;
XPLMDataRef	gSharedDataRef = NULL;

/* These callbacks are called by the SDK to read and write the sim.
 * We provide two sets of callbacks allowing our data to appear as
 * float and double.  This is done for didactic purposes; multityped
 * data is provided as a backward compatibility solution and probably
 * should not be used in initial designs as a convenience to client 
 * code.  */
float	MyGetDatafCallback(void * inRefcon);
void	MySetDatafCallback(void * inRefcon, float inValue);
double	MyGetDatadCallback(void * inRefcon);
void	MySetDatadCallback(void * inRefcon, double inValue);

/* This callback is called whenever our shared data is changed. */
void	MyDataChangedCallback(void * inRefcon);

PLUGIN_API int XPluginStart(
						char *		outName,
						char *		outSig,
						char *		outDesc)
{
	int RetVal;
	char Buffer[256];
	
	strcpy(outName, "SharedData");
	strcpy(outSig, "xplanesdk.examples.shareddata");
	strcpy(outDesc, "A plugin that shares a data ref.");

	/* Register our owned data.  Note that we pass two sets of
	 * function callbacks for two data types and leave the rest blank. */
	gOwnedDataRef = XPLMRegisterDataAccessor(
								"xplanesdk/examples/sharedata/number",
								xplmType_Float + xplmType_Double,			/* The types we support */
								1,											/* Writable */
								NULL, NULL,									/* No accessors for ints */
								MyGetDatafCallback, MySetDatafCallback,		/* Accessors for floats */
								MyGetDatadCallback, MySetDatadCallback,		/* Accessors for doubles */
								NULL, NULL,									/* No accessors for int arrays */
								NULL, NULL,									/* No accessors for float arrays */
								NULL, NULL,									/* No accessors for raw data */
								NULL, NULL);								/* Refcons not used */

	/* Subscribe to shared data.  If no one else has made it, this will 
	 * cause the SDK to allocate the data. */

	RetVal = XPLMShareData("xplanesdk/examples/sharedata/sharedint", xplmType_Int,
		MyDataChangedCallback, NULL);

	gSharedDataRef = XPLMFindDataRef("xplanesdk/examples/sharedata/sharedint");
	sprintf(Buffer, "ShareData 2 - gSharedDataRef := %x\n", gSharedDataRef);
	XPLMDebugString(Buffer);

	return 1;
}

PLUGIN_API void	XPluginStop(void)
{
	int RetVal;

	if (gOwnedDataRef)
		XPLMUnregisterDataAccessor(gOwnedDataRef);

	RetVal = XPLMUnshareData("xplanesdk/examples/sharedata/sharedint", xplmType_Int,
		MyDataChangedCallback, NULL);
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
 * These are the data accessors for our owned data.  
 * 
 */

float	MyGetDatafCallback(void * inRefcon)
{
	return gOwnedData;
}

void	MySetDatafCallback(void * inRefcon, float inValue)
{
	gOwnedData = inValue;
}

double	MyGetDatadCallback(void * inRefcon)
{
	return gOwnedData;
}

void	MySetDatadCallback(void * inRefcon, double inValue)
{
	gOwnedData = inValue;
}

/*
 * This is the callback for our shared data.  Right now we do not react
 * to our shared data being chagned.
 * 
 */

void	MyDataChangedCallback(void * inRefcon)
{
}