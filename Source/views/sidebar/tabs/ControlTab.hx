package views.sidebar.tabs;

import models.Command;
import models.Control;
import views.instrument.controls.IControl;
import views.sidebar.components.CommandComponent;
import views.sidebar.components.ControlPropertiesComponent;
import views.sidebar.components.OscPropertiesComponent;

class ControlTab extends Tab {

    private var control:Control;

    private var controlProperties:ControlPropertiesComponent;
    private var oscProperties:OscPropertiesComponent;
    private var commandComponent:CommandComponent;

    public function new(?control:Control) {
        super("Control");

        this.control = control;

        controlProperties = new ControlPropertiesComponent();
        addComponent(controlProperties);
        oscProperties = new OscPropertiesComponent();
        addComponent(oscProperties);
        commandComponent = new CommandComponent();
        addComponent(commandComponent);
    }

    public function setControl(control:Control) {
        this.control = control;
        controlProperties.setControlProperties(control.properties);
        oscProperties.setProperties(control.properties);
        commandComponent.setCommands(control.commands);
    }
}