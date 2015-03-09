package views.sidebar.tabs;

import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Divider;
import views.sidebar.components.SidebarComponent;

class Tab extends VBox {

    public function new(?name:String) {
        super();

        text = name;
        percentWidth = 100;
        percentHeight = 100;
    }

   public function addComponent(component:SidebarComponent) {
        var divider = new Divider();
        addChild(divider);
        addChild(component);
    }
}