package views.leftsidebar.tabs;

import models.Command;
import views.leftsidebar.components.CommandComponent;

class CommandsTab extends Tab {

    public var commands:Array<Command>;

    public function new(?commands:Array<Command>) {
        super("Commands");
        this.commands = commands;

        var commandComponent:CommandComponent;
        for(command in commands) {
            commandComponent = new CommandComponent(command);
            addComponent(commandComponent);
            commandComponent.onDeleteButtonPressed.add(removeCommandComponent);
        }
    }

    private function removeCommandComponent(commandComponent:CommandComponent) {
        removeComponent(commandComponent);
    }
}