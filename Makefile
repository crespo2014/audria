#
# builds by default in release mode
# call with mode=debug to build in debug mode
#

TOOL_CHAIN := /opt/OSELAS.Toolchain-2012.12.1/arm-cortexa9-linux-gnueabihf/gcc-4.7.3-glibc-2.16.0-binutils-2.22-kernel-3.6-sanitized
ARM_CC  := $(TOOL_CHAIN)/bin/arm-cortexa9-linux-gnueabihf-gcc
ARM_CXX := $(TOOL_CHAIN)/bin/arm-cortexa9-linux-gnueabihf-g++
ARM_OBJCOPY := $(TOOL_CHAIN)/bin/arm-cortexa9-linux-gnueabihf-objcopy		

CXX = g++

CXXFLAGS = -std=c++11 -Wall -Wextra -Weffc++ -Wshadow  -Wall -Wextra -pedantic -Wmissing-declarations -Wpointer-arith -Wwrite-strings -Wformat=2 -Wlogical-op -Wcast-align -Wcast-qual -Wundef -Wmissing-include-dirs -Wfloat-equal -Wconversion 
#-Wconversion -fexec-charset=ascii -finput-charset=ascii
LDFLAGS = -lrt

ifeq ($(mode),debug)
	CXXFLAGS += -O3 -g
else
	CXXFLAGS += -Os -DNDEBUG
endif

SRCS=audria.cpp ProcReader.cpp ProcCache.cpp TimeSpec.cpp helper.cpp
SRCSTEST=TimeSpecTest.cpp TimeSpec.cpp
OBJS=$(SRCS:.cpp=.o)
OBJSTEST=$(SRCSTEST:.cpp=.o)

.PHONY: all
all: info audria tests audria_arm

# info message in which mode to build
info:
ifeq ($(mode),debug)
	@echo "building in DEBUG mode\n"
else
	@echo "building in RELEASE mode\n"
endif

%.o.arm : %.cpp
	$(ARM_CXX) $(CXXFLAGS) -c -o $@ $<
 	
# our project
audria: $(OBJS)
	$(CXX) $(OBJS) $(CXXFLAGS) $(LDFLAGS) -o $@
ifeq ($(mode),release)
	strip $@
endif

ARM_OBJ=$(SRCS:.cpp=.o.arm)

audria_arm : $(ARM_OBJ)
	$(ARM_CXX) $(ARM_OBJ) $(CXXFLAGS) $(LDFLAGS) -o $@
ifeq ($(mode),release)
	strip $@
endif

# tests, don't build in release mode
tests: $(OBJSTEST)
ifeq ($(mode),debug)
	$(CXX) $(OBJSTEST) $(CXXFLAGS) -g $(LDFLAGS) -o $@
endif

audria.o: audria.h
ProcReader.o: ProcReader.h
ProcCache.o: ProcCache.h
TimeSpec.o: TimeSpec.h
helper.o: helper.h

.PHONY: clean
clean:
	rm -f *.o *.o.arm audria_arm audria tests
