#include "xgpio.h"
#include "xparameters.h"
#include <stdio.h>

#define BTN_CHANNEL 1
#define LED_CHANNEL 2
#define SWITCH_CHANNEL 1

int main()
{
	int Status;
	XGpio button;
	XGpio led;
	XGpio switch_;

	Status = XGpio_Initialize(&button, XPAR_BUTTONS_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("Gpio Initialization Failed\r\n");
		return XST_FAILURE;
	}
	Status = XGpio_Initialize(&led, XPAR_LED_SWITCH_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("Gpio Initialization Failed\r\n");
		return XST_FAILURE;
	}
	Status = XGpio_Initialize(&switch_, XPAR_LED_SWITCH_DEVICE_ID);
		if (Status != XST_SUCCESS) {
			xil_printf("Gpio Initialization Failed\r\n");
			return XST_FAILURE;
		}

	XGpio_SetDataDirection(&button, BTN_CHANNEL, 1);
	XGpio_SetDataDirection(&led, LED_CHANNEL, 0);
	XGpio_SetDataDirection(&switch_, SWITCH_CHANNEL, 1);

	u32 isSet = 0;
	u32 intrp = 0;
	u32 count= 0;
	u32 mod_count = 0;
	u32 cmd = 0;
	u32 prevButtonState = 0;


	while(1)
	{
	    isSet = XGpio_DiscreteRead(&button, BTN_CHANNEL);
	    intrp = XGpio_DiscreteRead(&switch_, SWITCH_CHANNEL);

	    // Si les deux interrupteurs sont activés
		if((intrp & 0x0001) && (intrp & 0x0002)){
			if(cmd == 1)
				XGpio_DiscreteSet(&led, LED_CHANNEL, (0xFF << 8));
			else
				XGpio_DiscreteClear(&led, LED_CHANNEL, (0xFF << 8));

			if(count >= 100000) {
				cmd = 1 - cmd;
				count = 0;
			}
			count++;

			if(isSet == 4)
				XGpio_DiscreteSet(&led, LED_CHANNEL, 0xF0);
			if(isSet == 1)
				XGpio_DiscreteClear(&led, LED_CHANNEL, 0xF0);

			if((prevButtonState == 0) && (isSet == 2)){     // detecter le front montant
				        	XGpio_DiscreteClear(&led, LED_CHANNEL, 0x000F);
							XGpio_DiscreteSet(&led, LED_CHANNEL, mod_count%16);
							mod_count ++;

			}
			prevButtonState = isSet;
		}

	    // Si seul le premier interrupteur est activé
		else if(intrp & 0x0001){
	        if(cmd == 1)
	            XGpio_DiscreteSet(&led, LED_CHANNEL, 0xFF00);
	        else
	            XGpio_DiscreteClear(&led, LED_CHANNEL, 0xFF00);

	        if(count >= 100000) {
	            cmd = 1 - cmd;
	            count = 0;
	        }
	        count++;
	    }
	    // Si seul le deuxième interrupteur est activé
	    else if(intrp & 0x0002){
	        if(isSet == 4)		// bouton right
	        {
	            XGpio_DiscreteSet(&led, LED_CHANNEL, 0x00F0);
	        }
	        if(isSet == 1) // bouton left
	        {
	            XGpio_DiscreteClear(&led, LED_CHANNEL, 0x00F0);
	        }
	        if((prevButtonState == 0) && (isSet == 2)){     // detecter le front montant
	        	XGpio_DiscreteClear(&led, LED_CHANNEL, 0x000F);
				XGpio_DiscreteSet(&led, LED_CHANNEL, mod_count%16);
				mod_count ++;

			}
	        prevButtonState = isSet;
	    }
	}


	return 0;
}
