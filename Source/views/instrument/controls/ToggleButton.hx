package views.instrument.controls;

import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.events.UIEvent;
import models.Control;
import msignal.Signal.Signal1;
import views.instrument.controls.IControl;

class ToggleButton extends Button implements IControl {

    private static inline var DEFAULT_WIDTH:Int = 100;
    private static inline var DEFAULT_HEIGHT:Int = 100;

    private var _onValueChanged:Signal1<IControl> = new Signal1<IControl>();
    public var onValueChanged(get, null):Signal1<IControl>;
    public function get_onValueChanged():Signal1<IControl> {
        return _onValueChanged;
    }

    private var _properties:Control;
    public var properties(get, set):Control;
    public function get_properties():Control {
        return _properties;
    }
    public function set_properties(props:Control):Control {
        return _properties = props;
    }

    public function new(?properties:Control) {
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
        addEventListener(UIEvent.CHANGE, valueChanged);
    }

    public function getValue():Float {
        return selected ? properties.fromValue : properties.toValue;
    }

    public function update() {
        width = properties.width;
        height = properties.height;
        x = properties.x;
        y = properties.y;
    }

    private function valueChanged(e:UIEvent) {
        onValueChanged.dispatch(this);
    }

}