package views.sidebar.components;

import views.controls.LabelledTextInput;
import views.sidebar.components.SidebarComponent;

class ConnectionSetupComponent extends SidebarComponent {

    private var ip:LabelledTextInput;
    private var port:LabelledTextInput;

    public function new(?title:String) {
        super(title);

        ip = new LabelledTextInput("ip:");
        addChild(ip);

        port = new LabelledTextInput("port:");
        addChild(port);
    }
}