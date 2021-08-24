# Trabajo práctico Nº 6 

Plataforma de verificación. Se utiliza un microcontrolador embebido *microblaze* en la FPGA para controlar el estado de los switch y de los LEDs RGB. Se implementa el sistema de la imagen 

![Bloques del sistema]( https://github.com/matias-dogliani/diseno_digital/blob/master/Tp6/imgs/sistema.png) 


Con la herramienta de *Block Desing* de Vivado se implementan los bloques y la conexión entre ellos para lograr el sistema, y también el bloque de *Virtual Inputs/Outputs* VIO para poder controlar los switches virtualmentes y verificar el estado de los LEDs. 

## MicroBlaze 

![Imagen de MicroBlaze](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp6/imgs/microblaze.png )


## VIO 
![Imagen de VIO]( https://github.com/matias-dogliani/diseno_digital/blob/master/Tp6/imgs/vio.png)


## Comunicación y control

* PC: [Source Python](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp6/tp6.py ) 
* MicroBlaze: [Source C]( https://github.com/matias-dogliani/diseno_digital/blob/master/Tp6/firmware/src/protocolo_main.c)

Desde la PC que en la que se encuentra conectada la FPGA por USB se envían ciertos comandos codificados en una trama, con la estructura de la tabla desde un script en *python*. 

|    Trama     |      Byte         |     Significado   |    Valor        |
|:------------:|:-----------------:|:------------------:|:--------------:|
| Cabecera     |      Byte 1       |   Init (3b)        |    101         |
| Cabecera     |      Byte 1       |   Tipo  (1b)       |    1/0         |
| Cabecear     |      Byte 1       |   Size (4b)        |  *DataSize*    |
| Cabecera     |      Byte 2       |   Size MSBits      |*Long DataSize* |
| Cabecera     |      Byte 3       |   Size LSBits      |*Long DataSize* |
| Cabecera     |      Byte 4       |   Device           |*READ/WRITE* 1/0|          
| Data         |     *N* Bytes     |   Data             |   *Data*       |
| Fin Trama    |      Byte 1       |   End (3b)         |    010         |
| Fin Trama    |      Byte 1       |   Tipo (1b)        |    1/0         |
| Fin Trama    |      Byte 1       |   Size (4b)        |  *DataSize*    |

* En *data* se envía el comando para encender o apagar el LED determinado o el número de switch que se desea conocer el estado. Para encender el LED se envía el número de LED, el color y el estado. 

```  
Ingrese un comando: 0R1
[b'\xa3', b'\x00', b'\x00', b'\x01', '0', 'R', '1', b'C']

 Ingrese un comando: 2G0
[b'\xa3', b'\x00', b'\x00', b'\x01', '2', 'G', '0', b'C']
```
* En *device* se envía el comando de escritura o lectura según corresponda que determinará que operación se realiza 

```c
#define def_READ      0
#define def_WRITE     1
```

### Encendido de LEDs 

Para encender cualquier combinación de LEDs se utilizaron dos variables de 32 bits para enmascarar el registro de GPIO y así cambiar el estado de los requeridos únicamente: 

```c 
switch(LED_ID){
    case (R0):{	GPO_Mask = GPO_Mask | LED0_R; GPO_SEL = LED0_R; break;}
    case (G0):{	GPO_Mask = GPO_Mask | LED0_G; GPO_SEL = LED0_G; break;}
    case (B0):{	GPO_Mask = GPO_Mask | LED0_B; GPO_SEL = LED0_B; break;}

    case (R1):{	GPO_Mask = GPO_Mask | LED1_R; GPO_SEL = LED1_R; break;}
	case (G1):{	GPO_Mask = GPO_Mask | LED1_G; GPO_SEL = LED1_G; break;}
    case (B1):{	GPO_Mask = GPO_Mask | LED1_B; GPO_SEL = LED1_B; break;}

    case (R2):{	GPO_Mask = GPO_Mask | LED2_R; GPO_SEL = LED2_R; break;}
    case (G2):{	GPO_Mask = GPO_Mask | LED2_G; GPO_SEL = LED2_G; break;}
    case (B2):{	GPO_Mask = GPO_Mask | LED2_B; GPO_SEL = LED2_B; break;}

    case (R3):{	GPO_Mask = GPO_Mask | LED3_R; GPO_SEL = LED3_R; break;}
    case (G3):{	GPO_Mask = GPO_Mask | LED3_G; GPO_SEL = LED3_G; break;}
    case (B3):{	GPO_Mask = GPO_Mask | LED3_B; GPO_SEL = LED3_B; break;}

    default:GPO_Mask = 0x00000000;} 

if (*(frame + FRAME_HEAD_L+3) == GPIO_HIGH)
  	XGpio_DiscreteWrite(&GpioOutput,1, (GPO_Mask));
else{
	GPO_Mask = ~GPO_SEL & GPO_Mask;
    XGpio_DiscreteWrite(&GpioOutput,1, (GPO_Mask));}
      			    
```

NOTA: Se utilzaron 2 variables de enmascarado debido a que la función DiscreteRead no parecía funcionar correctamente. 


![Encendido de LEDS - GIF](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp6/imgs/encendido_LEDs.gif )


### Estado de switches 

Mediante el script en python corriendo en la PC se envía el número de switch que se desea concer el estado, se leen los registros correspondientes y mediante el código en C de MicroBlaze se envía este valor entramado de la misma forma que en python. Luego se recibe esta trama en la PC y se realizan las correspondientes verificiones para validar la trama. 
