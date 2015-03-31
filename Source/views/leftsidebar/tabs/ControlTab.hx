package views.leftsidebar.tabs;

import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.events.UIEvent;
import models.Control;
import models.Control;
import msignal.Signal.Signal0;
import views.instrument.controls.IControl;
import views.leftsidebar.components.ControlComponent;
import views.leftsidebar.components.OscPropertiesComponent;

class ControlTab extends Tab {

    public var onPropertiesUpdated:Signal0 = new Signal0();
    public var onDeletePressed:Signal0 = new Signal0();

    private var properties:Control;

    private var controls:ControlComponent;
    private var oscProperties:OscPropertiesComponent;
    private var deleteButton:Button;

    public function new(?properties:Control) {
        super("Control");

        this.properties = properties;

        controls = new ControlComponent(properties);
        controls.onPropertiesUpdated.add(onPropertiesUpdated.dispatch);
        addComponent(controls);
        oscProperties = new OscPropertiesComponent();
        addComponent(oscProperties);

        deleteButton = new Button();
        deleteButton.text = "Delete";
        deleteButton.horizontalAlign = "center";
        deleteButton.onClick = function(e:UIEvent) {
            onDeletePressed.dispatch();
        }
        vBox.addChild(deleteButton);
    }

    public function update() {
        controls.update();
    }

    public function setControl(properties:Control) {
        this.properties = properties;
        controls.setControl(properties);
        oscProperties.setProperties(properties);
    }
}