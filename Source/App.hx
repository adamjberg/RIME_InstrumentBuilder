package;

import haxe.Json;
import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.core.renderers.ItemRenderer;
import models.Command;
import models.Connection;
import models.Control;
import models.Control;
import models.LayoutSettings;
import models.sensors.*;
import openfl.events.Event;
import osc.OscMessage;
import sys.FileSystem;
import sys.io.File;
import views.builder.InstrumentBuilder;
import views.leftsidebar.LeftSideBar;
import views.sensorsidebar.SensorSideBar;

class App extends HBox {

    private static inline var SAVE_DIRECTORY:String = "layouts";
    private static var controlCount:Int = 1;

    public var layoutSettings:LayoutSettings;
    public var clientConnection:Connection;
    public var controls:Array<Control>;
    public var sensors:Array<Sensor>;
    public var commands:Array<Command>;

    public var server:UdpServer;
    public var leftSideBar:LeftSideBar;
    public var sensorSideBar:SensorSideBar;
    public var instrumentBuilder:InstrumentBuilder;

    public var listenerThread:UdpListenerThread;

    public function new() {
        super();

        percentWidth = 100;
        percentHeight = 100;

        sensors = [
            new Accelerometer(),
            new LinearAccelerometer(),
            new Orientation(),
            new Gyroscope(),
            new Gravity(),
            new Gyroscope()
        ];

        server = new UdpServer(12000);
        reloadUI();
    }

    private function reloadUI(?saveFileObj:Dynamic) {
        removeAllChildren();
        if(saveFileObj != null) {
            controls = new Array<Control>();
            for(c in cast(saveFileObj.controls, Array<Dynamic>)) {
                controls.push(Control.fromDynamic(c));
            }
            commands = new Array<Command>();
            for(c in cast(saveFileObj.commands, Array<Dynamic>)) {
                commands.push(Command.fromDynamic(c));
            }
            layoutSettings = LayoutSettings.fromDynamic(saveFileObj.layout);
            clientConnection = Connection.fromDynamic(saveFileObj.clientConnection);
        } else {
            controls = new Array<Control>();
            commands = [];
            layoutSettings = new LayoutSettings("layout1", 320, 480);
            clientConnection = new Connection("127.0.0.1", 11000);
        }
        listenerThread = new UdpListenerThread(server, sensors);

        leftSideBar = new LeftSideBar(layoutSettings, clientConnection, commands);
        leftSideBar.onPropertiesUpdated.add(controlsUpdated);
        leftSideBar.onClientSyncPressed.add(syncClient);
        leftSideBar.onSavePressed.add(save);
        leftSideBar.onLoadPressed.add(openLoadFilePopup);
        leftSideBar.onDeleteControlPressed.add(deleteSelectedControl);
        addChild(leftSideBar);

        refreshInstrumentBuilder();

        sensorSideBar = new SensorSideBar(sensors);
        addChild(sensorSideBar);
    }

    private function refreshInstrumentBuilder() {
        removeChild(instrumentBuilder);
        instrumentBuilder = new InstrumentBuilder(controls);
        instrumentBuilder.updateDimensions(layoutSettings.width, layoutSettings.height);

        addChildAt(instrumentBuilder, 1);

        instrumentBuilder.onControlAdded.add(controlAdded);
        instrumentBuilder.onControlSelected.add(controlSelected);
        instrumentBuilder.onControlDeselected.add(controlDeselected);
        instrumentBuilder.onControlUpdated.add(controlUpdated);
        leftSideBar.onDimensionsChanged.add(instrumentBuilder.updateDimensions);
    }

    private function openLoadFilePopup() {
        FileSystem.createDirectory(SAVE_DIRECTORY);
        var filenames:Array<String> = FileSystem.readDirectory(SAVE_DIRECTORY);
        PopupManager.instance.showList(filenames, -1, "Select file to load", { buttons: PopupButton.CANCEL }, fileSelected);
    }

    private function fileSelected(selectedObject:Dynamic) {
        if(selectedObject == null || Std.is(selectedObject, Int)) {
        }
        else if(selectedObject != null && Std.is(selectedObject, ItemRenderer)) {
            var item:ItemRenderer = selectedObject;
            loadFile(item.data.text);
        }
    }

    private function loadFile(filename:String) {
        var filenameWithDirectory:String = SAVE_DIRECTORY + "/" + filename;
        if(FileSystem.exists(filenameWithDirectory)) {
            var saveFileObj:Dynamic = Json.parse(File.getContent(filenameWithDirectory));
            reloadUI(saveFileObj);
        }
    }

    private function save() {
        var saveFileObj:Dynamic = {};
        saveFileObj.layout = layoutSettings;
        saveFileObj.controls = controls;
        saveFileObj.commands = commands;
        saveFileObj.clientConnection = clientConnection;
        
        var filename:String = layoutSettings.name + ".rime";
        var filenameWithDirectory:String = SAVE_DIRECTORY + "/" + filename;
        FileSystem.createDirectory(SAVE_DIRECTORY);
        if(FileSystem.exists(filename)) {
            FileSystem.deleteFile(filename);
        }
        File.saveContent(filenameWithDirectory, Json.stringify(saveFileObj));
    }

    private function syncClient(connection:Connection) {
        var controlsString:String = Json.stringify(controls);
        var syncMessage = new OscMessage("/sync");
        syncMessage.addString(controlsString);
        server.sendTo(syncMessage, clientConnection);
    }

    private function deleteSelectedControl() {
        var control:Control = instrumentBuilder.selectedControl.properties;
        controls.remove(control);
        refreshInstrumentBuilder();
    }

    private function getControl(addressPattern:String):Control {
        for( control in controls) {
            if(control.addressPattern == addressPattern) {
                return control;
            }
        }
        return null;
    }

    private function generateAddressPattern():String {
        return "/control" + controlCount++;
    }

    private function controlAdded(control:Control) {
        control.addressPattern = generateAddressPattern();
        controls.push(control); 
    }

    private function controlSelected(addressPattern:String) {
        leftSideBar.controlSelected(getControl(addressPattern));
    }

    private function controlDeselected(addressPattern:String) {
        leftSideBar.controlDeselected(getControl(addressPattern));
    }

    private function controlUpdated(addressPattern:String) {
        leftSideBar.controlUpdated(getControl(addressPattern));
    }

    private function controlsUpdated() {
        instrumentBuilder.updateCurrentControl();
    }
}