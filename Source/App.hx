package;

import haxe.ui.toolkit.containers.HBox;
import openfl.events.Event;
import views.sidebar.SideBar;

class App extends HBox {

    public var server:UdpServer;
    public var sideBar:SideBar;

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
    }

    private function onFrameEntered(e:Event) {
        server.update();
    }
}