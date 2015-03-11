package models;

class Command {
    public var addressPattern:String;
    public var values:Array<Dynamic>;

    public function new(?addressPattern:String, ?values:Array<Dynamic>) {
        if(addressPattern != null) {
            this.addressPattern = addressPattern;
        } else {
            this.addressPattern = "/";
        }

        if(values != null) {
            this.values = values;
        } else {
            this.values = new Array<Dynamic>();
        }
    }
}