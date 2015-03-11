package views.sidebar.components;

import haxe.ui.toolkit.events.UIEvent;
import models.Command;
import views.controls.LabelledTextInput;
import views.sidebar.components.SidebarComponent;

class CommandComponent extends SidebarComponent {

    private static inline var TITLE:String = "Command";

    private var command:Command;

    private var addressPatternInput:LabelledTextInput;
    private var valueInput:LabelledTextInput;

    public function new(?command:Command) {
        super(TITLE);

        this.command = command;

        addressPatternInput = new LabelledTextInput("Address Pattern");
        addressPatternInput.setText(command.addressPattern);
        addressPatternInput.addEventListener(UIEvent.CHANGE, inputChanged);
        addChild(addressPatternInput);

        valueInput = new LabelledTextInput("Value");
        valueInput.setText(command.values[0]);
        valueInput.addEventListener(UIEvent.CHANGE, inputChanged);
        addChild(valueInput);
    }

    private function inputChanged(e:UIEvent) {
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