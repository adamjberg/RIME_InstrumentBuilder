package;

import haxe.ui.toolkit.containers.HBox;
import models.Command;
import models.Connection;
import models.Control;
import models.ControlProperties;
import models.LayoutSettings;
import openfl.events.Event;
import osc.OscMessage;
import views.builder.InstrumentBuilder;
import views.sidebar.SideBar;

class App extends HBox {

    private static var controlCount:Int = 1;

    public var layoutSettings:LayoutSettings;
    public var clientConnection:Connection;
    public var serverConnection:Connection;
    public var controlsMap:Map<String, Control>;
    public var controlValues:Map<String, Float>;

    public var clientUdpServer:UdpServer;
    public var serverUdpServer:UdpServer;
    public var sideBar:SideBar;
    public var instrumentBuilder:InstrumentBuilder;

    public function new() {
        super();

        percentWidth = 100;
        percentHeight = 100;

        layoutSettings = new LayoutSettings("layout1", 320, 480);
        clientConnection = new Connection("128.189.201.204", 12000);
        serverConnection = new Connection("127.0.0.1", 13000);

        controlsMap = new Map<String, Control>();
        controlValues = new Map<String, Float>();

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

#if !neko
        clientUdpServer = new UdpServer(12000);
        clientUdpServer.connect(clientConnection);
        clientUdpServer.onOSCMessageReceived.add(oscMessageReceived);
        serverUdpServer = new UdpServer(12001);
        serverUdpServer.connect(serverConnection);
        serverUdpServer.onOSCMessageReceived.add(oscMessageReceived);
        addEventListener(Event.ENTER_FRAME, onFrameEntered);
#end
        sideBar = new SideBar(layoutSettings, clientConnection, serverConnection);
        sideBar.onPropertiesUpdated.add(controlPropertiesUpdated);
        sideBar.onClientConnectPressed.add(connectClient);
        sideBar.onServerConnectPressed.add(connectServer);
        addChild(sideBar);

        instrumentBuilder = new InstrumentBuilder(controlProperties);
        addChild(instrumentBuilder);

        sideBar.onDimensionsChanged.add(instrumentBuilder.updateDimensions);

        instrumentBuilder.onControlAdded.add(controlAdded);
        instrumentBuilder.onControlSelected.add(controlSelected);
        instrumentBuilder.onControlDeselected.add(controlDeselected);
        instrumentBuilder.onControlUpdated.add(controlUpdated);
    }

    private function oscMessageReceived(message:OscMessage) {
        trace("Message Received " + message.addressPattern);
        controlValues.set(message.addressPattern, message.arguments[0]);
        var control:Control = controlsMap[message.addressPattern];
        if(control != null) {
            for(command in control.commands) {
                var message:OscMessage = new OscMessage(command.addressPattern);
                var value:Dynamic = command.values[0];
                var valueString = Std.string(value);
                if(controlValues.exists(valueString)) {
                    message.addFloat(controlValues.get(valueString));
                } else if(Std.is(value, String)){
                    message.addString(value);
                } else {
                    message.addFloat(value);
                }
                serverUdpServer.send(message);
            }
        }
    }

    private function connectClient(connection:Connection) {
        clientUdpServer.connect(connection);
    }

    private function connectServer(connection:Connection) {
        serverUdpServer.connect(connection);
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
        sideBar.controlSelected(getControl(addressPattern));
    }

    private function controlDeselected(addressPattern:String) {
        sideBar.controlDeselected(getControl(addressPattern));
    }

    private function controlUpdated(addressPattern:String) {
        sideBar.controlUpdated(getControl(addressPattern));
    }

    private function controlPropertiesUpdated() {
        instrumentBuilder.updateCurrentControl();
    }

    private function onFrameEntered(e:Event) {
        clientUdpServer.update();
        serverUdpServer.update();
    }
}