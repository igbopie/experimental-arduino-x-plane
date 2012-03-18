all: Camera CommandSim DrawAircraft DrawingHook HelloWorld HotKey KeySniffer ManagePlugins Navigation Planes ShareData SimData TimedProcessing

clean: clean_Camera clean_CommandSim clean_DrawAircraft clean_DrawingHook clean_HelloWorld clean_HotKey clean_KeySniffer clean_ManagePlugins clean_Navigation clean_Planes clean_ShareData clean_SimData clean_TimedProcessing

##############################
#######  TARGET: Camera
##############################
TOP_Camera=../../..
WD_Camera=$(shell cd ${TOP_Camera};echo `pwd`)
c_SRC_Camera+=${WD_Camera}/SDKExamples/SampleCode/Camera.c

OBJS_Camera+=$(c_SRC_Camera:.c=.c.o)

CFLAGS_Camera+= -I./\
 -I../../../SDK/CHeaders/XPLM\
 -I../../../SDKExamples/SampleCode/\
 -I- -I/usr/include/\
  -DIBM=0 -DAPL=0 -DLIN=1

DBG=-g

CFLAGS_Camera+=-O0 -x c++ -ansi

clean_Camera:
	rm -f ${OBJS_Camera}

Camera:
	$(MAKE) -f SDKExamples.mk Camera.xpl TARGET=Camera.xpl\
	CC="g++"  LD="g++"  AR="ar -crs"  SIZE="size" LIBS+="-lGL -lGLU"

Camera.xpl: ${OBJS_Camera}
	${CC} -shared ${LDFLAGS} -o Release/Resources/plugins/Camera.xpl ${OBJS_Camera} ${LIBS}


ifeq (${TARGET}, Camera.xpl)

%.c.o: %.c
	gcc -c -fPIC ${CFLAGS_Camera} $< -o $@ -MMD
include $(c_SRC_Camera:.c=.d)

%.d: %.c
	set -e; $(CC) -M $(CFLAGS_Camera) $< \
 | sed 's!\($(*F)\)\.o[ :]*!$(*D)/\1.o $@ : !g' > $@; \
 [ -s $@ ] || rm -f $@

endif

##############################
#######  TARGET: CommandSim
##############################
TOP_CommandSim=../../..
WD_CommandSim=$(shell cd ${TOP_CommandSim};echo `pwd`)
c_SRC_CommandSim+=${WD_CommandSim}/SDKExamples/SampleCode/CommandSim.c

OBJS_CommandSim+=$(c_SRC_CommandSim:.c=.c.o)

CFLAGS_CommandSim+= -I./\
 -I../../../SDK/CHeaders/XPLM\
 -I../../../SDKExamples/SampleCode/\
 -I- -I/usr/include/\
 -DIBM=0 -DAPL=0 -DLIN=1

DBG=-g

CFLAGS_CommandSim+=-O0 -x c++ -ansi

clean_CommandSim:
	rm -f ${OBJS_CommandSim}

CommandSim:
	$(MAKE) -f SDKExamples.mk CommandSim.xpl TARGET=CommandSim.xpl\
	CC="g++"  LD="g++"  AR="ar -crs"  SIZE="size" LIBS+="-lGL -lGLU"

CommandSim.xpl: ${OBJS_CommandSim}
	${CC} -shared ${LDFLAGS} -o Release/Resources/plugins/CommandSim.xpl ${OBJS_CommandSim} ${LIBS}


ifeq (${TARGET}, CommandSim.xpl)

%.c.o: %.c
	gcc -c -fPIC ${CFLAGS_CommandSim} $< -o $@ -MMD
include $(c_SRC_CommandSim:.c=.d)

%.d: %.c
	set -e; $(CC) -M $(CFLAGS_CommandSim) $< \
 | sed 's!\($(*F)\)\.o[ :]*!$(*D)/\1.o $@ : !g' > $@; \
 [ -s $@ ] || rm -f $@



endif
##############################
#######  TARGET: DrawAircraft
##############################
TOP_DrawAircraft=../../..
WD_DrawAircraft=$(shell cd ${TOP_DrawAircraft};echo `pwd`)
cpp_SRC_DrawAircraft+=${WD_DrawAircraft}/SDKExamples/SampleCode/DrawAircraft.cpp
cpp_SRC_DrawAircraft+=${WD_DrawAircraft}/SDKExamples/SampleCode/AircraftUtils.cpp

OBJS_DrawAircraft+=$(c_SRC_DrawAircraft:.c=.c.o)

OBJS_DrawAircraft+=$(cpp_SRC_DrawAircraft:.cpp=.cpp.o)

CFLAGS_DrawAircraft+= -I./\
 -I../../../SDK/CHeaders/XPLM\
 -I../../../SDKExamples/SampleCode/\
 -I- -I/usr/include/\
 -DIBM=0 -DAPL=0 -DLIN=1

DBG=-g

CFLAGS_DrawAircraft+=-w -O0 -x c++ -ansi

clean_DrawAircraft:
	rm -f ${OBJS_DrawAircraft}

DrawAircraft:
	$(MAKE) -f SDKExamples.mk DrawAircraft.xpl TARGET=DrawAircraft.xpl\
	CC="g++"  LD="g++"  AR="ar -crs"  SIZE="size" LIBS+="-lGL -lGLU"

DrawAircraft.xpl: ${OBJS_DrawAircraft}
	${CC} -shared ${LDFLAGS} -o Release/Resources/plugins/DrawAircraft.xpl ${OBJS_DrawAircraft} ${LIBS}


ifeq (${TARGET}, DrawAircraft.xpl)

%.cpp.o: %.cpp
	gcc -c -fPIC ${CFLAGS_DrawAircraft} $< -o $@ -MMD
include $(cpp_SRC_DrawAircraft:.cpp=.d)

%.d: %.cpp
	set -e; $(CC) -M $(CFLAGS_DrawAircraft) $< \
 | sed 's!\($(*F)\)\.o[ :]*!$(*D)/\1.o $@ : !g' > $@; \
 [ -s $@ ] || rm -f $@ 



endif
##############################
#######  TARGET: DrawingHook
##############################
TOP_DrawingHook=../../..
WD_DrawingHook=$(shell cd ${TOP_DrawingHook};echo `pwd`)
c_SRC_DrawingHook+=${WD_DrawingHook}/SDKExamples/SampleCode/DrawingHook.c

OBJS_DrawingHook+=$(c_SRC_DrawingHook:.c=.c.o)

OBJS_DrawingHook+=$(cpp_SRC_DrawingHook:.cpp=.cpp.o)

CFLAGS_DrawingHook+= -I./\
 -I../../../SDK/CHeaders/XPLM\
 -I../../../SDKExamples/SampleCode/\
 -I- -I/usr/include/\
 -DIBM=0 -DAPL=0 -DLIN=1

DBG=-g

CFLAGS_DrawingHook+=-O0 -x c++ -ansi

clean_DrawingHook:
	rm -f ${OBJS_DrawingHook}

DrawingHook:
	$(MAKE) -f SDKExamples.mk DrawingHook.xpl TARGET=DrawingHook.xpl\
	CC="g++"  LD="g++"  AR="ar -crs"  SIZE="size" LIBS+="-lGL -lGLU"

DrawingHook.xpl: ${OBJS_DrawingHook}
	${CC} -shared ${LDFLAGS} -o Release/Resources/plugins/DrawingHook.xpl ${OBJS_DrawingHook} ${LIBS}


ifeq (${TARGET}, DrawingHook.xpl)

%.c.o: %.c
	gcc -c -fPIC ${CFLAGS_DrawingHook} $< -o $@ -MMD
include $(c_SRC_DrawingHook:.c=.d)

%.d: %.c
	set -e; $(CC) -M $(CFLAGS_DrawingHook) $< \
 | sed 's!\($(*F)\)\.o[ :]*!$(*D)/\1.o $@ : !g' > $@; \
 [ -s $@ ] || rm -f $@

endif
##############################
#######  TARGET: HelloWorld 
##############################
TOP_HelloWorld=../../..
WD_HelloWorld=$(shell cd ${TOP_HelloWorld};echo `pwd`)
c_SRC_HelloWorld+=${WD_HelloWorld}/SDKExamples/SampleCode/HelloWorld.c

OBJS_HelloWorld+=$(c_SRC_HelloWorld:.c=.c.o)

OBJS_HelloWorld+=$(cpp_SRC_HelloWorld:.cpp=.cpp.o)

CFLAGS_HelloWorld+= -I./\
 -I../../../SDK/CHeaders/XPLM\
 -I../../../SDKExamples/SampleCode/\
 -I- -I/usr/include/\
 -DIBM=0 -DAPL=0 -DLIN=1

DBG=-g

CFLAGS_HelloWorld+=-O0 -x c++ -ansi

clean_HelloWorld:
	rm -f ${OBJS_HelloWorld}

HelloWorld:
	$(MAKE) -f SDKExamples.mk HelloWorld.xpl TARGET=HelloWorld.xpl\
	CC="g++"  LD="g++"  AR="ar -crs"  SIZE="size" LIBS+="-lGL -lGLU"

HelloWorld.xpl: ${OBJS_HelloWorld}
	${CC} -shared ${LDFLAGS} -o Release/Resources/plugins/HelloWorld.xpl ${OBJS_HelloWorld} ${LIBS}


ifeq (${TARGET}, HelloWorld.xpl)

%.c.o: %.c
	gcc -c -fPIC ${CFLAGS_HelloWorld} $< -o $@ -MMD
include $(c_SRC_HelloWorld:.c=.d)

%.d: %.c
	set -e; $(CC) -M $(CFLAGS_HelloWorld) $< \
 | sed 's!\($(*F)\)\.o[ :]*!$(*D)/\1.o $@ : !g' > $@; \
 [ -s $@ ] || rm -f $@


endif
##############################
#######  TARGET: HotKey 
##############################
TOP_HotKey=../../..
WD_HotKey=$(shell cd ${TOP_HotKey};echo `pwd`)
c_SRC_HotKey+=${WD_HotKey}/SDKExamples/SampleCode/HotKey.c

OBJS_HotKey+=$(c_SRC_HotKey:.c=.c.o)

OBJS_HotKey+=$(cpp_SRC_HotKey:.cpp=.cpp.o)

CFLAGS_HotKey+= -I./\
 -I../../../SDK/CHeaders/XPLM\
 -I../../../SDKExamples/SampleCode/\
 -I- -I/usr/include/\
 -DIBM=0 -DAPL=0 -DLIN=1

DBG=-g

CFLAGS_HotKey+=-O0 -x c++ -ansi

clean_HotKey:
	rm -f ${OBJS_HotKey}

HotKey:
	$(MAKE) -f SDKExamples.mk HotKey.xpl TARGET=HotKey.xpl\
	CC="g++"  LD="g++"  AR="ar -crs"  SIZE="size" LIBS+="-lGL -lGLU"

HotKey.xpl: ${OBJS_HotKey}
	${CC} -shared ${LDFLAGS} -o Release/Resources/plugins/HotKey.xpl ${OBJS_HotKey} ${LIBS}


ifeq (${TARGET}, HotKey.xpl)

%.c.o: %.c
	gcc -c -fPIC ${CFLAGS_HotKey} $< -o $@ -MMD
include $(c_SRC_HotKey:.c=.d)

%.d: %.c
	set -e; $(CC) -M $(CFLAGS_HotKey) $< \
 | sed 's!\($(*F)\)\.o[ :]*!$(*D)/\1.o $@ : !g' > $@; \
 [ -s $@ ] || rm -f $@


endif
##############################
#######  TARGET: KeySniffer
##############################
TOP_KeySniffer=../../..
WD_KeySniffer=$(shell cd ${TOP_KeySniffer};echo `pwd`)
c_SRC_KeySniffer+=${WD_KeySniffer}/SDKExamples/SampleCode/KeySniffer.c

OBJS_KeySniffer+=$(c_SRC_KeySniffer:.c=.c.o)

OBJS_KeySniffer+=$(cpp_SRC_KeySniffer:.cpp=.cpp.o)

CFLAGS_KeySniffer+= -I./\
 -I../../../SDK/CHeaders/XPLM\
 -I../../../SDKExamples/SampleCode/\
 -I- -I/usr/include/\
 -DIBM=0 -DAPL=0 -DLIN=1

DBG=-g

CFLAGS_KeySniffer+=-O0 -x c++ -ansi

clean_KeySniffer:
	rm -f ${OBJS_KeySniffer}

KeySniffer:
	$(MAKE) -f SDKExamples.mk KeySniffer.xpl TARGET=KeySniffer.xpl\
	CC="g++"  LD="g++"  AR="ar -crs"  SIZE="size" LIBS+="-lGL -lGLU"

KeySniffer.xpl: ${OBJS_KeySniffer}
	${CC} -shared ${LDFLAGS} -o Release/Resources/plugins/KeySniffer.xpl ${OBJS_KeySniffer} ${LIBS}


ifeq (${TARGET}, KeySniffer.xpl)

%.c.o: %.c
	gcc -c -fPIC ${CFLAGS_KeySniffer} $< -o $@ -MMD
include $(c_SRC_KeySniffer:.c=.d)

%.d: %.c
	set -e; $(CC) -M $(CFLAGS_KeySniffer) $< \
 | sed 's!\($(*F)\)\.o[ :]*!$(*D)/\1.o $@ : !g' > $@; \
 [ -s $@ ] || rm -f $@

endif
##############################
#######  TARGET: ManagePlugins 
##############################
TOP_ManagePlugins=../../..
WD_ManagePlugins=$(shell cd ${TOP_ManagePlugins};echo `pwd`)
c_SRC_ManagePlugins+=${WD_ManagePlugins}/SDKExamples/SampleCode/ManagePlugins.c

OBJS_ManagePlugins+=$(c_SRC_ManagePlugins:.c=.c.o)

OBJS_ManagePlugins+=$(cpp_SRC_ManagePlugins:.cpp=.cpp.o)

CFLAGS_ManagePlugins+= -I./\
 -I../../../SDK/CHeaders/XPLM\
 -I../../../SDKExamples/SampleCode/\
 -I- -I/usr/include/\
 -DIBM=0 -DAPL=0 -DLIN=1

DBG=-g

CFLAGS_ManagePlugins+=-O0 -x c++ -ansi

clean_ManagePlugins:
	rm -f ${OBJS_ManagePlugins}

ManagePlugins:
	$(MAKE) -f SDKExamples.mk ManagePlugins.xpl TARGET=ManagePlugins.xpl\
	CC="g++"  LD="g++"  AR="ar -crs"  SIZE="size" LIBS+="-lGL -lGLU"

ManagePlugins.xpl: ${OBJS_ManagePlugins}
	${CC} -shared ${LDFLAGS} -o Release/Resources/plugins/ManagePlugins.xpl ${OBJS_ManagePlugins} ${LIBS}


ifeq (${TARGET}, ManagePlugins.xpl)

%.c.o: %.c
	gcc -c -fPIC ${CFLAGS_ManagePlugins} $< -o $@ -MMD
include $(c_SRC_ManagePlugins:.c=.d)

%.d: %.c
	set -e; $(CC) -M $(CFLAGS_ManagePlugins) $< \
 | sed 's!\($(*F)\)\.o[ :]*!$(*D)/\1.o $@ : !g' > $@; \
 [ -s $@ ] || rm -f $@

endif
##############################
#######  TARGET: Navigation
##############################
TOP_Navigation=../../..
WD_Navigation=$(shell cd ${TOP_Navigation};echo `pwd`)
c_SRC_Navigation+=${WD_Navigation}/SDKExamples/SampleCode/Navigation.c

OBJS_Navigation+=$(c_SRC_Navigation:.c=.c.o)

OBJS_Navigation+=$(cpp_SRC_Navigation:.cpp=.cpp.o)

CFLAGS_Navigation+= -I./\
 -I../../../SDK/CHeaders/XPLM\
 -I../../../SDKExamples/SampleCode/\
 -I- -I/usr/include/\
 -DIBM=0 -DAPL=0 -DLIN=1

DBG=-g

CFLAGS_Navigation+=-O0 -x c++ -ansi

clean_Navigation:
	rm -f ${OBJS_Navigation}

Navigation:
	$(MAKE) -f SDKExamples.mk Navigation.xpl TARGET=Navigation.xpl\
	CC="g++"  LD="g++"  AR="ar -crs"  SIZE="size" LIBS+="-lGL -lGLU"

Navigation.xpl: ${OBJS_Navigation}
	${CC} -shared ${LDFLAGS} -o Release/Resources/plugins/Navigation.xpl ${OBJS_Navigation} ${LIBS}


ifeq (${TARGET}, Navigation.xpl)

%.c.o: %.c
	gcc -c -fPIC ${CFLAGS_Navigation} $< -o $@ -MMD
include $(c_SRC_Navigation:.c=.d)

%.d: %.c
	set -e; $(CC) -M $(CFLAGS_Navigation) $< \
 | sed 's!\($(*F)\)\.o[ :]*!$(*D)/\1.o $@ : !g' > $@; \
 [ -s $@ ] || rm -f $@

endif
##############################
#######  TARGET: Planes 
##############################
TOP_Planes=../../..
WD_Planes=$(shell cd ${TOP_Planes};echo `pwd`)
c_SRC_Planes+=${WD_Planes}/SDKExamples/SampleCode/Planes.c

OBJS_Planes+=$(c_SRC_Planes:.c=.c.o)

OBJS_Planes+=$(cpp_SRC_Planes:.cpp=.cpp.o)

CFLAGS_Planes+= -I./\
 -I../../../SDK/CHeaders/XPLM\
 -I../../../SDKExamples/SampleCode/\
 -I- -I/usr/include/\
 -DIBM=0 -DAPL=0 -DLIN=1

DBG=-g

CFLAGS_Planes+=-O0 -x c++ -ansi

clean_Planes:
	rm -f ${OBJS_Planes}

Planes:
	$(MAKE) -f SDKExamples.mk Planes.xpl TARGET=Planes.xpl\
	CC="g++"  LD="g++"  AR="ar -crs"  SIZE="size" LIBS+="-lGL -lGLU"

Planes.xpl: ${OBJS_Planes}
	${CC} -shared ${LDFLAGS} -o Release/Resources/plugins/Planes.xpl ${OBJS_Planes} ${LIBS}


ifeq (${TARGET}, Planes.xpl)

%.c.o: %.c
	gcc -c -fPIC ${CFLAGS_Planes} $< -o $@ -MMD
include $(c_SRC_Planes:.c=.d)

%.d: %.c
	set -e; $(CC) -M $(CFLAGS_Planes) $< \
 | sed 's!\($(*F)\)\.o[ :]*!$(*D)/\1.o $@ : !g' > $@; \
 [ -s $@ ] || rm -f $@


endif
##############################
#######  TARGET: ShareData 
##############################
TOP_ShareData=../../..
WD_ShareData=$(shell cd ${TOP_ShareData};echo `pwd`)
c_SRC_ShareData+=${WD_ShareData}/SDKExamples/SampleCode/ShareData.c

OBJS_ShareData+=$(c_SRC_ShareData:.c=.c.o)

OBJS_ShareData+=$(cpp_SRC_ShareData:.cpp=.cpp.o)

CFLAGS_ShareData+= -I./\
 -I../../../SDK/CHeaders/XPLM\
 -I../../../SDKExamples/SampleCode/\
 -I- -I/usr/include/\
 -DIBM=0 -DAPL=0 -DLIN=1

DBG=-g

CFLAGS_ShareData+=-O0 -x c++ -ansi

clean_ShareData:
	rm -f ${OBJS_ShareData}

ShareData:
	$(MAKE) -f SDKExamples.mk ShareData.xpl TARGET=ShareData.xpl\
	CC="g++"  LD="g++"  AR="ar -crs"  SIZE="size" LIBS+="-lGL -lGLU"

ShareData.xpl: ${OBJS_ShareData}
	${CC} -shared ${LDFLAGS} -o Release/Resources/plugins/ShareData.xpl ${OBJS_ShareData} ${LIBS}


ifeq (${TARGET}, ShareData.xpl)

%.c.o: %.c
	gcc -c -fPIC ${CFLAGS_ShareData} $< -o $@ -MMD
include $(c_SRC_ShareData:.c=.d)

%.d: %.c
	set -e; $(CC) -M $(CFLAGS_ShareData) $< \
 | sed 's!\($(*F)\)\.o[ :]*!$(*D)/\1.o $@ : !g' > $@; \
 [ -s $@ ] || rm -f $@


endif
##############################
#######  TARGET: SimData
##############################
TOP_SimData=../../..
WD_SimData=$(shell cd ${TOP_SimData};echo `pwd`)
c_SRC_SimData+=${WD_SimData}/SDKExamples/SampleCode/SimData.c

OBJS_SimData+=$(c_SRC_SimData:.c=.c.o)

OBJS_SimData+=$(cpp_SRC_SimData:.cpp=.cpp.o)

CFLAGS_SimData+= -I./\
 -I../../../SDK/CHeaders/XPLM\
 -I../../../SDKExamples/SampleCode/\
 -I- -I/usr/include/\
 -DIBM=0 -DAPL=0 -DLIN=1

DBG=-g

CFLAGS_SimData+=-O0 -x c++ -ansi

clean_SimData:
	rm -f ${OBJS_SimData}

SimData:
	$(MAKE) -f SDKExamples.mk SimData.xpl TARGET=SimData.xpl\
	CC="g++"  LD="g++"  AR="ar -crs"  SIZE="size" LIBS+="-lGL -lGLU"

SimData.xpl: ${OBJS_SimData}
	${CC} -shared ${LDFLAGS} -o Release/Resources/plugins/SimData.xpl ${OBJS_SimData} ${LIBS}


ifeq (${TARGET}, SimData.xpl)

%.c.o: %.c
	gcc -c -fPIC ${CFLAGS_SimData} $< -o $@ -MMD
include $(c_SRC_SimData:.c=.d)

%.d: %.c
	set -e; $(CC) -M $(CFLAGS_SimData) $< \
 | sed 's!\($(*F)\)\.o[ :]*!$(*D)/\1.o $@ : !g' > $@; \
 [ -s $@ ] || rm -f $@


endif
##############################
#######  TARGET: TimedProcessing
##############################
TOP_TimedProcessing=../../..
WD_TimedProcessing=$(shell cd ${TOP_TimedProcessing};echo `pwd`)
c_SRC_TimedProcessing+=${WD_TimedProcessing}/SDKExamples/SampleCode/TimedProcessing.c

OBJS_TimedProcessing+=$(c_SRC_TimedProcessing:.c=.c.o)

OBJS_TimedProcessing+=$(cpp_SRC_TimedProcessing:.cpp=.cpp.o)

CFLAGS_TimedProcessing+= -I./\
 -I../../../SDK/CHeaders/XPLM\
 -I../../../SDKExamples/SampleCode/\
 -I- -I/usr/include/\
 -DIBM=0 -DAPL=0 -DLIN=1

DBG=-g

CFLAGS_TimedProcessing+=-O0 -x c++ -ansi

clean_TimedProcessing:
	rm -f ${OBJS_TimedProcessing}

TimedProcessing:
	$(MAKE) -f SDKExamples.mk TimedProcessing.xpl TARGET=TimedProcessing.xpl\
	CC="g++"  LD="g++"  AR="ar -crs"  SIZE="size" LIBS+="-lGL -lGLU"

TimedProcessing.xpl: ${OBJS_TimedProcessing}
	${CC} -shared ${LDFLAGS} -o Release/Resources/plugins/TimedProcessing.xpl ${OBJS_TimedProcessing} ${LIBS}


ifeq (${TARGET}, TimedProcessing.xpl)

%.c.o: %.c
	gcc -c -fPIC ${CFLAGS_TimedProcessing} $< -o $@ -MMD
include $(c_SRC_TimedProcessing:.c=.d)

%.d: %.c
	set -e; $(CC) -M $(CFLAGS_TimedProcessing) $< \
 | sed 's!\($(*F)\)\.o[ :]*!$(*D)/\1.o $@ : !g' > $@; \
 [ -s $@ ] || rm -f $@


endif
##############################

# end Makefile
