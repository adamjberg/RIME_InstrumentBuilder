package views.sidebar;

import haxe.ui.toolkit.containers.TabView;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Text;
import openfl.events.Event;
import views.instrument.controls.IControl;
import views.sidebar.tabs.*;

class SideBar extends TabView {

    private var generalTab:GeneralTab;
    private var controlTab:ControlTab;

    private var sizeLabel:Text;

    public function new() {
        super();
        width = 200;
        percentHeight = 100;

        generalTab = new GeneralTab();
        addChild(generalTab);

        controlTab = new ControlTab();
    }

    public function controlSelected(control:IControl) {
        if(contains(controlTab) == false) {
            addChild(controlTab); 
        }
        selectedIndex = 1;
    }

    public function controlDeselected(control:IControl) {
        selectedIndex = 0;
        removeTab(1);
    }
}