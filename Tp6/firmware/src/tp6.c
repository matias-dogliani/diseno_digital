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
#define FRAME_INIT = 0x05               // (00000101)  
                                                                                
XGpio GpioOutput;                                                               
XGpio GpioParameter;                                                            
XGpio GpioInput;                                                                
u32 GPO_Value=0x00000000;                                                                  
u32 GPO_Param=0x00000000;                                                                  
XUartLite uart_module;                                                          
                                                                                
unsigned char rx_trama (unsigned char *dataFrame);   



int main()
{


    unsigned char * frame; 
    unsigned char datos[3];   

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


    /*Check INIT Frame */
    if ( read(stdin, frame,1) && ((*frame >> 5) & 7 == FRAME_INIT ) ){
    
        //LEO LOS 3 bits restantes de la cabecera 
        //Si es trama corta, leo el size y leo esas misma cantidad de bytes
        read(stdin,(frame+1),FRAME_HEAD_L - 1)


        if ( (*frame >> 4) & 1 == 0 ){       //Short frame
        
            read(stdin, (frame + FRAME_HEAD_L), 3)  

            if ( read(stdin, (frame + FRAME_HEAD_L + 3),1) && \ 
                    *(frame + FRAME_HEAD_L + 3+1) >> 5 & 7 == FRAME_END) 
                return 1 
        } 
    
    }

    return 0 

}


