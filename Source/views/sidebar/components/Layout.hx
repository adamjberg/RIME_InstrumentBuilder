package views.sidebar.components;

import haxe.ui.toolkit.events.UIEvent;
import msignal.Signal.Signal2;
import views.controls.LabelledTextInput;
import views.sidebar.components.SidebarComponent;

class Layout extends SidebarComponent {

    private static inline var TITLE:String = "Layout";

    public var onDimensionsChanged:Signal2<Int, Int> = new Signal2<Int, Int>();

    private var nameInput:LabelledTextInput;
    private var widthInput:LabelledTextInput;
    private var heightInput:LabelledTextInput;

    public function new() {
        super(TITLE);

        nameInput = new LabelledTextInput("Name:");
        addChild(nameInput);

        widthInput = new LabelledTextInput("Width:  ");
        addChild(widthInput);

        heightInput = new LabelledTextInput("Height:");
        addChild(heightInput);

        widthInput.addEventListener(UIEvent.CHANGE, dimensionsChanged);
        heightInput.addEventListener(UIEvent.CHANGE, dimensionsChanged);
    }

    private function dimensionsChanged(e:UIEvent) {
        var width:Dynamic = Std.parseInt(widthInput.getText());
        var height:Dynamic = Std.parseInt(heightInput.getText());

        if(width != null && height != null) {
            onDimensionsChanged.dispatch(width, height);
        }
    }
}