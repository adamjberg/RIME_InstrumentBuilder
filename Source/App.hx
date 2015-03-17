package;

import haxe.Json;
import haxe.ui.toolkit.containers.HBox;
import models.Command;
import models.Connection;
import models.Control;
import models.ControlProperties;
import models.LayoutSettings;
import models.sensors.*;
import openfl.events.Event;
import osc.OscMessage;
import views.builder.InstrumentBuilder;
import views.leftsidebar.LeftSideBar;
import views.sensorsidebar.SensorSideBar;

class App extends HBox {

    private static var controlCount:Int = 1;

    public var layoutSettings:LayoutSettings;
    public var clientConnection:Connection;
    public var serverConnection:Connection;
    public var controlsMap:Map<String, Control>;
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

        layoutSettings = new LayoutSettings("layout1", 320, 480);
        clientConnection = new Connection("127.0.0.1", 11000);
        serverConnection = new Connection("127.0.0.1", 13000);

        controlsMap = new Map<String, Control>();
        sensors = [
            new Accelerometer(),
            new AmbientTemperature(),
            new Gravity(),
            new Gyroscope(),
            new Humidity(),
            new Light(),
            new LinearAccelerometer(),
            new Magnetic(),
            new Orientation(),
            new Pressure(),
            new Proximity()
        ];
        commands = [
            new Command("/test", ["success"]),
            new Command("/test2", ["success2"]),
            new Command("/test3", ["success"]),
            new Command("/test4", ["success2"]),
            new Command("/test5", ["success"]),
            new Command("/test6", ["success2"]),
        ];

        var controlProperties:Array<ControlProperties> = new Array<ControlProperties>();

        var props:ControlProperties = new ControlProperties();
        var control:Control;
        var sliderWidth:Int = 300;
        var buttonWidth:Int = 300;
        var buttonHeight:Int = 40;
        
        props.addressPattern = "/slider1";
        props.type = Control.TYPE_HSLIDER;
        props.x = 10;
        props.y = 10;
        props.width = sliderWidth;
        control = new Control(props, [new Command("/x", ["/slider1"])]);
        controlsMap.set(props.addressPattern, control);
        controlProperties.push(props);

        props = new ControlProperties();
        props.addressPattern = "/slider2";
        props.type = Control.TYPE_HSLIDER;
        props.x = 10;
        props.y = 50;
        props.width = sliderWidth;
        control = new Control(props, [new Command("/y", ["/slider2"])]);
        controlsMap.set(props.addressPattern, control);
        controlProperties.push(props);

        props = new ControlProperties();
        props.addressPattern = "/button1";
        props.type = Control.TYPE_PUSHBUTTON;
        props.x = 10;
        props.y = 90;
        props.width = buttonWidth;
        props.height = buttonHeight;
        control = new Control(props, [new Command("/visible", ["/button1"])]);
        controlsMap.set(props.addressPattern, control);
        controlProperties.push(props);

        props = new ControlProperties();
        props.addressPattern = "/button2";
        props.type = Control.TYPE_PUSHBUTTON;
        props.x = 10;
        props.y = 140;
        props.width = buttonWidth;
        props.height = buttonHeight;
        control = new Control(props, [new Command("/visible", ["/button2"])]);
        controlsMap.set(props.addressPattern, control);
        controlProperties.push(props);

        props = new ControlProperties();
        props.addressPattern = "/slider3";
        props.type = Control.TYPE_HSLIDER;
        props.x = 10;
        props.y = 190;
        props.width = sliderWidth;
        control = new Control(props, [new Command("/width", ["/slider3"])]);
        controlsMap.set(props.addressPattern, control);
        controlProperties.push(props);

        props = new ControlProperties();
        props.addressPattern = "/slider4";
        props.type = Control.TYPE_HSLIDER;
        props.x = 10;
        props.y = 230;
        props.width = sliderWidth;
        control = new Control(props, [new Command("/height", ["/slider4"])]);
        controlsMap.set(props.addressPattern, control);
        controlProperties.push(props);

        server = new UdpServer(12000);
        listenerThread = new UdpListenerThread(server, controlsMap, serverConnection, sensors);

        leftSideBar = new LeftSideBar(layoutSettings, clientConnection, serverConnection, commands);
        leftSideBar.onPropertiesUpdated.add(controlPropertiesUpdated);
        leftSideBar.onClientSyncPressed.add(syncClient);
        addChild(leftSideBar);

        instrumentBuilder = new InstrumentBuilder(controlProperties);
        addChild(instrumentBuilder);

        sensorSideBar = new SensorSideBar(sensors);
        addChild(sensorSideBar);

        leftSideBar.onDimensionsChanged.add(instrumentBuilder.updateDimensions);

        instrumentBuilder.onControlAdded.add(controlAdded);
        instrumentBuilder.onControlSelected.add(controlSelected);
        instrumentBuilder.onControlDeselected.add(controlDeselected);
        instrumentBuilder.onControlUpdated.add(controlUpdated);
    }

    private function syncClient(connection:Connection) {
        var controlPropertiesArray:Array<Dynamic> = new Array<Dynamic>();
        var controlProperties:ControlProperties;
        for(control in controlsMap.iterator()) {
            controlProperties = control.properties;
            controlPropertiesArray.push(control.properties);
        }
        var controlPropertiesString:String = Json.stringify(controlPropertiesArray);
        var syncMessage = new OscMessage("/sync");
        syncMessage.addString(controlPropertiesString);
        server.sendTo(syncMessage, clientConnection);
    }

    private function getControl(addressPattern:String):Control {
        return controlsMap[addressPattern];
    }

    private function generateAddressPattern():String {
        return "control" + controlCount;
    }

    private function controlAdded(controlProperties:ControlProperties) {
        controlProperties.addressPattern = generateAddressPattern();
        var control:Control = new Control(controlProperties);
        controlsMap.set(controlProperties.addressPattern, control); 
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

    private function controlPropertiesUpdated() {
        instrumentBuilder.updateCurrentControl();
    }
}