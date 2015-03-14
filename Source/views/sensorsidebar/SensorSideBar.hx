package views.sensorsidebar;

import haxe.ui.toolkit.containers.ListView;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.core.renderers.ComponentItemRenderer;
import models.sensors.Sensor;

class SensorSideBar extends VBox {

    public var sensors:Array<Sensor>;

    public var sensorScrollList:ListView;

    public function new(?sensors:Array<Sensor>) {
        super();

        this.sensors = sensors;

        width = 250;
        percentHeight = 100;

        sensorScrollList = new ListView();
        sensorScrollList.itemRenderer = ComponentItemRenderer;
        
        sensorScrollList.percentWidth = 100;
        sensorScrollList.percentHeight = 100;

        for(sensor in sensors)
        {
            sensorScrollList.dataSource.add(
            {
                text: sensor.name,
                divider: true
            });
            for(component in sensor.components) {
                sensorScrollList.dataSource.add(
                {
                    text: component.name + ": " + component.value
                });
            }
        }
        
        addChild(sensorScrollList);
    }
}