package views.instrument.controls;

import haxe.ui.toolkit.controls.Button;
import models.ControlProperties;
import views.instrument.controls.IControl;

class ToggleButton extends Button implements IControl {

    private static inline var DEFAULT_WIDTH:Int = 100;
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
        this.toggle = true;
        this.properties = properties;
        if(this.properties.width == 0) {
            properties.width = DEFAULT_WIDTH;
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