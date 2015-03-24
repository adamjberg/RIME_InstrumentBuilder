package org.haxe.extension;

import java.util.ArrayList;
import java.util.HashMap; 
import java.util.List;

import android.app.Activity;
import android.content.res.AssetManager;
import android.content.Context;
import android.content.Intent;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;

public class Sensors extends Extension implements SensorEventListener {
	
    private class SensorDetails {
        public float[] values = new float[3];
        public boolean isSupported = false;
    }

	private SensorManager mSensorManager;
    private static HashMap<Integer, SensorDetails> mSensorDetails = new HashMap<Integer, SensorDetails>();
    private Sensor[] mSensors;
    private int[] mSensorTypes = new int[] {
    	Sensor.TYPE_ACCELEROMETER,
    	Sensor.TYPE_GYROSCOPE,
    	Sensor.TYPE_GRAVITY,
    	Sensor.TYPE_LINEAR_ACCELERATION,
    	Sensor.TYPE_PRESSURE,
    	Sensor.TYPE_AMBIENT_TEMPERATURE,
    	Sensor.TYPE_ROTATION_VECTOR,
    	Sensor.TYPE_PROXIMITY,
    	Sensor.TYPE_LIGHT,
    	Sensor.TYPE_MAGNETIC_FIELD,
    	Sensor.TYPE_RELATIVE_HUMIDITY
    };

    public static boolean isAccelerometerSupported()
    {
        return mSensorDetails.get(Sensor.TYPE_ACCELEROMETER).isSupported;
    }
    public static boolean isGyroscopeSupported()
    {
        return mSensorDetails.get(Sensor.TYPE_GYROSCOPE).isSupported;
    }
    public static boolean isGravitySupported()
    {
        return mSensorDetails.get(Sensor.TYPE_GRAVITY).isSupported;

    }
    public static boolean isLinearAccelerometerSupported()
    {
        return mSensorDetails.get(Sensor.TYPE_LINEAR_ACCELERATION).isSupported;

    }
    public static boolean isOrientationSupported()
    {
        return isGravitySupported() && isMagneticFieldSupported();

    }
    public static boolean isPressureSupported()
    {
        return mSensorDetails.get(Sensor.TYPE_PRESSURE).isSupported;

    }
    public static boolean isAmbientTemperatureSupported()
    {
        return mSensorDetails.get(Sensor.TYPE_AMBIENT_TEMPERATURE).isSupported;

    }
    public static boolean isRotationSupported()
    {
        return mSensorDetails.get(Sensor.TYPE_ROTATION_VECTOR).isSupported;

    }
    public static boolean isProximitySupported()
    {
        return mSensorDetails.get(Sensor.TYPE_PROXIMITY).isSupported;

    }
    public static boolean isLightSupported()
    {
        return mSensorDetails.get(Sensor.TYPE_LIGHT).isSupported;

    }
    public static boolean isMagneticFieldSupported()
    {
        return mSensorDetails.get(Sensor.TYPE_MAGNETIC_FIELD).isSupported;

    }
    public static boolean isHumiditySupported()
    {
        return mSensorDetails.get(Sensor.TYPE_RELATIVE_HUMIDITY).isSupported;
    }

    public static float[] getAccel()
    {
        return mSensorDetails.get(Sensor.TYPE_ACCELEROMETER).values;
    }
    public static float[] getGyro()
    {
        return mSensorDetails.get(Sensor.TYPE_GYROSCOPE).values;
    }
    public static float[] getGravity()
    {
        return mSensorDetails.get(Sensor.TYPE_GRAVITY).values;
    }
    public static float[] getLnaccel()
    {
        return mSensorDetails.get(Sensor.TYPE_LINEAR_ACCELERATION).values;
    }
    // Modified from http://stackoverflow.com/questions/20339942/android-get-device-angle-by-using-getorientation-function
    public static float[] getOrient()
    {
        float R[] = new float[9];
        float I[] = new float[9];
        boolean success = SensorManager.getRotationMatrix(R, I, Sensors.getGravity(), Sensors.getMagneticField());
        float orientation[] = new float[3];
        if(success)
        {   
            SensorManager.getOrientation(R, orientation);
        }
        return orientation;
    }
    public static float getPressure()
    {
        return mSensorDetails.get(Sensor.TYPE_PRESSURE).values[0];
    }
    public static float getAmtemp()
    {
        return mSensorDetails.get(Sensor.TYPE_AMBIENT_TEMPERATURE).values[0];
    }
    public static float[] getRotvect()
    {
        return mSensorDetails.get(Sensor.TYPE_ROTATION_VECTOR).values;
    }
    public static float getProximity()
    {
        return mSensorDetails.get(Sensor.TYPE_PROXIMITY).values[0];
    }
    public static float getLight()
    {
        return mSensorDetails.get(Sensor.TYPE_LIGHT).values[0];
    }
    public static float[] getMagneticField()
    {
        return mSensorDetails.get(Sensor.TYPE_MAGNETIC_FIELD).values;
    }
    public static float getHumidity()
    {
        return mSensorDetails.get(Sensor.TYPE_RELATIVE_HUMIDITY).values[0];
    }

    public Sensors() {
    	mSensorManager = (SensorManager) Extension.mainActivity.getSystemService(Context.SENSOR_SERVICE);
    	mSensors = new Sensor[mSensorTypes.length];
        
    	for(int i = 0; i < mSensorTypes.length; i++)
    	{
            SensorDetails sd = new SensorDetails();
    		mSensors[i] = mSensorManager.getDefaultSensor(mSensorTypes[i]);
            sd.isSupported = mSensors[i] != null;
            mSensorDetails.put(mSensorTypes[i], sd);
    	}
    }

	/**
	 * Called when an activity you launched exits, giving you the requestCode 
	 * you started it with, the resultCode it returned, and any additional data 
	 * from it.
	 */
	public boolean onActivityResult (int requestCode, int resultCode, Intent data) {
		return true;	
	}
	
	/**
	 * Called when the activity is starting.
	 */
	public void onCreate (Bundle savedInstanceState) {
	}
	
	/**
	 * Perform any final cleanup before an activity is destroyed.
	 */
	public void onDestroy () {
	}
	
	/**
	 * Called as part of the activity lifecycle when an activity is going into
	 * the background, but has not (yet) been killed.
	 */
	public void onPause () {
		mSensorManager.unregisterListener(this);
	}
	
	/**
	 * Called after {@link #onStop} when the current activity is being 
	 * re-displayed to the user (the user has navigated back to it).
	 */
	public void onRestart () {
	}
	
	/**
	 * Called after {@link #onRestart}, or {@link #onPause}, for your activity 
	 * to start interacting with the user.
	 */
	public void onResume () {
		for(int i = 0; i < mSensors.length; i++)
		{
			if(mSensors[i] != null)
			{
				mSensorManager.registerListener(this, mSensors[i], 0);
			}
		}
	}
	
	/**
	 * Called after {@link #onCreate} &mdash; or after {@link #onRestart} when  
	 * the activity had been stopped, but is now again being displayed to the 
	 * user.
	 */
	public void onStart () {
	}
	
	/**
	 * Called when the activity is no longer visible to the user, because 
	 * another activity has been resumed and is covering this one. 
	 */
	public void onStop () {
	}
	
	public void onAccuracyChanged(Sensor sensor, int accuracy) {
    
    }

   	public void onSensorChanged(SensorEvent event) {
        SensorDetails sensorDetails = mSensorDetails.get(event.sensor.getType());
        sensorDetails.values = event.values;
    }
}