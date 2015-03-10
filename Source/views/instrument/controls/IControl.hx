package views.instrument.controls;

import models.ControlProperties;

interface IControl {
    public var properties(get, set):ControlProperties;
    public function update():Void;
}