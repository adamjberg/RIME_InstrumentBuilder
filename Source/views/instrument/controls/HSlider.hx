package views.instrument.controls;

import models.ControlProperties;
import views.instrument.controls.IControl;

class HSlider extends haxe.ui.toolkit.controls.HSlider implements IControl {

    private static inline var DEFAULT_WIDTH:Int = 100;

    private var _properties:ControlProperties;
    public var properties(get, set):ControlProperties;
    public function get_properties():ControlProperties {
        return _properties;
    }
    public function set_properties(props:ControlProperties):ControlProperties {
        _properties = props;
        update();
        return _properties;
    }

    public function new(?properties:ControlProperties) {
        super();
        this.properties = properties;
    }

    override public function initialize() {
        super.initialize();

        if(properties.width == 0) {
            properties.width = DEFAULT_WIDTH;
        }
        if(properties.height == 0) {
            properties.height = Std.int(height);
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