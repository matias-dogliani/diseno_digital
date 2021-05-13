import time
import serial

#############################################
# Nota:
# Comentar esta linea si se utiliza el puerto serie
# con la FPGA
ser = serial.serial_for_url('loop://', timeout=1)

#############################################
# Nota:
# Descomentar esta linea si se utiliza el puerto serie
# con la FPGA
#############################################
# ser = serial.Serial(
#     port     = '/dev/ttyUSB1',
#     baudrate = 9600,
#     parity   = serial.PARITY_NONE,
#     stopbits = serial.STOPBITS_ONE,
#     bytesize = serial.EIGHTBITS
# )

ser.isOpen()
ser.timeout=None
ser.flushInput()
ser.flushOutput()

print('Ingrese un comando:\n')
while 1 :
    char_v = []
    data = input("ToSent: ")
    if data == 'exit':
        if ser.isOpen():
            ser.close()
        break
    else:
        # Arma el vector a transmitir
        for ptr in range(len(data)):
            char_v.append(data[ptr])

        for ptr in range(len(char_v)):
            ser.write(char_v[ptr].encode())
            #time.sleep(1)

        out = ''
        while ser.inWaiting() > 0:
            read_data = ser.read(1)
            print(read_data)
            out += read_data.decode()

        if out != '':
             print(">> " + out)
