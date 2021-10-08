import socket
import struct
import sys

# from https://newbedev.com/convert-little-endian-hex-string-to-ip-address-in-python
s = sys.argv[1]
addr_long = int(s, 16)
print(socket.inet_ntoa(struct.pack("<L", addr_long)))
