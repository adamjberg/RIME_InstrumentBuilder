package views.leftsidebar.tabs;

import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.events.UIEvent;
import models.Command;
import views.leftsidebar.components.CommandComponent;

class CommandsTab extends Tab {

    public var commands:Array<Command>;
    public var addButton:Button;

    public function new(?commands:Array<Command>) {
        super("Commands");
        this.commands = commands;

        addButton = new Button();
        addButton.text = "Add Command";
        addButton.horizontalAlign = "center";
        addButton.onClick = function(e:UIEvent) {
            var command:Command = new Command();
            commands.push(command);
            addCommandComponentFromCommand(command);
        }
        vBox.addChild(addButton);
        
        for(command in commands) {
            addCommandComponentFromCommand(command);
        }
    }

    private function removeCommandComponent(commandComponent:CommandComponent) {
        commands.remove(commandComponent.command);
        removeComponent(commandComponent);
    }

    private function addCommandComponentFromCommand(command:Command) {
        var commandComponent:CommandComponent = new CommandComponent(command);
        addComponent(commandComponent);
        commandComponent.onDeleteButtonPressed.add(removeCommandComponent);
    }
}