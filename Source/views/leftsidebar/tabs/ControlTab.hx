package views.leftsidebar.tabs;

import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.events.UIEvent;
import models.Control;
import msignal.Signal.Signal0;
import views.instrument.controls.IControl;
import views.leftsidebar.components.ControlPropertiesComponent;
import views.leftsidebar.components.OscPropertiesComponent;

class ControlTab extends Tab {

    public var onPropertiesUpdated:Signal0 = new Signal0();
    public var onDeletePressed:Signal0 = new Signal0();

    private var control:Control;

    private var controlProperties:ControlPropertiesComponent;
    private var oscProperties:OscPropertiesComponent;
    private var deleteButton:Button;

    public function new(?control:Control) {
        super("Control");

        this.control = control;

        controlProperties = new ControlPropertiesComponent();
        controlProperties.onPropertiesUpdated.add(onPropertiesUpdated.dispatch);
        addComponent(controlProperties);
        oscProperties = new OscPropertiesComponent();
        addComponent(oscProperties);

        deleteButton = new Button();
        deleteButton.text = "Delete";
        deleteButton.horizontalAlign = "center";
        deleteButton.onClick = function(e:UIEvent) {
            onDeletePressed.dispatch();
        }
        addChild(deleteButton);
    }

    public function setControl(control:Control) {
        this.control = control;
        controlProperties.setControlProperties(control.properties);
        oscProperties.setProperties(control.properties);
    }
}