package models.sensors;

import models.sensors.Sensor;
import models.sensors.SensorComponent;

class LinearAccelerometer extends Sensor {

    public function new() {
        super(
            "Linear Accelerometer",
            "Measures the acceleration force in m/s2 that is applied to a device on all three physical axes (x, y, and z), excluding the force of gravity.",
            [
                new SensorComponent(
                    this,
                    "X",
                    "Acceleration force along the x axis (excluding gravity).",
                    "m/s2"
                ),
                new SensorComponent(
                    this,
                    "Y",
                    "Acceleration force along the y axis (excluding gravity).",
                    "m/s2"
                ),
                new SensorComponent(
                    this,
                    "Z",
                    "Acceleration force along the z axis (excluding gravity).",
                    "m/s2"
                ),
            ]
        );
    }

}