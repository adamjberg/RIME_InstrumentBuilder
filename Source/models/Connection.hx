package models;

class Connection {
    public var ipAddress:String = "127.0.0.1";
    public var port:Int = 12000;

    public static function fromDynamic(from:Dynamic):Connection {
        return new Connection(from.ipAddress, from.port);
    }

    public function new(?ipAddress:String, port:Int) {
        this.ipAddress = ipAddress;
        this.port = port;
    }
}