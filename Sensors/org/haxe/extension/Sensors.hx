package org.haxe.extension;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

#if (android && openfl)
import openfl.utils.JNI;
#end

@:build(ShortCuts.mirrors()) 
class Sensors {
	
    // --------------- ANDROID CONNECTORS ---------------- //

	#if (android && openfl)
		@JNI public static function getAccel():Array<Float>;
        @JNI public static function getGyro():Array<Float>;
        @JNI public static function getGravity():Array<Float>;
        @JNI public static function getLnaccel():Array<Float>;
        @JNI public static function getOrient():Array<Float>;
        @JNI public static function getPressure():Float;
        @JNI public static function getAmtemp():Float;
        @JNI public static function getRotvect():Array<Float>;
        @JNI public static function getProximity():Float;
        @JNI public static function getLight():Float;
        @JNI public static function getMagneticField():Array<Float>;
        @JNI public static function getHumidity():Float;

        @JNI public static function isAccelerometerSupported():Bool;
        @JNI public static function isGyroscopeSupported():Bool;
        @JNI public static function isGravitySupported():Bool;
        @JNI public static function isLinearAccelerometerSupported():Bool;
        @JNI public static function isOrientationSupported():Bool;
        @JNI public static function isPressureSupported():Bool;
        @JNI public static function isAmbientTemperatureSupported():Bool;
        @JNI public static function isRotationSupported():Bool;
        @JNI public static function isProximitySupported():Bool;
        @JNI public static function isLightSupported():Bool;
        @JNI public static function isMagneticFieldSupported():Bool;
        @JNI public static function isHumiditySupported():Bool;
    #else

    // --------------- IOS/OTHER CONNECTORS ---------------- //

    public static function getAccel ():Array<Float> {
        var array:Array<Float> = new Array<Float>();
		#if (ios)
	
        	array.push(sensors_get_iaccelX());
        	array.push(sensors_get_iaccelY());
        	array.push(sensors_get_iaccelZ());
        #else
	        array.push(0);
        	array.push(0);
        	array.push(0);
		#end
		return array;
    }


    public static function getGyro ():Array<Float>{
        var array:Array<Float> = new Array<Float>();
		#if (ios)
	
        	array.push(sensors_get_igyroX());
        	array.push(sensors_get_igyroY());
        	array.push(sensors_get_igyroZ());
        #else
	        array.push(0);
        	array.push(0);
        	array.push(0);
		#end
		return array;
    }

    public static function getGravity ():Array<Float>{
        var array:Array<Float> = new Array<Float>();
		#if (ios)
	
        	array.push(sensors_get_igravX());
        	array.push(sensors_get_igravY());
        	array.push(sensors_get_igravZ());
        #else
	        array.push(0);
        	array.push(0);
        	array.push(0);
		#end
		return array;
    }

    public static function getLnaccel ():Array<Float>{
        var array:Array<Float> = new Array<Float>();
		#if (ios)
	
        	array.push(sensors_get_iuseraccelX());
        	array.push(sensors_get_iuseraccelY());
        	array.push(sensors_get_iuseraccelZ());
        #else
	        array.push(0);
        	array.push(0);
        	array.push(0);
		#end
		return array;
    }

    public static function getOrient ():Array<Float>{
        var array:Array<Float> = new Array<Float>();
		#if (ios)
	
        	array.push(sensors_get_iorientX());
        	array.push(sensors_get_iorientY());
        	array.push(sensors_get_iorientZ());
        #else
	        array.push(0);
        	array.push(0);
        	array.push(0);
		#end
		return array;
    }
    public static function getPressure ():Float {
        return 0;
    }

    public static function getAmtemp ():Float {
        return 0;        
    }
    
    public static function getRotvect ():Array<Float>{
        var array:Array<Float> = new Array<Float>();
		#if (ios)
	
        	array.push(sensors_get_igyroX());
        	array.push(sensors_get_igyroY());
        	array.push(sensors_get_igyroZ());
        #else
	        array.push(0);
        	array.push(0);
        	array.push(0);
		#end
		return array;
    }

    public static function getProximity ():Float {
        return 0;        
    }
    public static function getLight ():Float {
        return 0;        
    }
    public static function getMagneticField ():Array<Float>{
        var array:Array<Float> = new Array<Float>();
		#if (ios)
	
        	array.push(sensors_get_iMagX());
        	array.push(sensors_get_iMagY());
        	array.push(sensors_get_iMagZ());
        #else
	        array.push(0);
        	array.push(0);
        	array.push(0);
		#end
		return array;
    }


    public static function getHumidity ():Float {
        return 0;
    }


    public static function isAccelerometerSupported ():Bool {
        #if (ios)
            return is_iDMSupported();
        #end
        return true;
    }

    public static function isGyroscopeSupported ():Bool {
        #if (ios)
            return is_igyroSupported();
        #end
        return true;
    }

    public static function isGravitySupported ():Bool {
        #if (ios)
            return is_iDMSupported();
        #end
        return true;
    }

    public static function isLinearAccelerometerSupported ():Bool {
        #if (ios)
            return is_ilnaccelSupported();
        #end
        return true;
    }

    public static function isOrientationSupported ():Bool {
        #if (ios)
            return is_iDMSupported();
        #end
        return true;
        
    }

    public static function isPressureSupported ():Bool {
        #if (ios)
            return false;
        #end
        return true;
    }

    public static function isAmbientTemperatureSupported ():Bool {
        #if (ios)
            return false;
        #end
        return true;
    }

    public static function isRotationSupported ():Bool {
        #if (ios)
            return is_iDMSupported();
        #end
        
        return true;
    }

    public static function isProximitySupported ():Bool {
        #if (ios)
            return false;
        #end
        return true;
    }

    public static function isLightSupported ():Bool {
        #if (ios)
            return false;
        #end
        return true;
    }

    public static function isMagneticFieldSupported ():Bool {
        #if (ios)
            return is_iDMSupported(); 
        #end
        return true;
    }

    public static function isHumiditySupported ():Bool {
        #if (ios)
            return false;
        #end
        return true;
    }

    #end
    
    #if (ios)
    private static var sensors_get_iaccelX = Lib.load("sensors", "sensors_getiaccelX", 0);
    private static var sensors_get_iaccelY = Lib.load("sensors", "sensors_getiaccelY", 0);
    private static var sensors_get_iaccelZ = Lib.load("sensors", "sensors_getiaccelZ", 0);
    private static var is_ilnaccelSupported= Lib.load("sensors", "sensors_isAccelAvailable", 0);

    private static var sensors_get_iuseraccelX = Lib.load("sensors", "sensors_getiuseraccelX", 0);
    private static var sensors_get_iuseraccelY = Lib.load("sensors", "sensors_getiuseraccelY", 0);
    private static var sensors_get_iuseraccelZ = Lib.load("sensors", "sensors_getiuseraccelZ", 0);

    private static var sensors_get_igyroX = Lib.load("sensors", "sensors_getigyroX", 0);
    private static var sensors_get_igyroY = Lib.load("sensors", "sensors_getigyroY", 0);
    private static var sensors_get_igyroZ = Lib.load("sensors", "sensors_getigyroZ", 0);
    
    private static var sensors_get_iorientX = Lib.load("sensors", "sensors_getiorientX", 0);
    private static var sensors_get_iorientY = Lib.load("sensors", "sensors_getiorientY", 0);
    private static var sensors_get_iorientZ = Lib.load("sensors", "sensors_getiorientZ", 0);
    
    private static var sensors_get_iMagX = Lib.load("sensors", "sensors_getiMagX", 0);
    private static var sensors_get_iMagY = Lib.load("sensors", "sensors_getiMagY", 0);
    private static var sensors_get_iMagZ = Lib.load("sensors", "sensors_getiMagZ", 0);

    private static var sensors_get_irotX = Lib.load("sensors", "sensors_getirotX", 0);
    private static var sensors_get_irotY = Lib.load("sensors", "sensors_getirotY", 0);
    private static var sensors_get_irotZ = Lib.load("sensors", "sensors_getirotZ", 0);

    private static var sensors_get_igravX = Lib.load("sensors", "sensors_getigravX", 0);
    private static var sensors_get_igravY = Lib.load("sensors", "sensors_getigravY", 0);
    private static var sensors_get_igravZ = Lib.load("sensors", "sensors_getigravZ", 0);

    private static var is_igyroSupported= Lib.load("sensors", "sensors_isGyroAvailable", 0);
    private static var is_iDMSupported= Lib.load("sensors", "sensors_isDMAvailable", 0);

	#end

}