package models;

class Connection {
    public var ipAddress:String = "127.0.0.1";
    public var port:Int = 12000;

    public function new(?ipAddress:String, port:Int) {
        this.ipAddress = ipAddress;
        this.port = port;
    }
}