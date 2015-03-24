#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif

#include <hx/CFFI.h>
#include "Sensors.h"

using namespace sensors;

//accelerometer get method
static value sensors_getiaccelX(){
	return alloc_float(getiaccelX());
}
DEFINE_PRIM(sensors_getiaccelX, 0);

static value sensors_getiaccelY(){
	return alloc_float(getiaccelY());
}
DEFINE_PRIM(sensors_getiaccelY, 0);

static value sensors_getiaccelZ(){
	return alloc_float(getiaccelZ());
}
DEFINE_PRIM(sensors_getiaccelZ, 0);
//end

//user accelerometer get method
static value sensors_getiuseraccelX(){
	return alloc_float(getiuseraccelX());
}
DEFINE_PRIM(sensors_getiuseraccelX, 0);

static value sensors_getiuseraccelY(){
	return alloc_float(getiuseraccelY());
}
DEFINE_PRIM(sensors_getiuseraccelY, 0);

static value sensors_getiuseraccelZ(){
	return alloc_float(getiuseraccelZ());
}
DEFINE_PRIM(sensors_getiuseraccelZ, 0);
//end

//gyroscope get methods
static value sensors_getigyroX(){
	return alloc_float(getigyroX());
}
DEFINE_PRIM(sensors_getigyroX, 0);

static value sensors_getigyroY(){
	return alloc_float(getigyroY());
}
DEFINE_PRIM(sensors_getigyroY, 0);

static value sensors_getigyroZ(){
	return alloc_float(getigyroZ());
}
DEFINE_PRIM(sensors_getigyroZ, 0);

//end

//attitude aka orientation get methods
static value sensors_getiorientX(){
	return alloc_float(getiorientRoll());
}
DEFINE_PRIM(sensors_getiorientX, 0);

static value sensors_getiorientY(){
	return alloc_float(getiorientPitch());
}
DEFINE_PRIM(sensors_getiorientY, 0);

static value sensors_getiorientZ(){
	return alloc_float(getiorientYaw());
}
DEFINE_PRIM(sensors_getiorientZ, 0);

//end

//Magnetic field get method
static value sensors_getiMagX(){
	return alloc_float(getiMagX());
}
DEFINE_PRIM(sensors_getiMagX, 0);
static value sensors_getiMagY(){
	return alloc_float(getiMagY());
}
DEFINE_PRIM(sensors_getiMagY, 0);
static value sensors_getiMagZ(){
	return alloc_float(getiMagZ());
}
DEFINE_PRIM(sensors_getiMagZ, 0);
//end

//Gravity get method
static value sensors_getigravX(){
	return alloc_float(getigravX());
}
DEFINE_PRIM(sensors_getigravX, 0);
static value sensors_getigravY(){
	return alloc_float(getigravY());
}
DEFINE_PRIM(sensors_getigravY, 0);
static value sensors_getigravZ(){
	return alloc_float(getigravZ());
}
DEFINE_PRIM(sensors_getigravZ, 0);
//end

//Rotation Rate get method
static value sensors_getirotX(){
	return alloc_float(getirotX());
}
DEFINE_PRIM(sensors_getirotX, 0);
static value sensors_getirotY(){
	return alloc_float(getirotY());
}
DEFINE_PRIM(sensors_getirotY, 0);
static value sensors_getirotZ(){
	return alloc_float(getirotZ());
}
DEFINE_PRIM(sensors_getirotZ, 0);
//end

//Check if Sensor Available
static value sensors_isAccelAvailable(){
	return alloc_bool(isAccelerometerAvailable());
}
DEFINE_PRIM(sensors_isAccelAvailable, 0);

static value sensors_isGyroAvailable(){
	return alloc_bool(isGyroAvailable());
}
DEFINE_PRIM(sensors_isGyroAvailable, 0);

static value sensors_isDMAvailable(){
	return alloc_bool(isdeviceMotionAvailalbe());
}
DEFINE_PRIM(sensors_isDMAvailable, 0);

//end

extern "C" void sensors_main () {
	
	val_int(0); // Fix Neko init
	init();
	
}
DEFINE_ENTRY_POINT (sensors_main);

extern "C" int sensors_register_prims () { return 0; }
