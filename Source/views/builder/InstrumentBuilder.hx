package views.builder;

import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Spacer;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.core.renderers.ItemRenderer;
import haxe.ui.toolkit.events.UIEvent;
import models.Control;
import msignal.Signal.Signal1;
import openfl.events.MouseEvent;
import models.ControlProperties;
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

    public var onControlAdded:Signal1<ControlProperties> = new Signal1<ControlProperties>();
    public var onControlSelected:Signal1<String> = new Signal1<String>();
    public var onControlDeselected:Signal1<String> = new Signal1<String>();
    public var onControlUpdated:Signal1<String> = new Signal1<String>();

    private var controlProperties:Array<ControlProperties>;

    private var instrument:Instrument;
    private var selectedControl:IControl;
    private var mouseX:Int = 0;
    private var mouseY:Int = 0;
    private var controlMouseX:Int = 0;
    private var controlMouseY:Int = 0;

    public function new(?controlProperties:Array<ControlProperties>) {
        super();

        this.controlProperties = controlProperties;

        percentHeight = percentWidth = 100;
        style.backgroundColor = 0xAAAAAA;

        var spacer:Spacer = new Spacer();
        spacer.percentHeight = 50;
        addChild(spacer);

        instrument = new Instrument(controlProperties);
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
        var properties:ControlProperties = new ControlProperties();
        properties.x = mouseX;
        properties.y = mouseY;
        properties.type = selectedControlName;

        var control:IControl = instrument.addControlFromProperties(properties);
        var controlAsComponent = cast(control, Component);
        controlAsComponent.addEventListener(MouseEvent.MOUSE_DOWN, controlPressed);
        controlAsComponent.addEventListener(UIEvent.MOUSE_DOWN, controlMouseDown);
        controlAsComponent.addEventListener(UIEvent.MOUSE_UP, controlMouseUp);

        onControlAdded.dispatch(control.properties);
        onControlSelected.dispatch(control.properties.addressPattern);
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
        onControlSelected.dispatch(selectedControl.properties.addressPattern);
    }

    private function mouseDown(mouseEvent:MouseEvent) {
        if(selectedControl != null) {
            onControlDeselected.dispatch(selectedControl.properties.addressPattern);
        }
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
            onControlUpdated.dispatch(selectedControl.properties.addressPattern);
        }
    }
}