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
        clientConnection = new Connection("127.0.0.1", 11000);
        serverConnection = new Connection("127.0.0.1", 12000);

        controlsMap = new Map<String, Control>();
        controlValues = new Map<String, Float>();

        var props:ControlProperties = new ControlProperties();
        props.addressPattern = "/control1";
        props.type = Control.TYPE_PUSHBUTTON;
        props.x = 10;
        props.y = 10;
        var control:Control = new Control(props, [new Command("/x", ["/control1"])]);
        controlsMap.set(props.addressPattern, control);
        var controlProperties:Array<ControlProperties> = new Array<ControlProperties>();
        controlProperties.push(props);

#if !neko
        clientUdpServer = new UdpServer("127.0.0.1", 11000);
        clientUdpServer.onOSCMessageReceived.add(oscMessageReceived);
        serverUdpServer = new UdpServer("127.0.0.1", 13000);
        addEventListener(Event.ENTER_FRAME, onFrameEntered);
#end
        sideBar = new SideBar(layoutSettings, clientConnection, serverConnection);
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

    private function onFrameEntered(e:Event) {
        clientUdpServer.update();
        serverUdpServer.update();
    }
}