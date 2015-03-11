package views.instrument;

import haxe.ui.toolkit.containers.Absolute;
import haxe.ui.toolkit.core.Component;
import models.Control;
import models.ControlProperties;
import views.instrument.controls.IControl;

class Instrument extends Absolute {

    public var controlProperties:Array<ControlProperties>;

    public function new(?controlProperties:Array<ControlProperties>) {
        super();

        this.controlProperties = controlProperties;

        style.backgroundColor = 0xFFFFFF;
        update();
    }

    public function update() {
        removeAllChildren();
        for(properties in controlProperties) {
            addControlFromProperties(properties);
        }
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