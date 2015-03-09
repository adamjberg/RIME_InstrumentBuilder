package;

import haxe.ui.toolkit.containers.Stack;
import haxe.ui.toolkit.controls.popups.Popup;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.Toolkit;

import openfl.display.Sprite;
import openfl.events.Event;

class Main extends Sprite {

	public function new () {
		super();
        Toolkit.init();
        Toolkit.setTransitionForClass(Popup, "none");
        Toolkit.setTransitionForClass(Stack, "none");
        Toolkit.openFullscreen(function(root:Root) {
            root.addChild(new App());
        });
	}
}