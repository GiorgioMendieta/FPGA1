
/*******************************************************************
*
* CAUTION: This file is automatically generated by HSI.
* Version: 2020.2
* DO NOT EDIT.
*
* Copyright (C) 2010-2024 Xilinx, Inc. All Rights Reserved.
* SPDX-License-Identifier: MIT 

* 
* Description: Driver configuration
*
*******************************************************************/

#include "xparameters.h"
#include "xgpio.h"

/*
* The configuration table for devices
*/

XGpio_Config XGpio_ConfigTable[XPAR_XGPIO_NUM_INSTANCES] =
{
	{
		XPAR_BUTTONS_DEVICE_ID,
		XPAR_BUTTONS_BASEADDR,
		XPAR_BUTTONS_INTERRUPT_PRESENT,
		XPAR_BUTTONS_IS_DUAL
	},
	{
		XPAR_LED_SWITCH_DEVICE_ID,
		XPAR_LED_SWITCH_BASEADDR,
		XPAR_LED_SWITCH_INTERRUPT_PRESENT,
		XPAR_LED_SWITCH_IS_DUAL
	}
};


