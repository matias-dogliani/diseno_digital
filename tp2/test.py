import serial                                                                   
                       

def STramaEnconder(data): 

    trama = bytearray();
    cabecera = b'1010' 

  '''
  Para cabecera : 

  Hago un entero de 1010. Lo shifteo 4 a la izq 
  Hago un | con la longitud de la palabra 
  cabecera_bits = entero.to_bytes(1,byteorder = 'big', signed = False) 


  '''

def trama_encoder(data): 

    if (data.upper() == 'GRAFICAR'): 
        pass 
    else: 

        
    




ser = serial.serial_for_url('loop://', timeout=1)                               
                                                                                
ser.timeout=None                                                                
                                                                                
ser.flushInput()                                                                
ser.flushOutput() 

#Envio de datos 
comandos = ['CALCULADORA','GRAFICAR','SALIR']
data = ''

while(1):

    print("'Calculadora': Ejecuta calculadora",
        "'Graficar': Grafica un vector aleatorio",
        "'Salir': Finalizar programa",sep = '\n')
    
    data = input("Ingrese un comando: ")

    if data.upper() in comandos:
        break
    else:
        print("No existe el comando", data,"\n")


trama = trama_encoder() 

ser.write(data.encode())


