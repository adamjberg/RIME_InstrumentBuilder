package views.leftsidebar;

import haxe.ui.toolkit.containers.TabView;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Text;
import models.Connection;
import models.Control;
import models.LayoutSettings;
import msignal.Signal.Signal0;
import msignal.Signal.Signal1;
import msignal.Signal.Signal2;
import openfl.events.Event;
import views.instrument.controls.IControl;
import views.leftsidebar.tabs.*;

class LeftSideBar extends TabView {

    public var onDimensionsChanged:Signal2<Int, Int>;
    public var onPropertiesUpdated:Signal0 = new Signal0();
    public var onClientConnectPressed:Signal1<Connection> = new Signal1<Connection>();
    public var onServerConnectPressed:Signal1<Connection> = new Signal1<Connection>();

    private var generalTab:GeneralTab;
    private var controlTab:ControlTab;

    private var sizeLabel:Text;

    public function new(?layoutSettings:LayoutSettings, ?clientConnection:Connection, ?serverConnection:Connection) {
        super();

        width = 250;
        percentHeight = 100;

        generalTab = new GeneralTab(layoutSettings, clientConnection, serverConnection);

        generalTab.onClientConnectPressed.add(onClientConnectPressed.dispatch);
        generalTab.onServerConnectPressed.add(onServerConnectPressed.dispatch);

        onDimensionsChanged = generalTab.onDimensionsChanged;
        addChild(generalTab);
    }

    public function controlSelected(control:Control) {
        if(controlTab == null) {
            controlTab = new ControlTab(control);
            controlTab.onPropertiesUpdated.add(onPropertiesUpdated.dispatch);
            addChild(controlTab); 
        }
        controlTab.setControl(control);
        selectedIndex = 1;
    }

    public function controlUpdated(control:Control) {
        controlTab.setControl(control);    
    }

    public function controlDeselected(control:Control) {
        selectedIndex = 0;
        removeTab(1);
        controlTab = null;
    }
}