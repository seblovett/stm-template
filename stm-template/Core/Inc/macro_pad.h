/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.h
  * @brief          : Header for main.c file.
  *                   This file contains the common defines of the application.
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2024 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */
/* USER CODE END Header */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __MACROPAD_H
#define __MACROPAD_H

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "stm32h7xx_hal.h"
#include "usb_device.h"

void mp_start();
void mp_stop();
void mp_process_pid(int32_t pv);
void mp_set_kp(float newkp);
void mp_set_sp(int32_t newsp);
void mp_set_num_notches(uint8_t newnn);
void mp_process();

#ifdef __cplusplus
}
#endif

#endif /* __MACROPAD_H */
