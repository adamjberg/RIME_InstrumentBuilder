package models;

import models.Command;
import models.ControlProperties;
import views.instrument.controls.HSlider;
import views.instrument.controls.PushButton;
import views.instrument.controls.ToggleButton;
import views.instrument.controls.VSlider;

class Control {

    public static inline var TYPE_PUSHBUTTON:String = "Push Button";
    public static inline var TYPE_TOGGLE:String = "Toggle";
    public static inline var TYPE_VSLIDER:String = "SliderV";
    public static inline var TYPE_HSLIDER:String = "SliderH";

    public static var CONTROL_CLASSES:Map<String, Dynamic> = [
        TYPE_PUSHBUTTON => PushButton,
        TYPE_TOGGLE => ToggleButton,
        TYPE_VSLIDER => VSlider,
        TYPE_HSLIDER => HSlider
    ];

    public var properties:ControlProperties;
    public var commands:Array<Command>;
    public var values:Array<Float>;

    public static function fromDynamic(from:Dynamic):Control {
        return new Control(
            ControlProperties.fromDynamic(from.properties), from.commands
        );
    }

    public function new(?properties:ControlProperties, ?commands:Array<Command>) {
        if(properties != null) { 
            this.properties = properties;
        } else {
            this.properties = new ControlProperties();
        }
        if(commands != null) {
            this.commands = commands;
        } else {
            this.commands = new Array<Command>();
        }

        if(this.commands.length == 0) {
            this.commands.push(new Command());
        }
        values = new Array<Float>();
    }
}