package models;

import models.Command;
import models.Control;
import views.instrument.controls.HSlider;
import views.instrument.controls.PushButton;
import views.instrument.controls.ToggleButton;
import views.instrument.controls.VSlider;
import views.instrument.controls.XYPad;

class Control {

    public static inline var TYPE_PUSHBUTTON:String = "Push Button";
    public static inline var TYPE_TOGGLE:String = "Toggle";
    public static inline var TYPE_VSLIDER:String = "SliderV";
    public static inline var TYPE_HSLIDER:String = "SliderH";
    public static inline var TYPE_XYPAD:String = "XY Pad";

    public static var CONTROL_CLASSES:Map<String, Dynamic> = [
        TYPE_PUSHBUTTON => PushButton,
        TYPE_TOGGLE => ToggleButton,
        TYPE_VSLIDER => VSlider,
        TYPE_HSLIDER => HSlider,
        TYPE_XYPAD => XYPad
    ];

    public var x:Int = 0;
    public var y:Int = 0;
    public var width:Int = 0;
    public var height:Int = 0;
    public var type:String = "";
    public var addressPattern = "/";
    public var title = "";
    public var fromValue:Float = 0;
    public var toValue:Float = 1;

    public static function fromDynamic(from:Dynamic):Control {
        var to:Control = new Control();
        to.x = from.x;
        to.y = from.y;
        to.width = from.width;
        to.height = from.height;
        to.type = from.type;
        to.addressPattern = from.addressPattern;
        to.fromValue = from.fromValue;
        to.toValue = from.toValue;
        to.title = from.title;
        return to;
    }
}