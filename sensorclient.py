import socket
import time
import struct
import random

UDP_IP = "127.0.0.1"

UDP_PORT = 11000

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind((UDP_IP, UDP_PORT))

addrPattern = "/sensors" + chr(0) + chr(0) + chr(0) + chr(0)
typeTag = ",fffffffffffffffffffffff" + chr(0) + chr(0) + chr(0) + chr(0)

while True:
    f = struct.pack(">fffffffffffffffffffffff", random.random(), random.random(),random.random(),random.random(),random.random(),random.random(),random.random(),random.random(),random.random(),random.random(),random.random(),random.random(),random.random(),random.random(),random.random(),random.random(),random.random(),random.random(),random.random(),random.random(),random.random(),random.random(),random.random())
    sock.sendto(addrPattern + typeTag + f, (UDP_IP, 12000))
    time.sleep(1.0)