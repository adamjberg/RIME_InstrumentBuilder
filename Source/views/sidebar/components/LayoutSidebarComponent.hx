package views.sidebar.components;

import haxe.ui.toolkit.events.UIEvent;
import models.LayoutSettings;
import msignal.Signal.Signal2;
import views.controls.LabelledTextInput;
import views.sidebar.components.SidebarComponent;

class LayoutSidebarComponent extends SidebarComponent {

    private static inline var TITLE:String = "Layout";

    public var onDimensionsChanged:Signal2<Int, Int> = new Signal2<Int, Int>();

    private var layoutSettings:LayoutSettings;

    private var nameInput:LabelledTextInput;
    private var widthInput:LabelledTextInput;
    private var heightInput:LabelledTextInput;

    public function new(?layoutSettings:LayoutSettings) {
        super(TITLE);

        this.layoutSettings = layoutSettings;

        nameInput = new LabelledTextInput("Name:");
        nameInput.setText(layoutSettings.name);
        addChild(nameInput);

        widthInput = new LabelledTextInput("Width:  ");
        widthInput.setText(Std.string(layoutSettings.width));
        addChild(widthInput);

        heightInput = new LabelledTextInput("Height:");
        heightInput.setText(Std.string(layoutSettings.height));
        addChild(heightInput);

        widthInput.addEventListener(UIEvent.CHANGE, dimensionsChanged);
        heightInput.addEventListener(UIEvent.CHANGE, dimensionsChanged);
    }

    private function nameChanged(e:UIEvent) {
        updateLayout();
    }

    private function dimensionsChanged(e:UIEvent) {
        updateLayout();
        onDimensionsChanged.dispatch(layoutSettings.width, layoutSettings.height);
    }

    private function updateLayout(){
        var width:Dynamic = Std.parseInt(widthInput.getText());
        var height:Dynamic = Std.parseInt(heightInput.getText());

        if(width != null) {
            layoutSettings.width = width;
        }
        if(height != null) {
            layoutSettings.height = height;
        }
        layoutSettings.name = nameInput.getText();
    }
}