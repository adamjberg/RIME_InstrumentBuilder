package views.leftsidebar.tabs;

import models.Connection;
import models.LayoutSettings;
import msignal.Signal.Signal1;
import msignal.Signal.Signal2;
import views.leftsidebar.components.ConnectionSetupComponent;
import views.leftsidebar.components.LayoutSidebarComponent;
import views.leftsidebar.components.SidebarComponent;

class GeneralTab extends Tab {

    public var onDimensionsChanged:Signal2<Int, Int>;
    public var onClientConnectPressed:Signal1<Connection> = new Signal1<Connection>();
    public var onServerConnectPressed:Signal1<Connection> = new Signal1<Connection>();

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

        clientConnectionSetup.onConnectPressed.add(onClientConnectPressed.dispatch);
        serverConnectionSetup.onConnectPressed.add(onServerConnectPressed.dispatch);
    }
}