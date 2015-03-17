import socket
import time
import struct

UDP_IP = "127.0.0.1"

UDP_PORT = 13000

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind((UDP_IP, UDP_PORT))
sock.settimeout(1)

addrPattern = "/slider1" + chr(0) + chr(0) + chr(0)
typeTag = ",f" + chr(0) + chr(0)
f = struct.pack("f", 50)
response_times = []

while True:
    sock.sendto(addrPattern + typeTag + f, (UDP_IP, 12000))
    startTime = time.time()
    try:
        data, addr = sock.recvfrom(1024)
        response_times.append(time.time() - startTime)
    except socket.error:
        avg = 0
        for rTime in response_times:
            avg += rTime
        if len(response_times) > 0:
            print "timeout avg response time: ", avg / len(response_times)
            print "num sent ", len(response_times)
            break