package;

import haxe.ui.toolkit.containers.Stack;
import haxe.ui.toolkit.controls.popups.Popup;
import haxe.ui.toolkit.core.Client;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.Toolkit;

import haxe.ui.toolkit.themes.GradientTheme;
import openfl.display.Sprite;
import openfl.events.Event;

class Main extends Sprite {

	public function new () {
		super();
        Toolkit.theme = new GradientTheme();
        Toolkit.init();
        Toolkit.setTransitionForClass(Popup, "none");
        Toolkit.setTransitionForClass(Stack, "none");
        Toolkit.openFullscreen(function(root:Root) {
            #if mobile
                PopupManager.instance.defaultWidth = Math.round((Client.instance.windowWidth * 0.9) / Toolkit.scaleFactor);
                root.addChild(new MobileApp());
            #else
                root.addChild(new App());
            #end
        });
	}
}