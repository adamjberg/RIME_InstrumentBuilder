package;

import haxe.ui.toolkit.containers.HBox;
import models.Command;
import models.Connection;
import models.Control;
import models.ControlProperties;
import models.LayoutSettings;
import openfl.events.Event;
import views.builder.InstrumentBuilder;
import views.sidebar.SideBar;

class App extends HBox {

    private static var controlCount:Int = 1;

    public var layoutSettings:LayoutSettings;
    public var clientConnection:Connection;
    public var serverConnection:Connection;
    public var controlsMap:Map<String, Control>;

    public var server:UdpServer;
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

        var props:ControlProperties = new ControlProperties();
        props.addressPattern = "/control1";
        props.type = Control.TYPE_PUSHBUTTON;
        props.x = 10;
        props.y = 10;
        var control:Control = new Control(props);
        controlsMap.set(props.addressPattern, control);
        var controlProperties:Array<ControlProperties> = new Array<ControlProperties>();

#if !neko
        server = new UdpServer("127.0.0.1", 11000);
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
        server.update();
    }
}