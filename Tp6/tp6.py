import serial 
import sys
import time 

def main(): 
    
    portName=sys.argv[1] if len(sys.argv)>1 else "/dev/ttyUSB1" 
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
    print("2-Verificar estado de Switch  : \n" ) 
    print("\t < |0| |1| |2| |3| >")
    print("\t <  Switch  NUM  >")
    print('\n3- Q para terminar \n')


    while 1: 
        data = input("\n Ingrese un comando: ")  
        dataIn=[]  

        if data.upper() == 'Q': 
            trama=TramaEnconder('000',1) #device = 1 : Write GPIO 32b'0 
            for byte in trama:
                ser.write(byte)
            ser.close() 
            exit('Programa finalizado \n')

        if len(data)==3: 
            trama=TramaEnconder(data,1) #device = 1 : Write GPIO  
            for byte in trama:
                #print("Enviado ",byte)
                ser.write(byte)

        elif len(data)==1: 
            trama=TramaEnconder(data,0) 
            for byte in trama:
                #print("Enviado ",byte)
                ser.write(byte)
            
            print("Esperando respuesta...")
            for i in range(6): 
                dataIn.append( ser.read() ) 
            print("Recibido",dataIn) 
            swState = TramaDecoder(dataIn) 
            print("Estado de switch [{}]: {} ".format(data,swState))    

def TramaDecoder(datos): 
    data=[]
    for byte in datos: 
        data.append(int.from_bytes(byte,byteorder='big')) 

    #Check FRAME_INIT
    if (not((data[0] >> 5) &  0x07) == 0x5 ):
        print("Trama recibida corrupta: Wrong Frame Init")
        return 
   #Check FRAME_END 
    if (not((data[-1] >> 5)& 0x07) == 0x02): 
        print ("Trama recibida corrupta: Wrong Frame Tail") 
        return 

    dataSize = int(data[0]&0x0F)
    return data[3:3+dataSize]

def TramaEnconder(datos,device):                                                  
    
    data = []                                                                      
    for char in datos:                                                               
        data.append(char.encode()) 
    print(data) 
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

