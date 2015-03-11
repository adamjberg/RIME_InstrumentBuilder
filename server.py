import socket
import time
import struct

UDP_IP = "127.0.0.1"

UDP_PORT = 11000

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind((UDP_IP, UDP_PORT))
sock.settimeout(1)

addrPattern = "/control1" + chr(0) + chr(0) + chr(0)
typeTag = ",f" + chr(0) + chr(0)
f = struct.pack("f", 50)

while True:
    sock.sendto(addrPattern + typeTag + f, (UDP_IP, 12000))
    try:
        data, addr = sock.recvfrom(1024)
        print len(data[8:])
        print struct.unpack("f", data[8:])
        print data
    except socket.error:
        print "timeout"
    time.sleep(1)