package views.instrument.controls;

import haxe.ui.toolkit.events.UIEvent;
import models.ControlProperties;
import msignal.Signal.Signal1;
import views.instrument.controls.IControl;

class VSlider extends haxe.ui.toolkit.controls.VSlider implements IControl {

    private static inline var DEFAULT_HEIGHT:Int = 100;

    private var _onValueChanged:Signal1<IControl> = new Signal1<IControl>();
    public var onValueChanged(get, null):Signal1<IControl>;
    public function get_onValueChanged():Signal1<IControl> {
        return _onValueChanged;
    }

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
        addEventListener(UIEvent.CHANGE, valueChanged);
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

    public function getValue():Float {
        return (value / 100) * (properties.toValue - properties.fromValue) + properties.fromValue;
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