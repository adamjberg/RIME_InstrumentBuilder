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
import models.Control;
import views.instrument.controls.*;
import views.instrument.Instrument;

class InstrumentBuilder extends VBox {

    public var onControlAdded:Signal1<Control> = new Signal1<Control>();
    public var onControlSelected:Signal1<String> = new Signal1<String>();
    public var onControlDeselected:Signal1<String> = new Signal1<String>();
    public var onControlUpdated:Signal1<String> = new Signal1<String>();

    private var controls:Array<Control>;

    private var instrument:Instrument;
    public var selectedControl:IControl;
    private var mouseX:Int = 0;
    private var mouseY:Int = 0;
    private var controlMouseX:Int = 0;
    private var controlMouseY:Int = 0;

    public function new(?controls:Array<Control>) {
        super();

        this.controls = controls;

        percentWidth = 50;
        percentHeight = 100;
        style.backgroundColor = 0xAAAAAA;

        var spacer:Spacer = new Spacer();
        spacer.percentHeight = 50;
        addChild(spacer);

        instrument = new Instrument();
        instrument.horizontalAlign = "center";
        addChild(instrument);

        for(control in controls) {
            addControlToBuilder(control);
        }

        addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
        addEventListener(UIEvent.MOUSE_UP, mouseUp);
        instrument.addEventListener(MouseEvent.MOUSE_DOWN, instrumentPressed);
    }

    public function updateDimensions(width, height) {
        instrument.width = width;
        instrument.height = height;
    }

    public function updateCurrentControl() {
        if(selectedControl != null) {
            selectedControl.update();
        }
    }

    private function instrumentPressed(mouseEvent:MouseEvent) {
        if(selectedControl == null) {
            mouseX = Std.int(mouseEvent.localX);
            mouseY = Std.int(mouseEvent.localY);
            var controlNames:Array<String> = new Array<String>();
            for(key in Control.CONTROL_CLASSES.keys()) {
                controlNames.push(key);
            }
            controlNames.sort(function(a,b) {
                return Reflect.compare(a.toLowerCase(), b.toLowerCase());
            });
            PopupManager.instance.showList(controlNames, -1, "Select a Control", {buttons:PopupButton.CANCEL}, controlSelected);
        }
    }

    private function controlSelected(value:Dynamic) {
        if(value == null || Std.is(value, Int)) {
            return;
        }
        var selectedItem:ItemRenderer = value;
        var selectedControlName:String = selectedItem.data.text;
        var control:Control = new Control();
        control.x = mouseX;
        control.y = mouseY;
        control.type = selectedControlName;

        addControlToBuilder(control);
    }

    private function addControlToBuilder(control:Control) {
        var control:IControl = instrument.addControlFromProperties(control);
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