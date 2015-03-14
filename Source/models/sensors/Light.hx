package models.sensors;

import models.sensors.Sensor;
import models.sensors.SensorComponent;

class Light extends Sensor {

    public function new() {
        super(
            "Light",
            "Measures the ambient room temperature in degrees Celsius (°C).",
            [
                new SensorComponent(
                    this,
                    "Illuminance",
                    "Illuminance..",
                    "lx"
                )
            ]
        );
    }

}