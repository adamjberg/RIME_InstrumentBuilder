package models.sensors;

import models.sensors.Sensor;
import models.sensors.SensorComponent;

class Humidity extends Sensor {

    public function new() {
        super(
            "Humidity",
            "Measures the ambient room temperature in degrees Celsius (°C).",
            [
                new SensorComponent(
                    this,
                    "Humidity",
                    "Ambient relative humidity.",
                    "%"
                )
            ]
        );
    }

}