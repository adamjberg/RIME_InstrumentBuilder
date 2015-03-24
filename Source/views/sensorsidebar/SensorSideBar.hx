package views.sensorsidebar;

import haxe.ui.toolkit.containers.ListView;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.core.renderers.ComponentItemRenderer;
import models.sensors.Sensor;
import openfl.events.Event;
import openfl.events.TimerEvent;
import openfl.utils.Timer;

class SensorSideBar extends VBox {

    public var sensors:Array<Sensor>;

    public var sensorScrollList:ListView;

    private var updateTimer:Timer;

    public function new(?sensors:Array<Sensor>) {
        super();

        this.sensors = sensors;
        this.style.spacing = 0;

        percentWidth = 25;
        percentHeight = 100;

        sensorScrollList = new ListView();
        sensorScrollList.style.borderSize = 0;
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
        
        updateTimer = new Timer(250);
        updateTimer.addEventListener(TimerEvent.TIMER, update);
        updateTimer.start();
    }

    private function update(e:Event) {
        sensorScrollList.dataSource.moveFirst();
        for(sensor in sensors)
        {
            // Skip the name
            sensorScrollList.dataSource.moveNext();

            for(component in sensor.components) {
                sensorScrollList.dataSource.get().text = component.name + ": " + Std.int(component.value * 1000) / 1000;
                sensorScrollList.dataSource.moveNext();
            }
        }
        sensorScrollList.invalidate();
    }
}