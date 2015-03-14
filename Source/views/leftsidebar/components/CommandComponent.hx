package views.leftsidebar.components;

import haxe.ui.toolkit.events.UIEvent;
import models.Command;
import views.controls.LabelledTextInput;
import views.leftsidebar.components.SidebarComponent;

class CommandComponent extends SidebarComponent {

    private static inline var TITLE:String = "Command";

    private var command:Command;

    private var addressPatternInput:LabelledTextInput;
    private var valueInput:LabelledTextInput;

    public function new() {
        super(TITLE);

        addressPatternInput = new LabelledTextInput("Address Pattern");
        addressPatternInput.addEventListener(UIEvent.CHANGE, inputChanged);
        addChild(addressPatternInput);

        valueInput = new LabelledTextInput("Value");
        valueInput.addEventListener(UIEvent.CHANGE, inputChanged);
        addChild(valueInput);
    }

    public function setCommands(commands:Array<Command>) {
        command = commands[0];
        addressPatternInput.setText(command.addressPattern);
        valueInput.setText(command.values[0]);
    }

    private function inputChanged(e:UIEvent) {
        if(command == null) {
            return;
        }

        command.addressPattern = addressPatternInput.getText();

        var valueString:String = valueInput.getText();
        var valueFloat:Dynamic = Std.parseFloat(valueString);

        if(Math.isNaN(valueFloat) == false) {
            command.values[0] = valueFloat;
        }
        else {
            command.values[0] = valueString;
        }
    }
}