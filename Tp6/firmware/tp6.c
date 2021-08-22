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
#define d_READ 1                                                                
#define d_WRITE 0                                                               
                                                                                
/*Trama structure*/                                                             
#define HEAD 4                                                                  
#define INIT 0x05                                                               
#define FRAMETAIL 0x02                                                          
#define GET_INIT(data)  ((data >> 5) & 0x7)                                     
#define GET_TYPE(data)  ((data >> 4) & 0x1)                                     
#define GET_SSIZE(data) ((data >> 0) & 0xF)                                     
#define GET_TAIL(data)  ((data >> 5) & 0x7)                                     
                                                                                
XGpio GpioOutput;                                                               
XGpio GpioParameter;                                                            
XGpio GpioInput;                                                                
u32 GPO_Value;                                                                  
u32 GPO_Param;                                                                  
XUartLite uart_module;                                                          
                                                                                
unsigned char rx_trama (unsigned char *dataFrame);   



int main()
{
	GPO_Value=0x00000000;
	GPO_Param=0x00000000;
	
    init_platform();
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
			data   = frame + HEADLENGTH;
			device = frame + HEADLENGTH - 1;

			/* Write leds */
			if (*device)
               XGpio_DiscreteWrite(&GpioOutput,1, (u32) 0x00000249);
          
            else{
               datos="err";  
               while(XUartLite_IsSending(&uart_module)){}
               XUartLite_Send(&uart_module, &(datos),3);
            } 
                
		   }
        
        else{
            datos="env";  
            while(XUartLite_IsSending(&uart_module)){}
            XUartLite_Send(&uart_module, &(datos),3);
              } 
   
        }

	cleanup_platform();
	return 0;
}


unsigned char receiveFrame(unsigned char *frame)
{
	/* Reads a byte, check if a frame init and if it is, read all head */
	if (read(stdin,frame, 1 ) && (GET_INIT(*frame) == FRAMEINIT) && \
			(read(stdin, (frame + 1), HEADLENGTH - 1) == HEADLENGTH -1))
	{
		/* Short frame */
		if (!GET_TYPE(*frame))
		{
			/* Read data and tail fields and then, check tail */
			if ((read(stdin, (frame + HEADLENGTH), GET_SSIZE(*frame) + 1) == GET_SSIZE(*frame) + 1) && \
					(GET_TAIL(*(frame + HEADLENGTH + GET_SSIZE(*frame))) == FRAMETAIL))
			{
				return 1;
			}
		}
		/* Long frame */
		/* Long frame is not suported */
	}

	return 0;
}


