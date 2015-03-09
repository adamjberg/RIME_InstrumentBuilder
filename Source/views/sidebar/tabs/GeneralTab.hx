package views.sidebar.tabs;

import views.sidebar.components.ConnectionSetupComponent;
import views.sidebar.components.Layout;
import views.sidebar.components.SidebarComponent;

class GeneralTab extends Tab {

    private var layoutComponent:Layout;
    private var clientConnectionSetup:ConnectionSetupComponent;
    private var serverConnectionSetup:ConnectionSetupComponent;

    public function new() {
        super("General");

        layoutComponent = new Layout();
        addComponent(layoutComponent);

        clientConnectionSetup = new ConnectionSetupComponent("Client Connection Setup");
        addComponent(clientConnectionSetup);

        serverConnectionSetup = new ConnectionSetupComponent("Server Connection Setup");
        addComponent(serverConnectionSetup);
    }
}