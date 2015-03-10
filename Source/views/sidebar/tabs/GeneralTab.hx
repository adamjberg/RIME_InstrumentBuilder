package views.sidebar.tabs;

import msignal.Signal.Signal2;
import views.sidebar.components.ConnectionSetupComponent;
import views.sidebar.components.Layout;
import views.sidebar.components.SidebarComponent;

class GeneralTab extends Tab {

    public var onDimensionsChanged:Signal2<Int, Int>;

    private var layoutComponent:Layout;
    private var clientConnectionSetup:ConnectionSetupComponent;
    private var serverConnectionSetup:ConnectionSetupComponent;

    public function new() {
        super("General");

        layoutComponent = new Layout();
        onDimensionsChanged = layoutComponent.onDimensionsChanged;
        addComponent(layoutComponent);

        clientConnectionSetup = new ConnectionSetupComponent("Client Connection Setup");
        addComponent(clientConnectionSetup);

        serverConnectionSetup = new ConnectionSetupComponent("Server Connection Setup");
        addComponent(serverConnectionSetup);
    }
}