package views.instrument;

import haxe.ui.toolkit.containers.Absolute;
import haxe.ui.toolkit.core.Component;
import models.Control;
import models.ControlProperties;
import views.instrument.controls.IControl;

class Instrument extends Absolute {

    public function new() {
        super();
        style.backgroundColor = 0xFFFFFF;
    }

    public function addControlFromProperties(properties:ControlProperties):IControl {
        var type:String = properties.type;
        var controlClass:Dynamic = Control.CONTROL_CLASSES[type];

        var control:Dynamic = null;
        if(controlClass != null) {
            control = Type.createInstance(controlClass, [properties]);
            addChild(control);
        }

        return control;
    }
}