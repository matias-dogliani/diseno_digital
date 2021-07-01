import serial                                                                   
                       
#En realidad esto se tendría que hcer en cada iteración con un data nuevo 
def Short_TramaEnconder(data):
                                                                                
    trama = [] 

    if len(data) >16:                                                     
        return -1                                                               
                                                                                
    cabecera =  bytes([160 + len(data)]) 
    fin_trama = bytes([64 + len(data)])                                                               
    trama.append(cabecera)                                                      
  
    #LSize_low y LSize_high
    trama.append(bytes([0]))
    trama.append(bytes([0]))
   
    trama.append(bytes([0]))                                                                            
  
    for byte in data:                                                           
        trama.append(byte)  
    
    trama.append(fin_trama)                                                     
    return trama      

def Large_TramaEnconder(data,len_data = 0 ):                                                  
                                                                                
    trama = [] 
    if len_data == 0: 
        len_data = len(data)  # Esto es para poder mandar graficar por esta trama

    if len(data) > 2**(16):                                                     
        return -1                                                               
                                                                                
    cabecera =  bytes([176]) 
    fin_trama = bytes([64])                                                               
    trama.append(cabecera)                                                      
  
    #LSize_low y LSize_high
    trama.append(bytes([len_data // 255 ])) 
    trama.append(bytes([len_data - (len_data // 255) * 255 ]))
    trama.append(bytes([0]))                                                                            
  
    for byte in data:                                                           
        trama.append(byte)  
    
    trama.append(fin_trama)                                                     
    
    return trama      


ser = serial.serial_for_url('loop://', timeout=1)                               
                                                                    
ser.timeout=None                                                                
ser.flushInput()                                                                
ser.flushOutput() 

import random 

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

        
datos = [] 
for char in data: 
    datos.append(char.encode()) 

if data.upper() == 'GRAFICAR':
    for i in range(10): 
        dato_graficar = random.randint(0,255) #Vector a graficar 
        byte = dato_graficar.to_bytes(1, byteorder='big', signed=False)
        datos.append(byte) 
    trama = Large_TramaEnconder(datos, len(data))
if data.upper() == 'CALCULADORA': 
    trama = Short_TramaEnconder(datos) 
if data.upper() == 'SALIR': 
    trama = Short_TramaEnconder(datos) 
print(trama)
print("Enviando",len(trama), "datos") 
for byte in trama:
    ser.write(byte) 
    print("Enviando", byte) 

#if ser.isOpen(): 
#    for byte in trama:  
#       print("Enviado ",  byte)  
#       ser.write(byte)
#       out = [] 
#       print("Esperando ", ser.inWaiting())  
#       while ser.inWaiting() > 0:
#            read_data = ser.read(1)
#            print("Recibido ", read_data)
#            out.append(read_data) 
#

out = [] 
if ser.isOpen():
    print("Esperando", ser.inWaiting(), "datos") 
    while ser.inWaiting() > 0:
         read_data = ser.read(1)
         print("Recibido ", read_data)
         out.append(read_data) 

fin_trama =  int.from_bytes(out[len(out)-1],byteorder='big',signed = False)  


cabecera = int.from_bytes(out[0], byteorder = 'big', signed = False) 


if (cabecera & int(b'00010000')):           #Trama Larga 
    data_len = int.from_bytes(out[1], byteorder = 'big', signed = False) 
    data_len = data_len * 255 +  int.from_bytes(out[2],         #Largo del comando para el caso de 
                byteorder = 'big', signed = False)              # 'graficar'

    if fin_trama  != 64: 
        print("ERROR: Trama corrupta") 
    if( data_len < len(out[4:-1]) ) :   #El caso de graficar 
         comando = [char.decode() for char in out[4:4+data_len] ]
         comando = "".join(comando) 
    else: 
        dato = out[4:-1] 

else:                               #Trama corta
    data_len  = cabecera - 160
    comando = [char.decode() for char in out[4:4+data_len] ]
    comando = "".join(comando) 
   

print(comando) 
if comando.upper() == 'CALCULADORA' : 
    print("calculadora") 
elif comando.upper() == "GRAFICAR": 
    puntos = [int.from_bytes(byte, byteorder = 'big', 
        signed = False) for byte in out[4+data_len:-1] ]
#    graficar(puntos)
elif comando.upper() == "SALIR": 
    if ser.isOpen():                                                            
        print("Programa terminado")                                             
        ser.close()                                                             
    exit()                                                                      
   
