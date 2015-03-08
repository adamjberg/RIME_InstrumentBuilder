package views.sidebar.tabs;

import haxe.ui.toolkit.containers.VBox;

class Tab extends VBox {

    public function new(?name:String) {
        super();

        text = name;
        percentWidth = 100;
        percentHeight = 100;
    }
}