package views.sidebar.tabs;

import models.Connection;
import models.LayoutSettings;
import msignal.Signal.Signal2;
import views.sidebar.components.ConnectionSetupComponent;
import views.sidebar.components.LayoutSidebarComponent;
import views.sidebar.components.SidebarComponent;

class GeneralTab extends Tab {

    public var onDimensionsChanged:Signal2<Int, Int>;

    private var layoutComponent:LayoutSidebarComponent;
    private var clientConnectionSetup:ConnectionSetupComponent;
    private var serverConnectionSetup:ConnectionSetupComponent;

    public function new(?layoutSettings:LayoutSettings, ?clientConnection:Connection, ?serverConnection:Connection) {
        super("General");

        layoutComponent = new LayoutSidebarComponent(layoutSettings);
        onDimensionsChanged = layoutComponent.onDimensionsChanged;
        addComponent(layoutComponent);

        clientConnectionSetup = new ConnectionSetupComponent("Client Connection Setup", clientConnection);
        addComponent(clientConnectionSetup);

        serverConnectionSetup = new ConnectionSetupComponent("Server Connection Setup", serverConnection);
        addComponent(serverConnectionSetup);
    }
}