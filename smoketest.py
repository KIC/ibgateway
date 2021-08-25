from ib_insync import *
util.logToConsole('DEBUG')
ib = IB()
ib.connect('127.0.0.1', 4002)
print(ib.positions())
ib.disconnect()

