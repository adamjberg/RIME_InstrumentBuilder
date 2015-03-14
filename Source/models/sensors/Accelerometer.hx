package models.sensors;

import models.sensors.Sensor;
import models.sensors.SensorComponent;

class Accelerometer extends Sensor {

    public function new() {
        super(
            "Accelerometer",
            "Measures the acceleration force in m/s2 that is applied to a device on all three physical axes (x, y, and z), including the force of gravity.",
            [
                new SensorComponent(
                    this,
                    "X",
                    "Acceleration force along the x axis (including gravity).",
                    "m/s2"
                ),
                new SensorComponent(
                    this,
                    "Y",
                    "Acceleration force along the y axis (including gravity).",
                    "m/s2"
                ),
                new SensorComponent(
                    this,
                    "Z",
                    "Acceleration force along the z axis (including gravity).",
                    "m/s2"
                ),
            ]
        );
    }

}