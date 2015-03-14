package models.sensors;

class SensorComponent {

    public var parentSensor:Sensor;
    public var name:String;
    public var value:Float = 0;
    public var description:String;
    public var units:String;

    public function new(parent:Sensor, name:String, description:String, units:String) {
        this.parentSensor = parent;
        this.name = name;
        this.description = description;
        this.units = units;
    }

}