package views.sidebar;

import haxe.ui.toolkit.containers.TabView;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Text;
import openfl.events.Event;
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
        addChild(controlTab);
    }
}