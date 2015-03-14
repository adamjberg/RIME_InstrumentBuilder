package views.leftsidebar.components;

import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Divider;
import haxe.ui.toolkit.controls.Text;

class SidebarComponent extends VBox {

    private var titleLabel:Text;

    public function new(?title:String) {
        super();

        var divider = new Divider();
        addChild(divider);

        titleLabel = new Text();
        titleLabel.text = title;
        addChild(titleLabel);

        percentWidth = 100;
    }
}