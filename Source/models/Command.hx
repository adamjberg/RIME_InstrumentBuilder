package models;

class Command {
    public var addressPattern:String;
    public var values:Array<Dynamic>;

    public static function fromDynamic(from:Dynamic):Command {
        return new Command(from.addressPattern, from.values);
    }

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