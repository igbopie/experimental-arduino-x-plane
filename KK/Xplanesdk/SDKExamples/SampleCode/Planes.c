/* This example plugin is not done yet, but should be posted on the web soon. */

#include "XPLMDisplay.h"
#include <string.h>

PLUGIN_API int XPluginStart(
						char *		outName,
						char *		outSig,
						char *		outDesc)
{
	strcpy(outName, "Planes");
	strcpy(outSig, "xplanesdk.examples.planes");
	strcpy(outDesc, "A plugin that alters multiplayer planes.");

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
