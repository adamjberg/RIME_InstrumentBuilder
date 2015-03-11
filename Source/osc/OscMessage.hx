package osc;

import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import haxe.io.BytesInput;
import openfl.utils.ByteArray;

class OscMessage {

    private static inline var ZERO_BYTE:Int = 0x0;
    private static inline var COMMA:Int = 0x2c;

    private static inline var OSC_STRING_BYTE_MOD:Int = 4;
    private static inline var DEFAULT_ADDR_PATTERN:String = "rime";

    public var addressPattern:String;
    public var arguments:Array<Dynamic>;
    public var typeTag:String;
    
    private var argumentsByteArray:ByteArray;
    
    public function new(?addrPattern:String)
    {
        if(addrPattern == null)
        {
            addrPattern = DEFAULT_ADDR_PATTERN;
        }
        if(addrPattern.charAt(0) != "/") {
            addressPattern = "/" + addrPattern;
        } else {
            addressPattern = addrPattern;
        }
        clear();
    }

    public function clear()
    {
        typeTag = ",";
        arguments = new Array<Dynamic>();
        argumentsByteArray = new ByteArray();
    }

    public static function fromBytes(bytes:Bytes):OscMessage
    {
        var message = new OscMessage();
        var bytesInput = new BytesInput(bytes);
        bytesInput.bigEndian = true;

        if(message.parseAddrPattern(bytesInput) == false) {
            trace("null add ");
            return null;
        }
        if(message.parseTypeTag(bytesInput) == false) {
            trace("null type " + message.addressPattern);
            return null;
        }
        if(message.parseArguments(bytesInput) == false) {
            trace("null args");
            return null;
        }

        return message;
    }

    public function parseAddrPattern(bytes:BytesInput):Bool
    {
        addressPattern = readStringFromBytesInput(bytes);
        return addressPattern.length > 0;
    }

    public function parseTypeTag(bytes:BytesInput):Bool
    {
        typeTag = readStringFromBytesInput(bytes);
        return typeTag.length > 0;
    }

    /*
     * TODO: This is still missing some types
     * It also should add the values to the argumentsByteArray
     * in order to make it a fully replayable message.
     */ 
    public function parseArguments(bytes:BytesInput):Bool
    {
        arguments = new Array<Dynamic>();

        for(i in 0...typeTag.length)
        {
            switch(typeTag.charCodeAt(i))
            {
                case(0x69): // i
                    arguments.push(bytes.readInt32());
                case (0x66): // float f
                    arguments.push(bytes.readFloat());
                case (0x53): // Symbol S
                case (0x73): // String s
                    arguments.push(readStringFromBytesInput(bytes));
            }
        }
        return true;
    }

    private function readStringFromBytesInput(bytes:BytesInput):String
    {
        var retString:String = "";
        var stringLength:Int = 0;
        var startPos:Int = bytes.position;
        for (i in startPos...bytes.length)
        {
            if (bytes.readByte() == ZERO_BYTE)
            {
                bytes.position = startPos;
                retString = bytes.readString(stringLength);

                // Advance the position to the next valid piece
                bytes.position += getNumNulsToAdd(retString.length);
                break;
            }
            stringLength++;
        }
        return retString;
    }

    public function getBytes():ByteArray
    {
        var byteArray:ByteArray = new ByteArray();

        addStringToByteArray(byteArray, addressPattern);
        addStringToByteArray(byteArray, typeTag);
        byteArray.writeBytes(argumentsByteArray, 0, argumentsByteArray.length);

        return byteArray;
    }

    private function addStringToByteArray(byteArray:ByteArray, stringToAdd:String)
    {
        var stringByteArray:ByteArray = stringToByteArray(stringToAdd);
        byteArray.writeBytes(stringByteArray, 0, stringByteArray.length);
    }

    private function stringToByteArray(stringToConvert:String):ByteArray
    {  
        var byteArray:ByteArray = new ByteArray();
        byteArray.writeUTFBytes(stringToConvert);
        padToMultipleOf4Bytes(byteArray);
        return byteArray;
    }

    private function getNumNulsToAdd(length:Int)
    {
        return OSC_STRING_BYTE_MOD - (length % OSC_STRING_BYTE_MOD);
    }

    private function padToMultipleOf4Bytes(byteArray:ByteArray)
    {
        byteArray.writeByte(ZERO_BYTE);

        var numNullsToAdd:Int = getNumNulsToAdd(byteArray.length);

        if(numNullsToAdd == OSC_STRING_BYTE_MOD)
        {
            return;
        }

        for(i in 0...numNullsToAdd)
        {
            byteArray.writeByte(ZERO_BYTE);
        }
    }

    public function addInt(val:Int)
    {
        typeTag += 'i';
        arguments.push(val);
        argumentsByteArray.writeInt(val);
    }

    public function addFloat(val:Float)
    {
        typeTag += 'f';
        arguments.push(val);
        argumentsByteArray.writeFloat(val);
    }

    public function addDouble(val:Float)
    {
        typeTag += 'd';
        arguments.push(val);
        argumentsByteArray.writeDouble(val);
    }

    public function addString(val:String)
    {
        typeTag += 's';
        arguments.push(val);
        addStringToByteArray(argumentsByteArray, val);
    }

    public function addBool(val:Bool)
    {
        if(val)
            typeTag += 'T';
        else
            typeTag += 'F';
    }

    public function addMidi(channel:Int, status:Int, val1:Int, val2:Int)
    {
        typeTag += 'm';
        argumentsByteArray.writeByte(channel);
        argumentsByteArray.writeByte(status);
        argumentsByteArray.writeByte(val1);
        argumentsByteArray.writeByte(val2);
    }
}