
#include "xil_io.h"
#include "my_led.h"
#include "xgpio.h"
#include "xparameters.h"

#define SWITCH_CHANNEL 1

int main(){
	int Status;
	XGpio switch_;

	Status = XGpio_Initialize(&switch_, XPAR_LED_SWITCH_DEVICE_ID);
		if (Status != XST_SUCCESS) {
			xil_printf("Gpio Initialization Failed\r\n");
			return XST_FAILURE;
		}



	XGpio_SetDataDirection(&switch_, SWITCH_CHANNEL, 1);

	while(1)
	{
		MY_LED_mWriteReg(BaseAddress, MY_LED_S00_AXI_SLV_REG0_OFFSET, 1);
		Data = MY_LED_mReadReg(BaseAddress, 0);

	}

	return 0;

}
