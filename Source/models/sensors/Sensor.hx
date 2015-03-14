package models.sensors;

import models.sensors.SensorComponent;

class Sensor {

    public var name:String;
    public var description:String;
    public var components:Array<SensorComponent>;

    public function new(name:String, description:String, components:Array<SensorComponent>) {
        this.name = name;
        this.description = description;
        this.components = components;
    }

}