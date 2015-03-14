package views.leftsidebar.tabs;

import haxe.ui.toolkit.containers.ScrollView;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Divider;
import views.leftsidebar.components.SidebarComponent;

class Tab extends ScrollView {

    public var vBox:VBox;

    public function new(?name:String) {
        super();

        text = name;
        percentWidth = 100;
        percentHeight = 100;

        style.borderSize = 0;

        vBox = new VBox();
        vBox.percentWidth = 100;

        // Hacky way to get clicks to detect for scroll
        vBox.style.backgroundColor = 0xFFFFFF;
        vBox.style.backgroundAlpha = 0;
        addChild(vBox);
    }

    public function addComponent(component:SidebarComponent) {
        vBox.addChild(component);
    }

    public function removeComponent(component:SidebarComponent) {
        vBox.removeChild(component);
    }
}