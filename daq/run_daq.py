import os
import sys
import time

import datetime
import json
from logging import getLogger, StreamHandler, INFO
import os

from sitcpy.rbcp       import RbcpBusError, RbcpTimeout, Rbcp, RbcpError
import daq

from time import sleep

board_ip="192.168.10.16"

rbcp = Rbcp(board_ip)

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
    data = rbcp.read(0x08,8)
    print(data)

## DAQ start...
readTestBits()
sendReset()
startDAQ()
sleep(1)
############################################################
#
#  Actual DAQ will be implemented here...
#
############################################################
stopDAQ()
sendReset()
readTestBits()
