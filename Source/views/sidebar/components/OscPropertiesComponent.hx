package views.sidebar.components;

import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.events.UIEvent;
import views.controls.LabelledTextInput;
import views.instrument.controls.ControlProperties;
import views.instrument.controls.IControl;
import views.sidebar.components.SidebarComponent;

class OscPropertiesComponent extends SidebarComponent {

    private static inline var TITLE:String = "OSC";

    private var properties:ControlProperties;

    private var addressPatternInput:LabelledTextInput;
    private var valueRangeLabel:Text;
    private var fromInput:LabelledTextInput;
    private var toInput:LabelledTextInput;

    public function new() {
        super(TITLE);

        addressPatternInput = new LabelledTextInput("Name");
        valueRangeLabel = new Text();
        valueRangeLabel.text = "Value Range";

        var valueRangeHBox:HBox = new HBox();
        valueRangeHBox.percentWidth = 100;
        fromInput = new LabelledTextInput("From");
        fromInput.percentWidth = 50;
        toInput = new LabelledTextInput("To");
        toInput.percentWidth = 50;
        valueRangeHBox.addChild(fromInput);
        valueRangeHBox.addChild(toInput);

        addressPatternInput.addEventListener(UIEvent.CHANGE, update);
        fromInput.addEventListener(UIEvent.CHANGE, update);
        toInput.addEventListener(UIEvent.CHANGE, update);

        addChild(addressPatternInput);
        addChild(valueRangeLabel);
        addChild(valueRangeHBox);
    }

    public function setProperties(properties:ControlProperties) {
        this.properties = properties;
        addressPatternInput.setText(Std.string(properties.addressPattern));
        fromInput.setText(Std.string(properties.fromValue));
        toInput.setText(Std.string(properties.toValue));
    }

    private function update(e:UIEvent) {
        var addressPattern:String = addressPatternInput.getText();
        var fromValue:Dynamic = Std.parseInt(fromInput.getText());
        var toValue:Dynamic = Std.parseInt(toInput.getText());

        properties.addressPattern = addressPattern;

        if(fromValue != null) {
            properties.fromValue = fromValue;
        }
        if(toValue != null) {
            properties.toValue = toValue;
        }
    }
}