package;

import haxe.ui.toolkit.containers.HBox;
import models.Connection;
import models.LayoutSettings;
import openfl.events.Event;
import views.builder.InstrumentBuilder;
import views.sidebar.SideBar;

class App extends HBox {

    public var layoutSettings:LayoutSettings;
    public var clientConnection:Connection;
    public var serverConnection:Connection;

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

#if !neko
        server = new UdpServer("127.0.0.1", 11000);
        addEventListener(Event.ENTER_FRAME, onFrameEntered);
#end
        sideBar = new SideBar(layoutSettings, clientConnection, serverConnection);
        addChild(sideBar);

        instrumentBuilder = new InstrumentBuilder();
        addChild(instrumentBuilder);

        sideBar.onDimensionsChanged.add(instrumentBuilder.updateDimensions);

        instrumentBuilder.onControlSelected.add(sideBar.controlSelected);
        instrumentBuilder.onControlDeselected.add(sideBar.controlDeselected);
        instrumentBuilder.onControlUpdated.add(sideBar.controlUpdated);
    }

    private function onFrameEntered(e:Event) {
        server.update();
    }
}