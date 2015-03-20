package views.instrument.controls;

import models.ControlProperties;
import msignal.Signal.Signal1;

interface IControl {
    public var onValueChanged(get, null):Signal1<IControl>;
    public var properties(get, set):ControlProperties;
    public function update():Void;
    public function getValue():Float;
}