"""
Programa para enviar y recibir datos codificados segun la trama implementanda 
en tp2 

Poner esto en README: 
Cabecera (4) 

    Byte 1 : Init 3'b - Type 1'b - Size 4'b
    Byte 2 
    Byte 3 
    Byte 4 : device (Write or Read en este caso) 

data (2**16)


Cola (1) 
    
    Byte 1 : End 3'b - Type 1'b - Size 4'b
"""

import serial 
import sys
def main(): 
    
   # portName=sys.argv[1] if len(sys.argv)>1 else "dev/ttyVPA" 
   # print(portName) 
   # ser = serial.Serial( 
   #         port = portName, 
   #         baudrate=115200, 
   #         parity=serial.PARITY_NONE, 
   #         stopbits= serial.STOPBITS_ONE, 
   #         bytesize= serial.EIGHTBITS) 

   # if ser.isOpen() == False: raise ValueError('El puerto no se pudo abrir')

    
    print("1- Prender LEDs: \n" ) 
    print("\t < {0 1 2 3} >< {R G B} ><  {1 0}  >")
    print("\t <  LEDs ID  ><  COLOR  ><  On/Off >")
    
    print('\n2- Para leer estado de los switch enviar:\n')
    print('\t$ <switch ID>')
    print('\t$ <[0 1 2 3]>')
    
    print('\n3- Q para terminar \n')


    while 1: 

        data = input("\n Ingrese un comando: ")  
        
        if data.upper() == 'Q': 
            #ser.close() 
            exit('Programa finalizado \n')

        if len(data)==3: 
            trama=TramaEnconder(data,1) #device = 1 : Write GPIO  
            print(trama) 

        elif len(data)==1: 
           trama=TramaEnconder(data,0) 
           print(trama) 


def TramaEnconder(data,device):                                                  
                                                                                
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
        trama.append(byte)                                                      
                                                                                
    trama.append(fin_trama)                                                     
    return trama






















if __name__ == "__main__":
    main()

