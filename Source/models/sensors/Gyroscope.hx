package models.sensors;

import models.sensors.Sensor;
import models.sensors.SensorComponent;

class Gyroscope extends Sensor {

    public function new() {
        super(
            "Gyroscope",
            "Measures a device's rate of rotation in rad/s around each of the three physical axes (x, y, and z).",
            [
                new SensorComponent(
                    this,
                    "X",
                    "Rate of rotation around the x axis.",
                    "rad/s"
                ),
                new SensorComponent(
                    this,
                    "Y",
                    "Rate of rotation around the y axis.",
                    "rad/s"
                ),
                new SensorComponent(
                    this,
                    "Z",
                    "Rate of rotation around the z axis.",
                    "rad/s"
                ),
            ]
        );
    }

}