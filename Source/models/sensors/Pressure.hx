package models.sensors;

import models.sensors.Sensor;
import models.sensors.SensorComponent;

class Pressure extends Sensor {

    public function new() {
        super(
            "Pressure",
            "Measures the ambient room temperature in degrees Celsius (°C).",
            [
                new SensorComponent(
                    this,
                    "Pressure",
                    "Ambient air pressure.",
                    "hPa or mbar"
                )
            ]
        );
    }

}