package views.leftsidebar.components;

import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.events.UIEvent;
import msignal.Signal.Signal0;
import views.controls.LabelledTextInput;
import models.Control;
import views.instrument.controls.IControl;
import views.leftsidebar.components.SidebarComponent;

class ControlComponent extends SidebarComponent {

    private static inline var TITLE:String = "Properties";

    public var onPropertiesUpdated:Signal0 = new Signal0();

    private var properties:Control;

    private var xInput:LabelledTextInput;
    private var yInput:LabelledTextInput;
    private var widthInput:LabelledTextInput;
    private var heightInput:LabelledTextInput;
    private var labelInput:LabelledTextInput;

    public function new(?properties:Control) {
        super(TITLE);

        labelInput = new LabelledTextInput("Name");
        addChild(labelInput);

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

        labelInput.addEventListener(UIEvent.CHANGE, updateControl);
        xInput.addEventListener(UIEvent.CHANGE, updateControl);
        yInput.addEventListener(UIEvent.CHANGE, updateControl);
        widthInput.addEventListener(UIEvent.CHANGE, updateControl);
        heightInput.addEventListener(UIEvent.CHANGE, updateControl);

        addChild(xyHBox);
        addChild(widthHeightHBox);
        setControl(properties);
    }

    public function setControl(properties:Control) {
        this.properties = properties;
        update();
    }

    public function update() {
        labelInput.setText(properties.title);
        xInput.setText(Std.string(properties.x));
        yInput.setText(Std.string(properties.y));
        widthInput.setText(Std.string(properties.width));
        heightInput.setText(Std.string(properties.height));
    }

    private function updateControl(e:UIEvent) {
        var title:String = labelInput.getText();
        var x:Dynamic = Std.parseInt(xInput.getText());
        var y:Dynamic = Std.parseInt(yInput.getText());
        var width:Dynamic = Std.parseInt(widthInput.getText());
        var height:Dynamic = Std.parseInt(heightInput.getText());

        properties.title = title;
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

        onPropertiesUpdated.dispatch();
    }
}