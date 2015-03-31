package views.leftsidebar.tabs;

import models.Connection;
import models.LayoutSettings;
import msignal.Signal.Signal0;
import msignal.Signal.Signal1;
import msignal.Signal.Signal2;
import views.leftsidebar.components.ConnectionSetupComponent;
import views.leftsidebar.components.LayoutSidebarComponent;
import views.leftsidebar.components.SidebarComponent;

class GeneralTab extends Tab {

    public var onDimensionsChanged:Signal2<Int, Int> = new Signal2<Int, Int>();
    public var onClientSyncPressed:Signal1<Connection> = new Signal1<Connection>();
    public var onLoadPressed:Signal0 = new Signal0();
    public var onSavePressed:Signal0 = new Signal0();

    private var layoutComponent:LayoutSidebarComponent;
    private var clientConnectionSetup:ConnectionSetupComponent;

    public function new(?layoutSettings:LayoutSettings, ?clientConnection:Connection) {
        super("General");

        layoutComponent = new LayoutSidebarComponent(layoutSettings);
        layoutComponent.onDimensionsChanged.add(onDimensionsChanged.dispatch);
        layoutComponent.onSavePressed.add(onSavePressed.dispatch);
        layoutComponent.onLoadPressed.add(onLoadPressed.dispatch);
        addComponent(layoutComponent);

        clientConnectionSetup = new ConnectionSetupComponent("Device Connection Setup", clientConnection, true);
        addComponent(clientConnectionSetup);

        clientConnectionSetup.onSyncPressed.add(onClientSyncPressed.dispatch);
    }
}