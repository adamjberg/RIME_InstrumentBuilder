package models.sensors;

import models.sensors.Sensor;
import models.sensors.SensorComponent;

class AmbientTemperature extends Sensor {

    public function new() {
        super(
            "Ambient Temperature",
            "Measures the ambient room temperature in degrees Celsius (°C).",
            [
                new SensorComponent(
                    this,
                    "Temperature",
                    "Ambient air temperature.",
                    "°C"
                )
            ]
        );
    }

}