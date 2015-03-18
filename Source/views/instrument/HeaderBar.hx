package views.instrument;

import haxe.ui.toolkit.containers.MenuBar;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.events.UIEvent;
import msignal.Signal.Signal0;

class HeaderBar extends MenuBar {

    public var onConnectionSettingsButtonPressed:Signal0 = new Signal0();

    private var connectionSettingsButton:Button;

    public function new() {
        super();
        percentWidth = 100;

        connectionSettingsButton = new Button();
        connectionSettingsButton.text = "Connect";
        connectionSettingsButton.horizontalAlign = "right";
        connectionSettingsButton.verticalAlign = "center";
        addChild(connectionSettingsButton);

        connectionSettingsButton.onClick = function(e:UIEvent) {
            onConnectionSettingsButtonPressed.dispatch();
        }
    }

}