package;

import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.Toolkit;

import openfl.display.Sprite;
import openfl.events.Event;

class Main extends Sprite {

	public function new () {
		super();
        Toolkit.init();
        Toolkit.openFullscreen(function(root:Root) {
            root.addChild(new App());
        });
	}
}