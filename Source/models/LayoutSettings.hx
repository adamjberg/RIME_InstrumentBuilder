package models;

class LayoutSettings {
    public var name:String;
    public var width:Int;
    public var height:Int;

    public function new(name:String, width:Int, height:Int) {
        this.name = name;
        this.width = width;
        this.height = height;
    }
}