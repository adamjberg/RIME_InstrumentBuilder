package;

import haxe.ui.toolkit.containers.HBox;
import openfl.events.Event;
import views.builder.InstrumentBuilder;
import views.sidebar.SideBar;

class App extends HBox {

    public var server:UdpServer;
    public var sideBar:SideBar;
    public var instrumentBuilder:InstrumentBuilder;

    public function new() {
        super();

        percentWidth = 100;
        percentHeight = 100;

#if !neko
        server = new UdpServer("127.0.0.1", 11000);
        addEventListener(Event.ENTER_FRAME, onFrameEntered);
#end
        sideBar = new SideBar();
        addChild(sideBar);

        instrumentBuilder = new InstrumentBuilder();
        addChild(instrumentBuilder);

        instrumentBuilder.onControlSelected.add(sideBar.controlSelected);
        instrumentBuilder.onControlDeselected.add(sideBar.controlDeselected);
    }

    private function onFrameEntered(e:Event) {
        server.update();
    }
}