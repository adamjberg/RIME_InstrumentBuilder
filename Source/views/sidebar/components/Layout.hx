package views.sidebar.components;

import views.controls.LabelledTextInput;
import views.sidebar.components.SidebarComponent;

class Layout extends SidebarComponent {

    private static inline var TITLE:String = "Layout";

    private var widthInput:LabelledTextInput;
    private var heightInput:LabelledTextInput;

    public function new() {
        super(TITLE);

        widthInput = new LabelledTextInput("width:  ");
        addChild(widthInput);

        heightInput = new LabelledTextInput("height:");
        addChild(heightInput);
    }
}