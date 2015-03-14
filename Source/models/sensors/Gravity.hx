package models.sensors;

import models.sensors.Sensor;
import models.sensors.SensorComponent;

class Gravity extends Sensor {

    public function new() {
        super(
            "Gravity",
            "Measures the force of gravity in m/s2 that is applied to a device on all three physical axes (x, y, z).",
            [
                new SensorComponent(
                    this,
                    "X",
                    "Force of gravity along the x axis.",
                    "m/s2"
                ),
                new SensorComponent(
                    this,
                    "Y",
                    "Force of gravity along the y axis.",
                    "m/s2"
                ),
                new SensorComponent(
                    this,
                    "Z",
                    "Force of gravity along the z axis.",
                    "m/s2"
                ),
            ]
        );
    }

}