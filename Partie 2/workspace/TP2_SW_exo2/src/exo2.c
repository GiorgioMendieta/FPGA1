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

	u32 intrp = 0;
	u32 count= 0;
	u32 position = 0;



	while(1)
	{
		intrp = XGpio_DiscreteRead(&switch_, SWITCH_CHANNEL);

		// Vérifier le bit 4 (0x0008)
		if ((intrp & 0x0008))
		{
			if (count >= 25000){
				XGpio_DiscreteWrite(&led, LED_CHANNEL, 1 << position);
				position++;
				count = 0;
			}
		}
		// Vérifier le bit 3 (0x0004)
		else if (intrp & 0x0004)
		{
			if (count >= 50000){
				XGpio_DiscreteWrite(&led, LED_CHANNEL, 1 << position);
				position++;
				count = 0;
			}
		}
		// Vérifier le bit 2 (0x0002)
		else if (intrp & 0x0002)
		{
			if (count >= 100000){
				XGpio_DiscreteWrite(&led, LED_CHANNEL, 1 << position);
				position++;
				count = 0;
			}
		}
		// Vérifier le bit 1 (0x0001)
		else if (intrp & 0x0001)
		{
			if (count >= 200000){
				XGpio_DiscreteWrite(&led, LED_CHANNEL, 1 << position);
				position++;
				count = 0;
			}
		}


		if (position >= 16)
			position = 0;

		count++;
	}

	return 0;
}
