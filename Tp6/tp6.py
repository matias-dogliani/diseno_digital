import serial 
import sys

def main(): 
    
    portName=sys.argv[0] if len(sys.argv)>1 else "/dev/ttyUSB6" 
    print("Puerto: " , portName) 
    
    ser = serial.Serial( 
            port = portName, 
            baudrate=115200, 
            parity=serial.PARITY_NONE, 
            stopbits= serial.STOPBITS_ONE, 
            bytesize= serial.EIGHTBITS) 

    ser.timeout=None
    ser.flushInput()
    ser.flushOutput()

    if ser.isOpen() == False: raise ValueError('El puerto no se pudo abrir')

    
    print("1- Prender LEDs: \n" ) 
    print("\t < |0| |1| |2| |3| >< |R| |G| |B| ><  |1| |0|  >")
    print("\t <  LEDs NUM  ><  COLOR  ><  On/Off >")
    print('\n3- Q para terminar \n')


    while 1: 
        data = input("\n Ingrese un comando: ")  
        
        if data.upper() == 'Q': 
            ser.close() 
            exit('Programa finalizado \n')

        if len(data)==3: 
            trama=TramaEnconder(data,1) #device = 1 : Write GPIO  
            for byte in trama:
                print("Enviado ",byte)
                ser.write(byte)

        elif len(data)==1: 
           trama=TramaEnconder(data,0) 
           print(trama) 


def TramaEnconder(datos,device):                                                  
    
    
    data = []                                                                      
    for char in datos:                                                               
        data.append(char.encode()) 

    trama = []                                                                  
    if len(data) >16:   #Solo trama corta
        return -1                                                               
                                                                                
    cabecera =  bytes([160 + len(data)])                                        
    fin_trama = bytes([64 + len(data)])                                         
    trama.append(cabecera)                                                      
                                                                                
    #LSize_low y LSize_high                                                     
    trama.append(bytes([0]))                                                    
    trama.append(bytes([0]))                                                    
    trama.append(bytes([device]))                                                    
                                                                                
    for byte in data:                                                           
        trama.append(bytes(byte))                                                      
                                                                                
    trama.append(fin_trama)                                                     
    return trama






















if __name__ == "__main__":
    main()

