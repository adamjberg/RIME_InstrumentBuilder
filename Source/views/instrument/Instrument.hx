package views.instrument;

import haxe.ui.toolkit.containers.Absolute;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.events.UIEvent;
import models.Control;
import models.Control;
import msignal.Signal.Signal1;
import views.instrument.controls.IControl;

class Instrument extends Absolute {

    public var onControlValueChanged:Signal1<IControl> = new Signal1<IControl>();

    public function new() {
        super();
        style.backgroundColor = 0xFFFFFF;
    }

    public function addControlFromProperties(properties:Control):IControl {
        var type:String = properties.type;
        var controlClass:Dynamic = Control.CONTROL_CLASSES[type];

        var control:IControl = null;
        if(controlClass != null) {
            control = Type.createInstance(controlClass, [properties]);
            control.onValueChanged.add(onControlValueChanged.dispatch);
            addChild(cast(control, Component));
        }

        return control;
    }
}