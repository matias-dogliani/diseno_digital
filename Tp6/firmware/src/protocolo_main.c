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

//GPIO Op.
#define GPIO_HIGH ((unsigned char)('1'))
#define GIIO_LOW ((unsigned char)('0'))

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


#define LED0_R 	0x00000001
#define LED0_G 	0x00000002
#define LED0_B 	0x00000004

#define LED1_R 	0x00000008
#define LED1_G 	0x00000010
#define LED1_B 	0x00000020

#define LED2_R 	0x00000040
#define LED2_G 	0x00000080
#define LED2_B 	0x00000100

#define LED3_R 	0x00000200
#define LED3_G 	0x00000400
#define LED3_B 	0x00000800

#define SW0 0x00000001
#define SW1	0x00000002
#define SW2	0x00000004
#define SW3	0x00000008

#define R0 ((unsigned char)('0'+'R' ))
#define G0 ((unsigned char)('0'+'G' ))
#define B0 ((unsigned char)('0'+'B' ))

#define R1 ((unsigned char)('1'+'R' ))
#define G1 ((unsigned char)('1'+'G' ))
#define B1 ((unsigned char)('1'+'B' ))

#define R2 ((unsigned char)('2'+'R' ))
#define G2 ((unsigned char)('2'+'G' ))
#define B2 ((unsigned char)('2'+'B' ))

#define R3 ((unsigned char)('3'+'R' ))
#define G3 ((unsigned char)('3'+'G' ))
#define B3 ((unsigned char)('3'+'B' ))

XGpio GpioOutput;
XGpio GpioParameter;
XGpio GpioInput;
//u32 GPO_Value=0x00000000;
//u32 GPO_Param=0x00000000;

XUartLite uart_module;

unsigned char receiveFrame (unsigned char *frame);



int main()
{
	u32 GPO_SEL = 0x00000000;
	u32 GPO_Mask = 0x00000000;
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

        			LED_ID = *(frame + FRAME_HEAD_L+1) + *(frame + FRAME_HEAD_L+2);

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

        				default:GPO_Mask = 0x00000000;	}

        			if (*(frame + FRAME_HEAD_L+3) == GPIO_HIGH)
        				XGpio_DiscreteWrite(&GpioOutput,1, (GPO_Mask));
        			else{
        				GPO_Mask = ~GPO_SEL & GPO_Mask;
        				XGpio_DiscreteWrite(&GpioOutput,1, (GPO_Mask));}
        			    //  XGpio_DiscreteWrite(&GpioOutput,1, (u32) 0x00000249);

        		}//endif check device


        		else {
        			//XGpio_DiscreteWrite(&GpioOutput,1, (u32)  LED0_B | XGpio_DiscreteRead(&GpioOutput, 1));
        			//XGpio_DiscreteWrite(&GpioOutput,1, (u32) 0x00000249);
        			//LER PUERTOS
        		}
		   }//endif checkframe
        else
        	//XGpio_DiscreteWrite(&GpioOutput,1, (u32) 0x00000249);
        	XGpio_DiscreteWrite(&GpioOutput,1, (u32)  LED1_R | XGpio_DiscreteRead(&GpioOutput, 1));

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


