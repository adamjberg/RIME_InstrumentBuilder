package views.instrument.controls;

import models.ControlProperties;
import views.instrument.controls.IControl;

class VSlider extends haxe.ui.toolkit.controls.VSlider implements IControl {

    private static inline var DEFAULT_HEIGHT:Int = 100;

    private var _properties:ControlProperties;
    public var properties(get, set):ControlProperties;
    public function get_properties():ControlProperties {
        return _properties;
    }
    public function set_properties(props:ControlProperties):ControlProperties {
        return _properties = props;
    }

    public function new(?properties:ControlProperties) {
        super();
        this.properties = properties;
    }

    override public function initialize() {
        super.initialize();
        if(this.properties.width == 0) {
            properties.width = Std.int(_thumb.width);
        }
        if(properties.height == 0) {
            properties.height = DEFAULT_HEIGHT;
        }
        update();
    }

    public function update() {
        width = properties.width;
        height = properties.height;
        x = properties.x;
        y = properties.y;
    }

}