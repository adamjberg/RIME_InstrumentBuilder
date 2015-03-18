package views.leftsidebar;

import haxe.ui.toolkit.containers.TabView;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Text;
import models.Command;
import models.Connection;
import models.Control;
import models.LayoutSettings;
import msignal.Signal.Signal0;
import msignal.Signal.Signal1;
import msignal.Signal.Signal2;
import openfl.events.Event;
import views.instrument.controls.IControl;
import views.leftsidebar.tabs.*;
import views.leftsidebar.tabs.CommandsTab;

class LeftSideBar extends TabView {

    public var onDimensionsChanged:Signal2<Int, Int>;
    public var onPropertiesUpdated:Signal0 = new Signal0();
    public var onClientSyncPressed:Signal1<Connection> = new Signal1<Connection>();
    public var onLoadPressed:Signal0 = new Signal0();
    public var onSavePressed:Signal0 = new Signal0();

    private var generalTab:GeneralTab;
    private var controlTab:ControlTab;
    private var commandsTab:CommandsTab;

    private var sizeLabel:Text;

    public function new(?layoutSettings:LayoutSettings, ?clientConnection:Connection, ?serverConnection:Connection, ?commands:Array<Command>) {
        super();

        width = 250;
        percentHeight = 100;

        generalTab = new GeneralTab(layoutSettings, clientConnection, serverConnection);
        generalTab.onLoadPressed.add(onLoadPressed.dispatch);
        generalTab.onSavePressed.add(onSavePressed.dispatch);

        generalTab.onClientSyncPressed.add(onClientSyncPressed.dispatch);

        commandsTab = new CommandsTab(commands);

        onDimensionsChanged = generalTab.onDimensionsChanged;
        addChild(generalTab);
        addChild(commandsTab);
    }

    public function controlSelected(control:Control) {
        if(controlTab == null) {
            controlTab = new ControlTab(control);
            controlTab.onPropertiesUpdated.add(onPropertiesUpdated.dispatch);
            addChild(controlTab); 
        }
        controlTab.setControl(control);
        selectedIndex = 2;
    }

    public function controlUpdated(control:Control) {
        controlTab.setControl(control);    
    }

    public function controlDeselected(control:Control) {
        selectedIndex = 0;
        removeTab(2);
        controlTab = null;
    }
}