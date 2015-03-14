package models.sensors;

import models.sensors.Sensor;
import models.sensors.SensorComponent;

class Orientation extends Sensor {

    public function new() {
        super(
            "Orientation",
            "Measures degrees of rotation that a device makes around all three physical axes (x, y, z).",
            [
                new SensorComponent(
                    this,
                    "X",
                    "Rotation around the x axis.",
                    "degrees"
                ),
                new SensorComponent(
                    this,
                    "Y",
                    "Rotation around the y axis.",
                    "degrees"
                ),
                new SensorComponent(
                    this,
                    "Z",
                    "Rotation around the z axis.",
                    "degrees"
                ),
            ]
        );
    }

}