package views.instrument.controls;

import models.Control;
import msignal.Signal.Signal1;

interface IControl {
    public var onValueChanged(get, null):Signal1<IControl>;
    public var properties(get, set):Control;
    public function update():Void;
    public function getValue():Float;
}