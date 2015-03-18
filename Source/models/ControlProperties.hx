package models;

class ControlProperties {
    public var x:Int = 0;
    public var y:Int = 0;
    public var width:Int = 0;
    public var height:Int = 0;
    public var type:String = "";
    public var addressPattern = "/";
    public var fromValue:Float = 0;
    public var toValue:Float = 1;

    public static function fromDynamic(from:Dynamic):ControlProperties {
        var to:ControlProperties = new ControlProperties();
        to.x = from.x;
        to.y = from.y;
        to.width = from.width;
        to.height = from.height;
        to.type = from.type;
        to.addressPattern = from.type;
        to.fromValue = from.fromValue;
        to.toValue = from.toValue;
        return to;
    }
}