import time
import serial


ser = serial.Serial(
    port='/dev/ttyUSB5',	#Configurar con el puerto
    baudrate=115200,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    bytesize=serial.EIGHTBITS
)

ser.isOpen()
ser.timeout=None
print(ser.timeout)

print ('Ingrese un comando:[0,1,2,3]\r\n')

while 1 :
    inputData = input("<< ")
    if inputData == 'exit':
        ser.close()
        exit()
    elif(inputData == '3'):
        print ("Waiting Input Data")
        ser.write(inputData.encode())
        time.sleep(2)
        readData =ser.read(1)
        out = bin(int.from_bytes(readData,byteorder='big'))[2:].zfill(4)
        #print(ser.inWaiting())
        if out != '':
            print (">> " + out)
    else:
        print ("Sending Order")
        ser.write(inputData.encode())
        time.sleep(1)
