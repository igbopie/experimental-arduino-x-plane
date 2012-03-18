---------------------------------------------------------------
The X-Plane Plug-In Manager System
Delphi SDK Samples Release 5 (01 Feb'03)
---------------------------------------------------------------

---------------------------------------------------------------
web    : http://xplane.aviate.org/xpsdk/
list   : http://groups.yahoo.com/group/x-plane-dev
---------------------------------------------------------------

---------------------------------------------------------------
NOTES:
---------------------------------------------------------------
1. The Delphi samples are .DPR (Delphi PRoject) files.
   These will compile as Win32 DLLs with the file extention
   .XPL - simply copy the .XPL file to your X-Plane Resources'
   plugin folder to use them.

2. All the documentation you need on the Delphi side, is in
   the .DPR files. I suggest that you look at the BASIC.DPR
   source file first. It contains all the basics you need to
   know to write and debug a XPLM plug-in using Delphi.

3. Resource files are not included. You will get a Delphi
   warning when opening the .DPR file the first time, as
   Delphi creates the .RES file for you. Not a problem.
   SOP. Ignore.

4. A HUGE thanks to Ben Supnik for doing the XML to Pascal
   conversion of the X-plane XPLM SDK. Ben, I owe you a pint
   or two of Knysna Foresters (the best draft made in South
   Africa ;-).

5. Any problems or errors with the Delphi portion of the
   XPLM SDK, please bug me, Billy, first, BEFORE you e-mail
   either Ben or Sandy.

   You can contact me at vslabs@onwe.co.za, or (even better)
   post your problem to the X-Plane Developers List at Yahoo.
   (http://groups.yahoo.com/group/x-plane-dev)
---------------------------------------------------------------

Widget Examples added by Sandy Barbour 13/12/2003

---------------------------------------------------------------
PAYLOAD
---------------------------------------------------------------
The following sources are included with the Delphi XPLM
SDK.

FOLDER           DESCRIPTION
============     =============================================
OpenGL           Contains the Delphi/Kylix Pascal wrapper(s)
                 for OpenGL (files gl.h glut.h and glx.h).

                 Released as part of Project JEDI under
                 the Mozilla 1.1 License.
============     =============================================
SampleCode       Contains various SDK Delphi source samples.
                 Ported from the C samples developed by
                 Ben Supnik and Sandy Barbour. Ported by
                 Billy Verreynne.

                 Released as freeware. No rights reserved.
============     =============================================
WidgetSampleCode Contains various SDK Delphi source samples.
                 Ported from the C samples developed by
                 Ben Supnik and Sandy Barbour. Ported by
                 Billy Verreynne.

                 Released as freeware. No rights reserved.
============     =============================================
XPSDK            Contains the XPLM Delphi wrappers. Generated
                 by Ben Supnik from the XPLM API Spefication
                 (in XLM format).

                 Released under the standard XPLM SDK license
                 as freeware with certain conditions. See the
                 LICENSE.TXT file of the XPLM SDK.
---------------------------------------------------------------



--
Billy Verreynne
vslabs@onwe.co.za
//eof