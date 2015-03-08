package views.controls;

import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.controls.TextInput;

class LabelledTextInput extends HBox {

    public var label:Text;
    public var input:TextInput;

    public function new(?labelString:String)
    {
        super();
        label = new Text();
        label.text = labelString;

        input = new TextInput();
        input.verticalAlign = "center";
        input.percentWidth = 100;
        percentWidth = 100;
    }

    override private function initialize()
    {
        addChild(label);
        addChild(input);
        super.initialize();
    }

    public function setText(text:String)
    {
        input.text = text;
    }

    public function getText():String
    {
        return input.text;
    }
}