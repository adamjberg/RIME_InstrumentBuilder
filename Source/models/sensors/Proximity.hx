package models.sensors;

import models.sensors.Sensor;
import models.sensors.SensorComponent;

class Proximity extends Sensor {

    public function new() {
        super(
            "Proximity",
            "Measures the proximity of an object in cm relative to the view screen of a device.",
            [
                new SensorComponent(
                    this,
                    "Proximity",
                    "Distance from object.",
                    "cm"
                )
            ]
        );
    }

}