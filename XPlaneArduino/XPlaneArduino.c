/*
 * HellWorld.c
 * 
 * This plugin implements the canonical first program.  In this case, we will 
 * create a window that has the text hello-world in it.  As an added bonus
 * the  text will change to 'This is a plugin' while the mouse is held down
 * in the window.  
 * 
 * This plugin demonstrates creating a window and writing mouse and drawing
 * callbacks for that window.
 * 
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h> 
#include <stdint.h>   /* String function definitions */
#include <unistd.h>   /* UNIX standard function definitions */
#include <fcntl.h>    /* File control definitions */
#include <errno.h>    /* Error number definitions */
#include <termios.h>  /* POSIX terminal control definitions */
#include <sys/ioctl.h>
#include <getopt.h>
#include <dirent.h>

#include "XPLMDisplay.h"
#include "XPLMGraphics.h"
#include "XPLMUtilities.h"
#include "XPLMDataAccess.h"
#include "XPLMProcessing.h"

#define FALSE 0
#define TRUE 1

/* Number of seconds to delay before writing next flight data record*/
static const float REFRESH_INTERVAL = .1; //100 ms
/*
 * Global Variables.  We will store our single window globally.  We also record
 * whether the mouse is down from our mouse handler.  The drawing handler looks
 * at this information and draws the appropriate display.
 * 
 */

XPLMWindowID	gWindow = NULL;
int				gClicked = 0;
/* Name of the arduino device */
char deviceName[255];
/* FD index read/write arduino */
int fd = 0;

/* SIM VARIABLES DATAREFs*/
XPLMDataRef		gearDeployRatio = NULL;
XPLMDataRef		gearDeploySwitch = NULL;
XPLMDataRef		planeIAS = NULL;
XPLMDataRef     planeAlt    = NULL;
XPLMDataRef     planePitch   = NULL;
XPLMDataRef     planeRoll   = NULL;
XPLMDataRef     planeHeading = NULL;
XPLMDataRef     planeVSpeed = NULL;
/* FROM SIM VARIABLES*/
int gear1; //gearDeployRatio
int gear2; //gearDeployRatio
int gear3; //gearDeployRatio
float planeIASValue = 0;
float planeAltValue    = 0;
float planePitchValue   = 0;
float planeRollValue   = 0;
float planeHeadingValue = 0;
float planeVSpeedValue = 0;


/* TO SIM VARIABLES */ 
int gearBoolean; //gearDeploySwitch




float MyFlightLoopCallback( float inElapsedSinceLastCall,
                           float inElapsedTimeSinceLastFlightLoop,
                           int inCounter,
                           void *inRefcon);

int serialport_init(const char* serialport, int baud);
int serialport_writebyte(int fd, uint8_t b);
int serialport_readbyte( int fd);
int serialport_writeint( int fd, uint16_t b);


/*
 * XPluginStart
 * 
 * Our start routine registers our window and does any other initialization we 
 * must do.
 * 
 */
PLUGIN_API int XPluginStart(
						char *		outName,
						char *		outSig,
						char *		outDesc)
{
	/* First we must fill in the passed in buffers to describe our
	 * plugin to the plugin-system. */

	strcpy(outName, "XPlaneArduino");
	strcpy(outSig, "com.ignaciobona.xplanearduino");
	strcpy(outDesc, "A plugin that connects an arduino to display data");
    
    
    
  
    
    /* Variables */
    DIR *dirp= opendir("/dev");
    struct dirent *direntp;

    int found=FALSE;
    

    while ((direntp = readdir(dirp)) != NULL) {
        if( strstr(direntp->d_name,"tty.usbmodem") != NULL){
            strcat(deviceName,"/dev/");
            strcat(deviceName,direntp->d_name);
            found=TRUE;
            break;
        }
        //printf("%d\t%d\t%d\t%s\n", direntp->d_ino, direntp->d_off, direntp->d_reclen, direntp->d_name);
    }

    /* Cerramos el directorio */
    closedir(dirp);

    XPLMSpeakString(deviceName);
    if(found){
    
        /* We must return 1 to indicate successful initialization, otherwise we
         * will not be called back again. */
        gearDeployRatio = XPLMFindDataRef("sim/flightmodel2/gear/deploy_ratio");
        gearDeploySwitch = XPLMFindDataRef("sim/cockpit/switches/gear_handle_status");
        planeIAS     = XPLMFindDataRef("sim/cockpit2/gauges/indicators/airspeed_kts_pilot");
        planeAlt     = XPLMFindDataRef("sim/cockpit2/gauges/indicators/altitude_ft_pilot");
        planePitch   = XPLMFindDataRef("sim/cockpit2/gauges/indicators/pitch_AHARS_deg_pilot");
        planeRoll    = XPLMFindDataRef("sim/cockpit2/gauges/indicators/turn_rate_roll_deg_pilot");
        planeHeading = XPLMFindDataRef("sim/cockpit2/gauges/indicators/compass_heading_deg_mag");
        planeVSpeed = XPLMFindDataRef("sim/cockpit2/gauges/indicators/vvi_fpm_pilot");
        
        fd = serialport_init(deviceName, 9600);
        
        if(fd>0){
            XPLMRegisterFlightLoopCallback(
                                           MyFlightLoopCallback,	/* Callback */
                                           REFRESH_INTERVAL,		/* Interval */
                                           NULL);					/* refcon not used. */
            
            return 1;
        }
    }
    return 1;
    
}

/*
 * XPluginStop
 * 
 * Our cleanup routine deallocates our window.
 * 
 */
PLUGIN_API void	XPluginStop(void)
{
	XPLMDestroyWindow(gWindow);
}

/*
 * XPluginDisable
 * 
 * We do not need to do anything when we are disabled, but we must provide the handler.
 * 
 */
PLUGIN_API void XPluginDisable(void)
{
}

/*
 * XPluginEnable.
 * 
 * We don't do any enable-specific initialization, but we must return 1 to indicate
 * that we may be enabled at this time.
 * 
 */
PLUGIN_API int XPluginEnable(void)
{
	return 1;
}

/*
 * XPluginReceiveMessage
 * 
 * We don't have to do anything in our receive message handler, but we must provide one.
 * 
 */
PLUGIN_API void XPluginReceiveMessage(
					XPLMPluginID	inFromWho,
					long			inMessage,
					void *			inParam)
{
}

                                



float MyFlightLoopCallback( float inElapsedSinceLastCall,
                           float inElapsedTimeSinceLastFlightLoop,
                           int inCounter,
                           void *inRefcon)
{
    if(fd>0){
        float gear[3];
        /* FROM SIM*/
        planePitchValue = XPLMGetDataf(planePitch);
        planeRollValue = XPLMGetDataf(planeRoll);
        planeHeadingValue = XPLMGetDataf(planeHeading);
        planeIASValue = XPLMGetDataf(planeIAS);
        planeAltValue=XPLMGetDataf(planeAlt);
        planeVSpeedValue=XPLMGetDataf(planeVSpeed);

        XPLMGetDatavf(gearDeployRatio, gear, 0, 3);
        gear1=gear[0]*255;
        gear2=gear[1]*255;
        gear3=gear[2]*255;

        
        gearBoolean= XPLMGetDatai(gearDeploySwitch);
        
        
        /* WRITE DATA TO ARDUINO */
        serialport_writebyte(fd,gear1);
        serialport_writebyte(fd,gear2);
        serialport_writebyte(fd,gear3);
        serialport_writeint(fd,(int)planePitchValue);
        serialport_writeint(fd,(int)planeRollValue);
        serialport_writeint(fd,(int)planeHeadingValue);
        serialport_writeint(fd,(int)planeIASValue);
        serialport_writeint(fd,(int)planeAltValue);
        serialport_writeint(fd,(int)planeVSpeedValue);          
        /* TO SIM*/
        gearBoolean= XPLMGetDatai(gearDeploySwitch);
        gearBoolean=serialport_readbyte(fd);
        XPLMSetDatai(gearDeploySwitch,gearBoolean);
    }
    
    
    //char log[500];
    //sprintf(log,"Plugin debug: Gear status: %u Gear switch: %u",gear1,gearBoolean);
    //XPLMSpeakString(log);
    
    /*  Return Time interval that we want to be called again. */
	return REFRESH_INTERVAL;

}


// takes the string name of the serial port (e.g. "/dev/tty.usbserial","COM1")
// and a baud rate (bps) and connects to that port at that speed and 8N1.
// opens the port in fully raw mode so you can send binary data.
// returns valid fd, or -1 on error
int serialport_init(const char* serialport, int baud)
{
    struct termios toptions;
    int fd;
    
    //fprintf(stderr,"init_serialport: opening port %s @ %d bps\n",
    //        serialport,baud);
    
    fd = open(serialport, O_RDWR | O_NOCTTY | O_NDELAY);
    if (fd == -1)  {
        perror("init_serialport: Unable to open port ");
        return -1;
    }
    
    if (tcgetattr(fd, &toptions) < 0) {
        perror("init_serialport: Couldn't get term attributes");
        return -1;
    }
    speed_t brate = baud; // let you override switch below if needed
    switch(baud) {
        case 4800:   brate=B4800;   break;
        case 9600:   brate=B9600;   break;
#ifdef B14400
        case 14400:  brate=B14400;  break;
#endif
        case 19200:  brate=B19200;  break;
#ifdef B28800
        case 28800:  brate=B28800;  break;
#endif
        case 38400:  brate=B38400;  break;
        case 57600:  brate=B57600;  break;
        case 115200: brate=B115200; break;
    }
    cfsetispeed(&toptions, brate);
    cfsetospeed(&toptions, brate);
    
    // 8N1
    toptions.c_cflag &= ~PARENB;
    toptions.c_cflag &= ~CSTOPB;
    toptions.c_cflag &= ~CSIZE;
    toptions.c_cflag |= CS8;
    // no flow control
    toptions.c_cflag &= ~CRTSCTS;
    
    toptions.c_cflag |= CREAD | CLOCAL;  // turn on READ & ignore ctrl lines
    toptions.c_iflag &= ~(IXON | IXOFF | IXANY); // turn off s/w flow ctrl
    
    toptions.c_lflag &= ~(ICANON | ECHO | ECHOE | ISIG); // make raw
    toptions.c_oflag &= ~OPOST; // make raw
    
    // see: http://unixwiz.net/techtips/termios-vmin-vtime.html
    toptions.c_cc[VMIN]  = 0;
    toptions.c_cc[VTIME] = 20;
    
    if( tcsetattr(fd, TCSANOW, &toptions) < 0) {
        perror("init_serialport: Couldn't set term attributes");
        return -1;
    }
    
    return fd;
}

int serialport_writebyte( int fd, uint8_t b)
{
    int n = write(fd,&b,1);
    if( n!=1)
        return -1;
    return 0;
}
int serialport_writeint( int fd, uint16_t b)
{
    int n = write(fd,&b,2);
    if( n!=1)
        return -1;
    return 0;
}

int serialport_readbyte( int fd)
{
    int byte=0;
    int n = read(fd,&byte,1);
    if( n!=1)
        return -1;
    return byte;
}