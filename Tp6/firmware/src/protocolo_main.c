#include <stdio.h>
#include <string.h>
#include "xparameters.h"
#include "xil_cache.h"
#include "xgpio.h"
#include "platform.h"
#include "xuartlite.h"
#include "microblaze_sleep.h"

#define PORT_IN         XPAR_AXI_GPIO_0_DEVICE_ID //XPAR_GPIO_0_DEVICE_ID
#define PORT_OUT        XPAR_AXI_GPIO_0_DEVICE_ID //XPAR_GPIO_0_DEVICE_ID

//Device_ID Operaciones
#define d_READ 0
#define d_WRITE 0x01

/*Trama structure*/
#define NDATA 3
#define FRAME_INIT  0x05               		// (00000101)
#define FRAME_HEAD_L  3
#define FRAME_END  0x02				   		// (00000010)
#define FRAME_SIZE(frame) (frame & 0x0F)
#define FRAME_MAX_L 8

/*Defino máscaras para cambiar el bit del determinado LED*/
/*para hacer and bitwise con current copy of discrete register*/
/*DiscreRead*/

//Cambiar el hw_vio con colores iguales
#define LED0_B 	0x00000001
#define LED0_G 	0x00000002
#define LED0_R 	0x00000004

#define LED1_B 	0x00000008
#define LED1_G 	0x00000010
#define LED1_R 	0x00000020

#define LED2_B 	0x00000040
#define LED2_G 	0x00000080
#define LED2_R 	0x00000100

#define LED3_B 	0x00000200
#define LED3_G 	0x00000400
#define LED3_R 	0x00000800

#define SW0 0x00000001
#define SW1	0x00000002
#define SW2	0x00000004
#define SW3	0x00000008

#define R0 ('0'&'R' )



XGpio GpioOutput;
XGpio GpioParameter;
XGpio GpioInput;
u32 GPO_Value=0x00000000;
u32 GPO_Param=0x00000000;
XUartLite uart_module;

unsigned char receiveFrame (unsigned char *frame);



int main()
{


    unsigned char  frame[FRAME_MAX_L];
    unsigned char LED_ID;

    init_platform();

    /*      GPIO / UART Init*/

    XUartLite_Initialize(&uart_module, 0);

	if(XGpio_Initialize(&GpioInput, PORT_IN)!=XST_SUCCESS){
        return XST_FAILURE;
    }

	if(XGpio_Initialize(&GpioOutput, PORT_OUT)!=XST_SUCCESS){
		return XST_FAILURE;
	}
	XGpio_SetDataDirection(&GpioOutput, 1, 0x00000000);
	XGpio_SetDataDirection(&GpioInput, 1, 0xFFFFFFFF);




	while(1){

        if (receiveFrame(frame))
	    	{

        		if (*(frame + FRAME_HEAD_L) == d_WRITE){  //Check device (mode)

        			LED_ID = *(frame + FRAME_HEAD_L+1) & *(frame + FRAME_HEAD_L+2);

        			/*Ecendido de LEDs*/
        			if (*(frame + FRAME_HEAD_L+3)) // ESTADO DEL LED
        				// XGpio_DiscreteWrite(&GpioOutput,1, (u32) 0x00000249);
        			switch(LED_ID){

        			case (R0):
        				XGpio_DiscreteWrite(&GpioOutput,1, (u32)  LED0_G | XGpio_DiscreteRead(&GpioOutput, 1));

        			default:
        				XGpio_DiscreteWrite(&GpioOutput,1, (u32)  LED0_R | XGpio_DiscreteRead(&GpioOutput, 1));

        			}


        			else{

        				/*Apagado de LEDs*/

        			}


        		}


        		else {
        			//XGpio_DiscreteWrite(&GpioOutput,1, (u32)  LED0_B | XGpio_DiscreteRead(&GpioOutput, 1));
        			XGpio_DiscreteWrite(&GpioOutput,1, (u32) 0x00000249);
        			//LER PUERTOS

        		}
		   }
        else
        	//XGpio_DiscreteWrite(&GpioOutput,1, (u32) 0x00000249);
        	XGpio_DiscreteWrite(&GpioOutput,1, (u32)  LED1_G | XGpio_DiscreteRead(&GpioOutput, 1));

        }

	cleanup_platform();
	return 0;
}


unsigned char receiveFrame(unsigned char *frame)
{
	*frame=0;
	 /*Check INIT Frame */
	   /* if (read(stdin, frame,1) && ( ( ( (*frame) >> 5) & 0x7 ) == FRAME_INIT )) {

	    	//LEO LOS 3 bits restantes de la cabecera
	        //Si es trama corta, leo el size y leo esas misma cantidad de bytes
	        read(stdin,(frame+1),FRAME_HEAD_L - 1);


	        if ( (*frame >> 4) & 1 == 0 ){       //Short frame

	            read(stdin, (frame + FRAME_HEAD_L), (FRAME_SIZE(*frame)));

	            if ( read(stdin, (frame + FRAME_HEAD_L + (FRAME_SIZE(*frame))),1) && \
	                    *(frame + FRAME_HEAD_L + (FRAME_SIZE(*frame))+1) >> 5 & 7 == FRAME_END)
	            	return 1;

	        }

	    }*/
	if (read(stdin, frame,FRAME_MAX_L) && (  ( ((*frame)>> 5)& 0x7 )   == FRAME_INIT))
	// if (read(stdin, frame,1) && ( ( ( (*frame) >> 5) & 0x7 ) == FRAME_INIT ))
		return 1;

	    return 0;

}


