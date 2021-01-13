import os
import sys
import time

import sitcpy
from sitcpy.rbcp import RbcpBusError, RbcpTimeout, Rbcp, RbcpError

from time import sleep

rbcp = Rbcp("192.168.10.16")

def sendReset():
    rbcp.write(0x02,'1')
    sleep(0.01)
    rbcp.write(0x02,'0')

def startDAQ():
    rbcp.write(0x01,'1')

def stopDAQ():
    rbcp.write(0x01,'0')

def readTestBits():
    data = rbcp.read(0x00,8)
    print(data)
    rbcp.write(0x00,b'\x07') # test run mode
    data = rbcp.read(0x00,8)
    print(data)
    data = rbcp.read(0x08,8)
    print(data)

def maskTest():
    rbcp.write(0x10,b'\xFFFFFFFFFFFFFFFE')
    rbcp.write(0x18,b'\xFFFF')

def readSpillCount():
    data = rbcp.read(0x04,4)
    print('Spill# = ',data)

## DAQ start...
readTestBits()
maskTest()
sendReset()
startDAQ()
for i in range(20):
    readSpillCount()
    sleep(1.3)
stopDAQ()
readSpillCount()
sendReset()
readTestBits()
