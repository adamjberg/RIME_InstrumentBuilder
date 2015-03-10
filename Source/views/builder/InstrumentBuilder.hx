package views.builder;

import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Spacer;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.core.renderers.ItemRenderer;
import haxe.ui.toolkit.events.UIEvent;
import msignal.Signal.Signal1;
import openfl.events.MouseEvent;
import views.instrument.controls.*;
import views.instrument.Instrument;

class InstrumentBuilder extends VBox {

    private static var CONTROL_NAMES:Array<String> = [
        "Push Button",
        "Toggle Button",
        "HSlider",
        "VSlider"
    ];

    private static var CONTROL_CLASSES:Array<Dynamic> = [
        PushButton,
        ToggleButton,
        HSlider,
        VSlider
    ];

    public var onControlSelected:Signal1<IControl> = new Signal1<IControl>();
    public var onControlDeselected:Signal1<IControl> = new Signal1<IControl>();
    public var onControlUpdated:Signal1<IControl> = new Signal1<IControl>();

    private var instrument:Instrument;
    private var selectedControl:IControl;
    private var mouseX:Int = 0;
    private var mouseY:Int = 0;
    private var controlMouseX:Int = 0;
    private var controlMouseY:Int = 0;

    public function new() {
        super();
        percentHeight = percentWidth = 100;
        style.backgroundColor = 0xAAAAAA;

        var spacer:Spacer = new Spacer();
        spacer.percentHeight = 50;
        addChild(spacer);

        instrument = new Instrument();
        instrument.horizontalAlign = "center";
        addChild(instrument);

        addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
        addEventListener(UIEvent.MOUSE_UP, mouseUp);
        instrument.addEventListener(MouseEvent.MOUSE_DOWN, instrumentPressed);
        updateDimensions(320, 480);
    }

    public function updateDimensions(width, height) {
        instrument.width = width;
        instrument.height = height;
    }

    private function instrumentPressed(mouseEvent:MouseEvent) {
        if(selectedControl == null) {
            mouseX = Std.int(mouseEvent.localX);
            mouseY = Std.int(mouseEvent.localY);
            PopupManager.instance.showList(CONTROL_NAMES, -1, "Select a Control", null, controlSelected);
        }
    }

    private function controlSelected(selectedItem:ItemRenderer) {
        var selectedControlName:String = selectedItem.data.text;
        var selectedControlIndex:Int = CONTROL_NAMES.indexOf(selectedControlName);
        var properties:ControlProperties = new ControlProperties();
        properties.x = mouseX;
        properties.y = mouseY;

        var controlClass:Dynamic = CONTROL_CLASSES[selectedControlIndex];
        var control:Dynamic = Type.createInstance(controlClass, [properties]);
        var controlAsComponent:Component = cast(control, Component);
        instrument.addChild(controlAsComponent);
        controlAsComponent.addEventListener(MouseEvent.MOUSE_DOWN, controlPressed);
        controlAsComponent.addEventListener(UIEvent.MOUSE_DOWN, controlMouseDown);
        controlAsComponent.addEventListener(UIEvent.MOUSE_UP, controlMouseUp);
        
        onControlSelected.dispatch(control);
    }

    private function controlPressed(mouseEvent:MouseEvent) {
        mouseEvent.stopPropagation();
    }

    private function controlMouseUp(uiEvent:UIEvent) {
        uiEvent.stopPropagation();
    }

    private function controlMouseDown(uiEvent:UIEvent) {
        uiEvent.stopPropagation();
        selectedControl = cast(uiEvent.component, IControl);
        controlMouseX = Std.int(uiEvent.stageX - uiEvent.component.stageX);
        controlMouseY = Std.int(uiEvent.stageY - uiEvent.component.stageY);
        instrument.addEventListener(UIEvent.MOUSE_MOVE, moveMoved);
        onControlSelected.dispatch(selectedControl);
    }

    private function mouseDown(mouseEvent:MouseEvent) {
        onControlDeselected.dispatch(selectedControl);
        selectedControl = null;
    }

    private function mouseUp(mouseEvent:UIEvent) {
        instrument.removeEventListener(UIEvent.MOUSE_MOVE, moveMoved);
    }

    private function moveMoved(mouseEvent:UIEvent) {
        if(selectedControl != null) {
            selectedControl.properties.x = Std.int(mouseEvent.stageX - instrument.stageX - controlMouseX);
            selectedControl.properties.y = Std.int(mouseEvent.stageY - instrument.stageY - controlMouseY);
            selectedControl.update();
            onControlUpdated.dispatch(selectedControl);
        }
    }
}