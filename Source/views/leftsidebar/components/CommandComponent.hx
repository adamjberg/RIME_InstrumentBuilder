package views.leftsidebar.components;

import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.controls.TextInput;
import haxe.ui.toolkit.events.UIEvent;
import models.Command;
import msignal.Signal.Signal1;
import views.controls.LabelledTextInput;
import views.leftsidebar.components.SidebarComponent;

class CommandComponent extends SidebarComponent {

    private static inline var TITLE:String = "Command";

    public var onDeleteButtonPressed:Signal1<CommandComponent> = new Signal1<CommandComponent>();

    private var command:Command;

    private var titleHBox:HBox;

    private var deleteButton:Button;
    private var addressPatternInput:LabelledTextInput;
    private var valuesHBox:HBox;
    private var valuesLabel:Text;
    private var removeValueButton:Button;
    private var addValueButton:Button;
    private var valueInputs:Array<TextInput>;

    public function new(?command:Command) {
        super(TITLE);

        removeChild(titleLabel, false);
        titleHBox = new HBox();
        titleHBox.percentWidth = 100;

        titleLabel.percentWidth = 100;

        deleteButton = new Button();
        deleteButton.text = "X";
        deleteButton.onClick = function(e:UIEvent) {
            onDeleteButtonPressed.dispatch(this);
        };

        titleHBox.addChild(titleLabel);
        titleHBox.addChild(deleteButton);

        addChild(titleHBox);

        this.command = command;
        valueInputs = new Array<TextInput>();

        addressPatternInput = new LabelledTextInput("Address Pattern");
        addressPatternInput.setText(command.addressPattern);
        addressPatternInput.addEventListener(UIEvent.CHANGE, inputChanged);
        addChild(addressPatternInput);

        valuesHBox = new HBox();
        valuesHBox.percentWidth = 100;

        valuesLabel = new Text();
        valuesLabel.text = "Values";
        valuesHBox.addChild(valuesLabel);

        removeValueButton = new Button();
        removeValueButton.text = "-";
        removeValueButton.onClick = removeValueButtonPressed;
        valuesHBox.addChild(removeValueButton);

        addValueButton = new Button();
        addValueButton.text = "+";
        addValueButton.onClick = addValueButtonPressed;
        valuesHBox.addChild(addValueButton);

        addChild(valuesHBox);

        for(value in command.values) {
            addValueInput(value);
        }
    }

    private function addValueButtonPressed(e:UIEvent) {
        addValueInput("");
    }

    private function removeValueButtonPressed(e:UIEvent) {
        removeValueInput();
    }

    private function addValueInput(value:String) {
        var valueInput:TextInput = new TextInput();
        valueInput.percentWidth = 100;
        valueInput.text = value;
        valueInput.addEventListener(UIEvent.CHANGE, inputChanged);
        addChild(valueInput);
        valueInputs.push(valueInput);
    }

    private function removeValueInput() {
        if(valueInputs.length > 1) {
            var valueInputToRemove:TextInput = valueInputs.pop();
            removeChild(valueInputToRemove);
        }
    }

    private function inputChanged(e:UIEvent) {
        if(command == null) {
            return;
        }

        command.addressPattern = addressPatternInput.getText();

        for(i in 0...valueInputs.length) {
            var valueString:String = valueInputs[i].text;
            var valueFloat:Dynamic = Std.parseFloat(valueString);
        
            if(Math.isNaN(valueFloat) == false) {
                command.values[i] = valueFloat;
            }
            else {
                command.values[i] = valueString;
            }
        }
    }
}