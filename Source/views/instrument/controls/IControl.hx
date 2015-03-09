package views.instrument.controls;

import views.instrument.controls.ControlProperties;

interface IControl {
    public var properties(get, set):ControlProperties;
    public function update():Void;
}