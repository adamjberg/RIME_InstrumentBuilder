package views.sidebar.tabs;

import views.instrument.controls.IControl;
import views.sidebar.components.ControlPropertiesComponent;
import views.sidebar.components.OscPropertiesComponent;

class ControlTab extends Tab {

    private var controlProperties:ControlPropertiesComponent;
    private var oscProperties:OscPropertiesComponent;

    public function new() {
        super("Control");
        controlProperties = new ControlPropertiesComponent();
        addComponent(controlProperties);
        oscProperties = new OscPropertiesComponent();
        addComponent(oscProperties);
    }

    public function setControl(control:IControl) {
        controlProperties.setControl(control);
        oscProperties.setProperties(control.properties);
    }
}