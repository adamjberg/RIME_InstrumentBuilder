package models.sensors;

import models.sensors.Sensor;
import models.sensors.SensorComponent;

class Magnetic extends Sensor {

    public function new() {
        super(
            "Magnetic",
            "Measures the ambient geomagnetic field for all three physical axes (x, y, z) in μT.",
            [
                new SensorComponent(
                    this,
                    "X",
                    "Geomagnetic field strength along the x axis.",
                    "μT"
                ),
                new SensorComponent(
                    this,
                    "Y",
                    "Geomagnetic field strength along the y axis.",
                    "μT"
                ),
                new SensorComponent(
                    this,
                    "Z",
                    "Geomagnetic field strength along the z axis.",
                    "μT"
                ),
            ]
        );
    }

}