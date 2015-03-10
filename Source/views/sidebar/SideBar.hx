package views.sidebar;

import haxe.ui.toolkit.containers.TabView;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Text;
import models.Connection;
import models.LayoutSettings;
import msignal.Signal.Signal2;
import openfl.events.Event;
import views.instrument.controls.IControl;
import views.sidebar.tabs.*;

class SideBar extends TabView {

    public var onDimensionsChanged:Signal2<Int, Int>;

    private var generalTab:GeneralTab;
    private var controlTab:ControlTab;

    private var sizeLabel:Text;

    public function new(?layoutSettings:LayoutSettings, ?clientConnection:Connection, ?serverConnection:Connection) {
        super();
        width = 250;
        percentHeight = 100;

        generalTab = new GeneralTab(layoutSettings, clientConnection, serverConnection);
        onDimensionsChanged = generalTab.onDimensionsChanged;
        addChild(generalTab);
    }

    public function controlSelected(control:IControl) {
        if(controlTab == null) {
            controlTab = new ControlTab();
            addChild(controlTab); 
        }
        controlTab.setControl(control);
        selectedIndex = 1;
    }

    public function controlUpdated(control:IControl) {
        controlTab.setControl(control);    
    }

    public function controlDeselected(control:IControl) {
        selectedIndex = 0;
        removeTab(1);
        controlTab = null;
    }
}