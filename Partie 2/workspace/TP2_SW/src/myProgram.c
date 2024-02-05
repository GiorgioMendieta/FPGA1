#include "xgpio.h"
#include "xparameters.h"

#define BTN_CHANNEL 1
#define LED_CHANNEL 2

int main()
{
	int Status;
	XGpio button;
	XGpio led;

	// Initialize GPIOs
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
	// Set I/O
	// In = 1, Out = 0
	u32 ledMask = 0xFFFF;
	u32 buttonMask = 0xF;
	// Right
	// set_property PACKAGE_PIN T17 [get_ports {buttons_tri_i[0]}]
	// Up
	// set_property PACKAGE_PIN T18 [get_ports {buttons_tri_i[1]}]
	// Left
	// set_property PACKAGE_PIN W19 [get_ports {buttons_tri_i[2]}]
	XGpio_SetDataDirection(&button, BTN_CHANNEL, 1);
	XGpio_SetDataDirection(&led, LED_CHANNEL, 0);

	u32 isSet = 0;

	while(1)
	{
		isSet = XGpio_DiscreteRead(&button, BTN_CHANNEL);

		if(isSet == 1)
		{
			// Set bit with bitmask
			XGpio_DiscreteWrite(&led, LED_CHANNEL, 0xFFFF);
		}
		else
		{
			// Clear bit with bitmask
			XGpio_DiscreteWrite(&led, LED_CHANNEL, 0x0000);
		}
	}
	return 0;
}
