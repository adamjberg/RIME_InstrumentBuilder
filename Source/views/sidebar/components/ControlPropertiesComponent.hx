package views.sidebar.components;

import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.events.UIEvent;
import views.controls.LabelledTextInput;
import views.instrument.controls.ControlProperties;
import views.instrument.controls.IControl;
import views.sidebar.components.SidebarComponent;

class ControlPropertiesComponent extends SidebarComponent {

    private static inline var TITLE:String = "Properties";

    private var control:IControl;

    private var xInput:LabelledTextInput;
    private var yInput:LabelledTextInput;
    private var widthInput:LabelledTextInput;
    private var heightInput:LabelledTextInput;

    public function new() {
        super(TITLE);

        var xyHBox:HBox = new HBox();
        xyHBox.percentWidth = 100;
        xInput = new LabelledTextInput("X");
        xInput.percentWidth = 50;
        yInput = new LabelledTextInput("Y");
        yInput.percentWidth = 50;
        xyHBox.addChild(xInput);
        xyHBox.addChild(yInput);

        var widthHeightHBox:HBox = new HBox();
        widthHeightHBox.percentWidth = 100;
        widthInput = new LabelledTextInput("W");
        widthInput.percentWidth = 50;
        heightInput = new LabelledTextInput("H");
        heightInput.percentWidth = 50;
        widthHeightHBox.addChild(widthInput);
        widthHeightHBox.addChild(heightInput);

        xInput.addEventListener(UIEvent.CHANGE, updateControl);
        yInput.addEventListener(UIEvent.CHANGE, updateControl);
        widthInput.addEventListener(UIEvent.CHANGE, updateControl);
        heightInput.addEventListener(UIEvent.CHANGE, updateControl);

        addChild(xyHBox);
        addChild(widthHeightHBox);
    }

    public function setControl(control:IControl) {
        this.control = control;
        var properties:ControlProperties = control.properties;
        xInput.setText(Std.string(properties.x));
        yInput.setText(Std.string(properties.y));
        widthInput.setText(Std.string(properties.width));
        heightInput.setText(Std.string(properties.height));
    }

    private function updateControl(e:UIEvent) {
        var properties:ControlProperties = control.properties;
        var x:Dynamic = Std.parseInt(xInput.getText());
        var y:Dynamic = Std.parseInt(yInput.getText());
        var width:Dynamic = Std.parseInt(widthInput.getText());
        var height:Dynamic = Std.parseInt(heightInput.getText());

        if(x != null) {
            properties.x = x;
        }
        if(y != null) {
            properties.y = y;
        }
        if(width != null) {
            properties.width = width;
        }
        if(height != null) {
            properties.height = height;
        }
        control.update();
    }
}