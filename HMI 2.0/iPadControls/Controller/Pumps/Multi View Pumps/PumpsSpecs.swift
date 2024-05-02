//
//  AnimationPumpsSpecs.swift
//  iPadControls
//
//  Created by Jan Manalo on 9/10/18.
//  Copyright © 2018 WET. All rights reserved.
//

import Foundation

let PUMPS_LANGUAGE_DATA_PARAM                    = "pumps"

//=============== Animation Pumps

let PUMPS_AUTO_HAND_PLC_REGISTER                 = (register: 49, type:"REGISTER", name:"All Pumps Auto")
let PUMP_SPEED_INDICATOR_READ_LIMIT              = 2

let PUMP_SETS                       = [PUMP_SET_A, PUMP_SET_B]
let PUMP_DETAILS_SETS               = [PUMP_DETAILS_SPECS_SET_A, PUMP_DETAILS_SPECS_SET_B]

let PUMP_SET_A = [
    
    (register:1, type:"INT", name: "iPad1_PumpNumber"),
    (register:2, type:"INT", name: "Manual_Speed"),
    (register:3, type:"INT", name: "Output_Freq"),
    (register:4, type:"INT", name: "Current"),
    (register:5, type:"INT", name: "Voltage"),
    (register:6, type:"INT", name: "Temperature"),
    (register:7, type:"INT", name: "Auto_Mode"),
    (register:8, type:"INT", name: "Manual_Mode"),
    (register:9, type:"INT", name: "Manual_Start"),
    (register:10, type:"INT", name: "Mode_Feedback"),
    (register:11, type:"INT", name: "Man_Speed2"),
    (register:13, type:"INT", name: "Press Fault"),
    (register:14, type:"INT", name: "VFD Fault"),
    (register:15, type:"INT", name: "GFCI Fault")
    
]

let PUMP_SET_B = [
    
    (register:21, type:"INT", name: "iPad2_PumpNumber"),
    (register:22, type:"INT", name: "Manual_Speed"),
    (register:23, type:"INT", name: "Output_Freq"),
    (register:24, type:"INT", name: "Current"),
    (register:25, type:"INT", name: "Voltage"),
    (register:26, type:"INT", name: "Temperature"),
    (register:27, type:"INT", name: "Auto_Mode"),
    (register:28, type:"INT", name: "Manual_Mode"),
    (register:29, type:"INT", name: "Manual_Start"),
    (register:30, type:"INT", name: "Mode_Feedback"),
    (register:31, type:"INT", name: "Man_Speed2"),
    (register:33, type:"INT", name: "Press Fault"),
    (register:34, type:"INT", name: "VFD Fault"),
    (register:35, type:"INT", name: "GFCI Fault")
    
]


let PUMP_DETAILS_SPECS_SET_A = [
    
    (register:13, type:"INT", name: "HZ_Max"),
    (register:14, type:"INT", name: "Voltage_Max"),
    (register:15, type:"INT", name: "Voltage_Min"),
    (register:16, type:"INT", name: "Current_Max"),
    (register:17, type:"INT", name: "Temperature_Max")
    
]

let PUMP_DETAILS_SPECS_SET_B = [
    
    (register:33, type:"INT", name: "HZ_Max"),
    (register:34, type:"INT", name: "Voltage_Max"),
    (register:35, type:"INT", name: "Voltage_Min"),
    (register:36, type:"INT", name: "Current_Max"),
    (register:37, type:"INT", name: "Temperature_Max")
    
]


let PUMP_FAULT_SET = [
    (tag: 200, bitwiseLocation: 0, type:"INT", name: "Pump Fault"),
    (tag: 201, bitwiseLocation: 1, type:"INT", name: "Press Fault"),
    (tag: 202, bitwiseLocation: 2, type:"INT", name: "VFD Fault"),
    (tag: 203, bitwiseLocation: 3, type:"INT", name: "GFCI Fault"),
    (tag: 204, bitwiseLocation: 4, type:"INT", name: "Network Fault"),
    (tag: 205, bitwiseLocation: 5, type:"INT", name: "Mode Feedback"),
    (tag: 206, bitwiseLocation: 6, type:"INT", name: "CleanStrainer Warning"),
    (tag: 207, bitwiseLocation: 7, type:"INT", name: "Run Status"),
    (tag: 208, bitwiseLocation: 8, type:"INT", name: "Low Water Level")
]

let DATA_AI = [
    (readRegister:0, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "DeviceType"),
    (readRegister:1, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "DeviceVersion"),
    (readRegister:2, writeBit:99, bitwiseLocation:0, writeRegister:99, name: "stsBits_aboveHH"),
    (readRegister:2, writeBit:99, bitwiseLocation:1, writeRegister:99, name: "stsBits_aboveH"),
    (readRegister:2, writeBit:99, bitwiseLocation:2, writeRegister:99, name: "stsBits_belowL"),
    (readRegister:2, writeBit:99, bitwiseLocation:3, writeRegister:99, name: "stsBits_belowLL"),
    (readRegister:2, writeBit:99, bitwiseLocation:4, writeRegister:99, name: "stsBits_belowLLL"),
    (readRegister:2, writeBit:99, bitwiseLocation:5, writeRegister:99, name: "fault"),
    (readRegister:2, writeBit:99, bitwiseLocation:6, writeRegister:99, name: "channelFault"),
    (readRegister:2, writeBit:99, bitwiseLocation:7, writeRegister:99, name: "scalingFault"),
    (readRegister:2, writeBit:99, bitwiseLocation:8, writeRegister:99, name: "outOfRangeFault"),
    (readRegister:3, writeBit:0, bitwiseLocation:0, writeRegister:99, name: "cmdBits_iPadOverride"),
    (readRegister:3, writeBit:1, bitwiseLocation:1, writeRegister:99, name: "cmdBits_forceHigh"),
    (readRegister:3, writeBit:2, bitwiseLocation:2, writeRegister:99, name: "cmdBits_forceLow"),
    (readRegister:4, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "sts_scaledValue"),
    (readRegister:5, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "sts_rawValue"),
    (readRegister:6, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "sts_precision"),
    (readRegister:7, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "sts_scaleMin"),
    (readRegister:8, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "sts_scaleMax"),
    (readRegister:9, writeBit:99, bitwiseLocation:99, writeRegister:9, name: "cfg_OverrideVal"),
    (readRegister:10, writeBit:99, bitwiseLocation:99, writeRegister:10, name: "cfg_aboveHHSP"),
    (readRegister:11, writeBit:99, bitwiseLocation:99, writeRegister:11, name: "cfg_aboveHSP"),
    (readRegister:12, writeBit:99, bitwiseLocation:99, writeRegister:12,name: "cfg_belowLSP"),
    (readRegister:13, writeBit:99, bitwiseLocation:99, writeRegister:13, name: "cfg_belowLLSP"),
    (readRegister:14, writeBit:99, bitwiseLocation:99, writeRegister:14, name: "cfg_belowLLLSP"),
    (readRegister:15, writeBit:99, bitwiseLocation:99, writeRegister:15, name: "cfg_aboveHH_DelayTimer"),
    (readRegister:16, writeBit:99, bitwiseLocation:99, writeRegister:16, name: "cfg_aboveH_DelayTimer"),
    (readRegister:17, writeBit:99, bitwiseLocation:99, writeRegister:17, name: "cfg_belowL_DelayTimer"),
    (readRegister:18, writeBit:99, bitwiseLocation:99, writeRegister:18, name: "cfg_belowLL_DelayTimer"),
    (readRegister:19, writeBit:99, bitwiseLocation:99, writeRegister:19, name: "cfg_belowLLL_DelayTimer")
]

let TYPE_BR = [

    (readRegister:0, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "DeviceType"),
    (readRegister:1, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "DeviceVersion"),
    (readRegister:2, writeBit:99, bitwiseLocation:0, writeRegister:99, name: "stsBits_brEnabled"),
    (readRegister:2, writeBit:99, bitwiseLocation:0, writeRegister:99, name: "stsBits_brDosing"),
    (readRegister:2, writeBit:99, bitwiseLocation:0, writeRegister:99,  name: "stsBits_brValveOpen"),
    (readRegister:2, writeBit:99, bitwiseLocation:0, writeRegister:99,  name: "stsBits_brTimeout"),
    (readRegister:2, writeBit:99, bitwiseLocation:0, writeRegister:99,  name: "stsBits_brAutoMode"),
    (readRegister:2, writeBit:99, bitwiseLocation:0, writeRegister:99,  name: "stsBits_brHandMode"),
    (readRegister:2, writeBit:99, bitwiseLocation:0, writeRegister:99,  name: "stsBits_brStartCmd"),
    (readRegister:2, writeBit:99, bitwiseLocation:0, writeRegister:99,  name: "stsBits_brStopCmd"),
    (readRegister:3, writeBit:0, bitwiseLocation:0, writeRegister:99, name: "cmdBits_HAMode"),
    (readRegister:3, writeBit:1, bitwiseLocation:1, writeRegister:99, name: "cmdBits_HandStart"),
    (readRegister:3, writeBit:2, bitwiseLocation:2, writeRegister:99, name: "cmdBits_HandStop"),
    (readRegister:3, writeBit:3, bitwiseLocation:3, writeRegister:99, name: "cmdBits_Disable"),
    (readRegister:3, writeBit:4, bitwiseLocation:4, writeRegister:99, name: "cmdBits_OverrideDosing"),
    (readRegister:3, writeBit:5, bitwiseLocation:5, writeRegister:99, name: "cmdBits_FaultReset"),
    (readRegister:4, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "sts_ORPscaledValue"),
    (readRegister:5, writeBit:99, bitwiseLocation:99, writeRegister:5, name: "cfg_StartDosingSP"),
    (readRegister:6, writeBit:99, bitwiseLocation:99, writeRegister:6, name: "cfg_StopDosingSP"),
    (readRegister:7, writeBit:99, bitwiseLocation:99, writeRegister:7, name: "cfg_StartDosingTimer"),
    (readRegister:8, writeBit:99, bitwiseLocation:99, writeRegister:8, name: "cfg_StopDosingTimer"),
    (readRegister:9, writeBit:99, bitwiseLocation:99, writeRegister:9, name: "cfg_ValveOpenTimer"),
    (readRegister:10, writeBit:99, bitwiseLocation:99, writeRegister:10, name: "cfg_ValveCloseTimer"),
    (readRegister:11, writeBit:99, bitwiseLocation:99, writeRegister:11, name: "cfg_DosingTimeoutDelayTimer")

]

let TYPE_CS = [

    (readRegister:0, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "DeviceType"),
    (readRegister:1, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "DeviceVersion"),
    (readRegister:2, writeBit:99, bitwiseLocation:0, writeRegister:99, name: "stsBits_progRunning"),
    (readRegister:2, writeBit:99, bitwiseLocation:1, writeRegister:99, name: "stsBits_PLCColdStart"),
    (readRegister:2, writeBit:99, bitwiseLocation:2, writeRegister:99, name: "stsBits_PLCWarmStart"),
    (readRegister:2, writeBit:99, bitwiseLocation:3, writeRegister:99, name: "stsBits_IOError"),
    (readRegister:2, writeBit:99, bitwiseLocation:4, writeRegister:99, name: "stsBits_cycleTimeWarning"),
    (readRegister:3, writeBit:0, bitwiseLocation:0, writeRegister:99, name: "cmdBits_WarningLatch"),
    (readRegister:3, writeBit:1, bitwiseLocation:1, writeRegister:99, name: "cmdBits_WarningReset"),
    (readRegister:4, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "sts_CurrCycleTime"),
    (readRegister:5, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "sts_MaxCycleTime"),
    (readRegister:6, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "cfg_ProgUpDays"),
    (readRegister:7, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "cfg_ProgUpTime"),
    (readRegister:8, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "cfg_ProjVersion"),
    (readRegister:9, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "cfg_ProjBuildNum"),
    (readRegister:10, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "cfg_ProjLibVersion"),
    (readRegister:11, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "cfg_ProjBuildYear"),
    (readRegister:12, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "cfg_ProjBuildDay"),
    (readRegister:13, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "cfg_ProjBuildTime"),
    (readRegister:14, writeBit:99, bitwiseLocation:99, writeRegister:14, name: "cfg_CycleWarningTimer")

]

let TYPE_DC = [

    (readRegister:0, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "DeviceType"),
    (readRegister:1, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "DeviceVersion"),
    (readRegister:2, writeBit:99, bitwiseLocation:0, writeRegister:99, name: "stsBits_deviceEnabled"),
    (readRegister:2, writeBit:99, bitwiseLocation:1, writeRegister:99, name: "stsBits_powerOn"),
    (readRegister:2, writeBit:99, bitwiseLocation:2, writeRegister:99, name: "stsBits_coolingFanOn"),
    (readRegister:2, writeBit:99, bitwiseLocation:3, writeRegister:99, name: "stsBits_Fault"),
    (readRegister:2, writeBit:99, bitwiseLocation:4, writeRegister:99, name: "stsBits_fanInAuto"),
    (readRegister:2, writeBit:99, bitwiseLocation:5, writeRegister:99, name: "stsBits_fanInHand"),
    (readRegister:2, writeBit:99, bitwiseLocation:6, writeRegister:99, name: "stsBits_HighTempWarning"),
    (readRegister:2, writeBit:99, bitwiseLocation:7, writeRegister:99, name: "stsBits_HighHighTempFault"),
    (readRegister:2, writeBit:99, bitwiseLocation:8, writeRegister:99, name: "stsBits_TempSensorFault"),
    (readRegister:2, writeBit:99, bitwiseLocation:9, writeRegister:99, name: "stsBits_ScalingFault"),
    (readRegister:2, writeBit:99, bitwiseLocation:10, writeRegister:99, name: "stsBits_OutOfRangeFault"),
    (readRegister:2, writeBit:99, bitwiseLocation:11, writeRegister:99, name: "stsBits_EstopFault"),
    (readRegister:3, writeBit:0, bitwiseLocation:0, writeRegister:99, name: "cmdBits_HAMode"),
    (readRegister:3, writeBit:1, bitwiseLocation:1, writeRegister:99, name: "cmdBits_HandEnable"),
    (readRegister:3, writeBit:2, bitwiseLocation:2, writeRegister:99, name: "cmdBits_DisableDCPower"),
    (readRegister:3, writeBit:3, bitwiseLocation:3, writeRegister:99, name: "cmdBits_ForceDCPowerOn"),
    (readRegister:3, writeBit:4, bitwiseLocation:4, writeRegister:99, name: "cmdBits_FaultReset"),
    (readRegister:4, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "sts_scaledTempValue"),
    (readRegister:5, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "sts_rawValue"),
    (readRegister:6, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "sts_precision"),
    (readRegister:7, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "sts_scaleMin"),
    (readRegister:8, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "sts_scaleMax"),
    (readRegister:9, writeBit:99, bitwiseLocation:99, writeRegister:9, name: "cfg_OverrideValSP"),
    (readRegister:10, writeBit:99, bitwiseLocation:99, writeRegister:10, name: "cfg_fanStartSP"),
    (readRegister:11, writeBit:99, bitwiseLocation:99, writeRegister:11, name: "cfg_fanWarningSP"),
    (readRegister:12, writeBit:99, bitwiseLocation:99, writeRegister:12, name: "cfg_fanShutOffSP"),
    (readRegister:13, writeBit:99, bitwiseLocation:99, writeRegister:13, name: "cfg_fanStartDelayTimer"),
    (readRegister:14, writeBit:99, bitwiseLocation:99, writeRegister:14, name: "cfg_fanWarningDelayTimer"),
    (readRegister:15, writeBit:99, bitwiseLocation:99, writeRegister:15, name: "cfg_fanShutOffDelayTimer")

]

let TYPE_LV = [

    (readRegister:0, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "DeviceType"),
    (readRegister:1, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "DeviceVersion"),
    (readRegister:2, writeBit:99, bitwiseLocation:0, writeRegister:99, name: "stsBits_Enabled"),
    (readRegister:2, writeBit:99, bitwiseLocation:1, writeRegister:99, name: "stsBits_ValveOpen"),
    (readRegister:2, writeBit:99, bitwiseLocation:2, writeRegister:99, name: "stsBits_Faulted"),
    (readRegister:2, writeBit:99, bitwiseLocation:3, writeRegister:99, name: "stsBits_InAutoMode"),
    (readRegister:2, writeBit:99, bitwiseLocation:4, writeRegister:99, name: "stsBits_InHandMode"),
    (readRegister:2, writeBit:99, bitwiseLocation:5, writeRegister:99, name: "stsBits_MakeupStartCmd"),
    (readRegister:2, writeBit:99, bitwiseLocation:6, writeRegister:99, name: "stsBits_MakeupStopCmd"),
    (readRegister:2, writeBit:99, bitwiseLocation:7, writeRegister:99, name: "stsBits_faultTimeOut"),
    (readRegister:2, writeBit:99, bitwiseLocation:8, writeRegister:99, name: "stsBits_faultMalfunction"),
    (readRegister:2, writeBit:99, bitwiseLocation:9, writeRegister:99, name: "stsBits_FaultEstop"),
    (readRegister:3, writeBit:0, bitwiseLocation:0, writeRegister:99, name: "cmdBits_HAMode"),
    (readRegister:3, writeBit:1, bitwiseLocation:1, writeRegister:99, name: "cmdBits_HandStart"),
    (readRegister:3, writeBit:2, bitwiseLocation:2, writeRegister:99, name: "cmdBits_HandStop"),
    (readRegister:3, writeBit:3, bitwiseLocation:3, writeRegister:99, name: "cmdBits_Disable"),
    (readRegister:3, writeBit:4, bitwiseLocation:4, writeRegister:99, name: "cmdBits_Override"),
    (readRegister:3, writeBit:5, bitwiseLocation:5, writeRegister:99, name: "cmdBits_FaultReset"),
    (readRegister:4, writeBit:99, bitwiseLocation:99, writeRegister:4, name: "cfg_MakeupTimeoutDelayTimer")

]

let TYPE_MS = [

    (readRegister:0, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "DeviceType"),
    (readRegister:1, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "DeviceVersion"),
    (readRegister:2, writeBit:99, bitwiseLocation:0, writeRegister:99, name: "stsBits_Enabled"),
    (readRegister:2, writeBit:99, bitwiseLocation:1, writeRegister:99, name: "stsBits_StarterEngaged"),
    (readRegister:2, writeBit:99, bitwiseLocation:2, writeRegister:99, name: "stsBits_Faulted"),
    (readRegister:2, writeBit:99, bitwiseLocation:3, writeRegister:99, name: "stsBits_InAutoMode"),
    (readRegister:2, writeBit:99, bitwiseLocation:4, writeRegister:99, name: "stsBits_InHandMode"),
    (readRegister:2, writeBit:99, bitwiseLocation:5, writeRegister:99, name: "stsBits_StarterCmd"),
    (readRegister:2, writeBit:99, bitwiseLocation:6, writeRegister:99, name: "stsBits_FaultOverload"),
    (readRegister:2, writeBit:99, bitwiseLocation:7, writeRegister:99, name: "stsBits_FaultGFCI"),
    (readRegister:2, writeBit:99, bitwiseLocation:8, writeRegister:99, name: "stsBits_FaultLowWater"),
    (readRegister:2, writeBit:99, bitwiseLocation:9, writeRegister:99, name: "stsBits_FaultLowPressure"),
    (readRegister:2, writeBit:99, bitwiseLocation:10, writeRegister:99, name: "stsBits_FaultContactor"),
    (readRegister:2, writeBit:99, bitwiseLocation:11, writeRegister:99, name: "stsBits_FaultEstop"),
    (readRegister:2, writeBit:99, bitwiseLocation:12, writeRegister:99, name: "stsBits_NotInAutoWarning"),
    (readRegister:3, writeBit:0, bitwiseLocation:0, writeRegister:99, name: "cmdBits_HAMode"),
    (readRegister:3, writeBit:1, bitwiseLocation:1, writeRegister:99, name: "cmdBits_HandEnable"),
    (readRegister:3, writeBit:2, bitwiseLocation:2, writeRegister:99, name: "cmdBits_DisableStarter"),
    (readRegister:3, writeBit:3, bitwiseLocation:3, writeRegister:99, name: "cmdBits_ForceStarterOn"),
    (readRegister:3, writeBit:4, bitwiseLocation:4, writeRegister:99, name: "cmdBits_FaultReset"),
    (readRegister:4, writeBit:99, bitwiseLocation:99, writeRegister:4, name: "cfg_PressureFaultDelayTimer"),
    (readRegister:4, writeBit:99, bitwiseLocation:99, writeRegister:5, name: "cfg_ContractorFaultDelayTimer")

]

let TYPE_ZS = [

    (readRegister:0, writeBit:99, bitwiseLocation:99, writeRegister:99, name: "DeviceType"),
    (readRegister:1, writeBit:99, bitwiseLocation:99, writeRegister:99,name: "DeviceVersion"),
    (readRegister:2, writeBit:99, bitwiseLocation:0, writeRegister:99, name: "stsBits_Enabled"),
    (readRegister:2, writeBit:99, bitwiseLocation:1, writeRegister:99, name: "stsBits_ValveOpen"),
    (readRegister:2, writeBit:99, bitwiseLocation:2, writeRegister:99, name: "stsBits_ValveClose"),
    (readRegister:2, writeBit:99, bitwiseLocation:3, writeRegister:99, name: "stsBits_ValveInTransition"),
    (readRegister:2, writeBit:99, bitwiseLocation:4, writeRegister:99, name: "stsBits_Faulted"),
    (readRegister:2, writeBit:99, bitwiseLocation:5, writeRegister:99, name: "stsBits_InAutoMode"),
    (readRegister:2, writeBit:99, bitwiseLocation:6, writeRegister:99, name: "stsBits_InHandMode"),
    (readRegister:2, writeBit:99, bitwiseLocation:7, writeRegister:99, name: "stsBits_AutoValveCmd"),
    (readRegister:2, writeBit:99, bitwiseLocation:8, writeRegister:99, name: "stsBits_HandValveCmd"),
    (readRegister:2, writeBit:99, bitwiseLocation:9, writeRegister:99, name: "stsBits_FaultFailToOpen"),
    (readRegister:2, writeBit:99, bitwiseLocation:10, writeRegister:99, name: "stsBits_FaultFailToClose"),
    (readRegister:2, writeBit:99, bitwiseLocation:11, writeRegister:99, name: "stsBits_FaultEstop"),
    (readRegister:3, writeBit:0, bitwiseLocation:0, writeRegister:99, name: "cmdBits_HAMode"),
    (readRegister:3, writeBit:1, bitwiseLocation:1, writeRegister:99, name: "cmdBits_HandEnable"),
    (readRegister:3, writeBit:2, bitwiseLocation:2, writeRegister:99, name: "cmdBits_DisableValve"),
    (readRegister:3, writeBit:3, bitwiseLocation:3, writeRegister:99, name: "cmdBits_ForceValveOpen"),
    (readRegister:3, writeBit:4, bitwiseLocation:4, writeRegister:99, name: "cmdBits_FaultReset"),
    (readRegister:4, writeBit:99, bitwiseLocation:99, writeRegister:4, name: "cfg_FailToOperateDelayTimer")

]

let TYPE_FD = [

    (readRegister:0, writeBit:99, bitwiseLocation:99, faultCode:"NA", writeRegister:99, name: "DeviceType"),
    (readRegister:1, writeBit:99, bitwiseLocation:99, faultCode:"NA", writeRegister:99,name: "DeviceVersion"),
    (readRegister:2, writeBit:99, bitwiseLocation:0, faultCode:"NA", writeRegister:99, name: "stsBits_VFDReady"),
    (readRegister:2, writeBit:99, bitwiseLocation:1, faultCode:"NA", writeRegister:99, name: "stsBits_VFDRunning"),
    (readRegister:2, writeBit:99, bitwiseLocation:2, faultCode:"NA", writeRegister:99, name: "stsBits_AnyFault"),
    (readRegister:2, writeBit:99, bitwiseLocation:3, faultCode:"NA", writeRegister:99, name: "stsBits_AnyWarning"),
    (readRegister:2, writeBit:99, bitwiseLocation:4, faultCode:"NA", writeRegister:99, name: "stsBits_InHandMode"),
    (readRegister:2, writeBit:99, bitwiseLocation:5, faultCode:"NA", writeRegister:99, name: "stsBits_InOffMode"),
    (readRegister:2, writeBit:99, bitwiseLocation:6, faultCode:"NA", writeRegister:99, name: "stsBits_InAutoMode"),
    (readRegister:2, writeBit:99, bitwiseLocation:7, faultCode:"NA", writeRegister:99, name: "stsBits_InFiltrationControlMode"),
    (readRegister:2, writeBit:99, bitwiseLocation:8, faultCode:"NA", writeRegister:99, name: "stsBits_InShowControlMode"),
    (readRegister:2, writeBit:99, bitwiseLocation:9, faultCode:"NA", writeRegister:99, name: "stsBits_InScheduleControlMode"),
    (readRegister:2, writeBit:99, bitwiseLocation:10, faultCode:"NA", writeRegister:99, name: "stsBits_InPLCControlMode"),
    (readRegister:2, writeBit:99, bitwiseLocation:11, faultCode:"NA", writeRegister:99, name: "stsBits_VFDWarning"),
    (readRegister:2, writeBit:99, bitwiseLocation:12, faultCode:"NA", writeRegister:99, name: "stsBits_StrainerWarning"),
    (readRegister:2, writeBit:99, bitwiseLocation:13, faultCode:"NA", writeRegister:99, name: "stsBits_NotInAutoWarning"),
    (readRegister:3, writeBit:0, bitwiseLocation:0, faultCode:"NA", writeRegister:99, name: "cmdBits_HandMode"),
    (readRegister:3, writeBit:1, bitwiseLocation:1, faultCode:"NA", writeRegister:99, name: "cmdBits_OffMode"),
    (readRegister:3, writeBit:2, bitwiseLocation:2, faultCode:"NA", writeRegister:99, name: "cmdBits_AutoMode"),
    (readRegister:3, writeBit:3, bitwiseLocation:3, faultCode:"NA", writeRegister:99, name: "cmdBits_HandModeStart"),
    (readRegister:3, writeBit:4, bitwiseLocation:4, faultCode:"NA", writeRegister:99, name: "cmdBits_HandModeStop"),
    (readRegister:3, writeBit:5, bitwiseLocation:5, faultCode:"NA", writeRegister:99, name: "cmdBits_FaultReset"),
    (readRegister:3, writeBit:6, bitwiseLocation:6, faultCode:"NA", writeRegister:99, name: "cmdBits_WarningReset"),
    (readRegister:3, writeBit:7, bitwiseLocation:7, faultCode:"NA", writeRegister:99, name: "cmdBits_EnableAutoReset"),
    (readRegister:4, writeBit:99, bitwiseLocation:0, faultCode:"NA", writeRegister:99, name: "stsBits_FaultEstop"),
    (readRegister:4, writeBit:99, bitwiseLocation:1, faultCode:"NA", writeRegister:99, name: "stsBits_FaultNetwork"),
    (readRegister:4, writeBit:99, bitwiseLocation:2, faultCode:"NA", writeRegister:99, name: "stsBits_FaultInActive"),
    (readRegister:4, writeBit:99, bitwiseLocation:3, faultCode:"NA", writeRegister:99, name: "stsBits_FaultLowWater"),
    (readRegister:4, writeBit:99, bitwiseLocation:4, faultCode:"NA", writeRegister:99, name: "stsBits_FaultLowPressure"),
    (readRegister:4, writeBit:99, bitwiseLocation:5, faultCode:"NA", writeRegister:99, name: "stsBits_FaultGFCI"),
    (readRegister:4, writeBit:99, bitwiseLocation:6, faultCode:"NA", writeRegister:99, name: "stsBits_FaultFailToRun"),
    (readRegister:5, writeBit:99, bitwiseLocation:0, faultCode:"NA", writeRegister:99, name: "stsVFD_ReadyToSwitchOn"),
    (readRegister:5, writeBit:99, bitwiseLocation:1, faultCode:"NA", writeRegister:99, name: "stsVFD_ReadyToRun"),
    (readRegister:5, writeBit:99, bitwiseLocation:2, faultCode:"NA", writeRegister:99, name: "stsVFD_Running"),
    (readRegister:5, writeBit:99, bitwiseLocation:3, faultCode:"NA", writeRegister:99, name: "stsVFD_FaultActive"),
    (readRegister:5, writeBit:99, bitwiseLocation:4, faultCode:"NA", writeRegister:99, name: "stsVFD_MainVoltageEnabled"),
    (readRegister:5, writeBit:99, bitwiseLocation:5, faultCode:"NA", writeRegister:99, name: "stsVFD_QuickStop"),
    (readRegister:5, writeBit:99, bitwiseLocation:6, faultCode:"NA", writeRegister:99, name: "stsVFD_SwitchedOnDisabled"),
    (readRegister:5, writeBit:99, bitwiseLocation:7, faultCode:"NA", writeRegister:99, name: "stsVFD_WarningActive"),
    (readRegister:5, writeBit:99, bitwiseLocation:9, faultCode:"NA", writeRegister:99, name: "stsVFD_ReferencedByNetwork"),
    (readRegister:5, writeBit:99, bitwiseLocation:10, faultCode:"NA", writeRegister:99, name: "stsVFD_ReferencedAtSpeed"),
    (readRegister:5, writeBit:99, bitwiseLocation:11, faultCode:"NA", writeRegister:99, name: "stsVFD_IntLimit"),
    (readRegister:5, writeBit:99, bitwiseLocation:14, faultCode:"NA", writeRegister:99, name: "stsVFD_TerminalStopTriggered"),
    (readRegister:5, writeBit:99, bitwiseLocation:15, faultCode:"NA", writeRegister:99, name: "stsVFD_DirectionReversed"),
    (readRegister:6, writeBit:99, bitwiseLocation:0, faultCode:"FLO", writeRegister:99, name: "stsVFD_InForcedLocalMode"),
    (readRegister:6, writeBit:99, bitwiseLocation:1, faultCode:"FR2", writeRegister:99, name: "stsVFD_ReferenceChannel2"),
    (readRegister:6, writeBit:99, bitwiseLocation:2, faultCode:"FR1B", writeRegister:99, name: "stsVFD_ReferenceChannel1FRB1Used"),
    (readRegister:6, writeBit:99, bitwiseLocation:4, faultCode:"FR1", writeRegister:99, name: "stsVFD_ReferenceChannel1"),
    (readRegister:6, writeBit:99, bitwiseLocation:5, faultCode:"CD1", writeRegister:99, name: "stsVFD_CmdChannelIsChannel1"),
    (readRegister:6, writeBit:99, bitwiseLocation:6, faultCode:"CD2", writeRegister:99, name: "stsVFD_CmdChannelIsChannel2"),
    (readRegister:6, writeBit:99, bitwiseLocation:7, faultCode:"RFC", writeRegister:99, name: "stsVFD_Ref. channel : 0-> channel 1, 1-> channel 2"),
    (readRegister:6, writeBit:99, bitwiseLocation:8, faultCode:"RCB", writeRegister:99, name: "stsVFD_0:FR1,FR1B?"),
    (readRegister:6, writeBit:99, bitwiseLocation:9, faultCode:"CCS", writeRegister:99, name: "stsVFD_Cmd. channel : 0-> channel 1, 1-> channel 2"),
    (readRegister:6, writeBit:99, bitwiseLocation:10, faultCode:"BMP", writeRegister:99, name: "stsVFD_BumpLessChannel"),
    (readRegister:7, writeBit:99, bitwiseLocation:99, faultCode:"NA", writeRegister:99, name: "sts_cmdFrequency"),
    (readRegister:8, writeBit:99, bitwiseLocation:99, faultCode:"NA", writeRegister:99, name: "sts_OutputFrequency"),
    (readRegister:9, writeBit:99, bitwiseLocation:99, faultCode:"NA", writeRegister:99, name: "sts_OutputVoltage"),
    (readRegister:10, writeBit:99, bitwiseLocation:99, faultCode:"NA", writeRegister:99, name: "sts_OutputCurrent"),
    (readRegister:11, writeBit:99, bitwiseLocation:99, faultCode:"NA", writeRegister:99, name: "sts_OutputPower"),
    (readRegister:12, writeBit:99, bitwiseLocation:99, faultCode:"NA", writeRegister:99, name: "sts_OutputTemperature"),
    (readRegister:13, writeBit:99, bitwiseLocation:99, faultCode:"NA", writeRegister:99, name: "sts_LastFaultDetected"),
    (readRegister:14, writeBit:99, bitwiseLocation:99, faultCode:"NA", writeRegister:99, name: "sts_ShowFrequencyData"),
    (readRegister:15, writeBit:99, bitwiseLocation:99, faultCode:"NA", writeRegister:99, name: "sts_PLCFrequencyData"),
    (readRegister:16, writeBit:99, bitwiseLocation:99, faultCode:"NA", writeRegister:16, name: "cfg_iPadFrequencySP"),
    (readRegister:17, writeBit:99, bitwiseLocation:99, faultCode:"NA", writeRegister:17, name: "cfg_iPadBwashFrequencySP"),
    (readRegister:18, writeBit:99, bitwiseLocation:99, faultCode:"NA", writeRegister:18, name: "cfg_FailToRunDelayTimer")

]






//ANIMATION PUMPS REGISTERS 22 - 40

let TWW_PUMP_EN                     = 2020
let TWW_PUMP_SCH_BIT                = 2022

let PUMPS_FAULT_STATUS_START_REGISTER = 1022
let PUMPS_RUNNING_STATUS_START_REGISTER = 1018

let RR_PUMP_FAULT_BITS = 1500

let READ_TWW_SERVER_PATH               = "readGlassWWPumpSch"
let WRITE_TWW_SERVER_PATH              = "writeGlassWWPumpSch"

let EAST_WEST_ZONE_STATUS_REGISTER = 3021
let WEST_MOTOR_STARTER_REGISTER = 2257
let EAST_MOTOR_STARTER_REGISTER = 2262
let PUMP_PLAY_STOP_BIT_ADDR_109     = 5001
let PUMP_PLAY_STOP_BIT_ADDR_110     = 5003
let PUMP_101_RUNSTATUS_REGISTER     = 1004

let ANIMATION_PUMPS_STATUS_REGING_COUNT   = 1

let PUMPS_XIB_NAME              = "pumps"


var VOLTAGE_RANGE               = 250.0
let MIN_PIXEL                   = 700.0
let MAX_PIXEL                   = 25.0
let SLIDER_PIXEL_RANGE          = 450.0


//ANIMATION PUMP SETPOINT SPECS: REGISTER TYPE: REAL - WRITE/READ

let MAX_FREQUENCY_SP            = 2000
let MAX_TEMPERATURE_SP          = 2002
let MID_TEMPERATURE_SP          = 2004
let MAX_VOLTAGE_SP              = 2008
let MIN_VOLTAGE_SP              = 2010
let MAX_CURRENT_SP              = 2012

let PUMP_PRESSURE_DELAYTIMER         = 6500
let STRAINER_PRESSURE_DELAYTIMER     = 6517

let SURGE_PUMP_SETPOINTS     = 3021
let PUMPSETPOINTSPEED        = 1007

let YV1001_SHOOTER = (startAddr: 2000, count: 5)
let YV1002_SHOOTER = (startAddr: 2010, count: 5)
let YV1003_SHOOTER = (startAddr: 2020, count: 5)

let YV1001_SHOOTER_CMD_DISABLE     = 2002
let YV1001_SHOOTER_CMD_ON          = 2003

let YV1002_SHOOTER_CMD_DISABLE     = 2012
let YV1002_SHOOTER_CMD_ON          = 2013

let YV1003_SHOOTER_CMD_DISABLE     = 2022
let YV1003_SHOOTER_CMD_ON          = 2023

let YV1001_SHOOTER_DELAYTIMER      = 2004
let YV1002_SHOOTER_DELAYTIMER      = 2014
let YV1003_SHOOTER_DELAYTIMER      = 2024

let YV1001_SHOOTER_CMD_HANDMODE = 2000
let YV1002_SHOOTER_CMD_HANDMODE = 2010
let YV1003_SHOOTER_CMD_HANDMODE = 2020

let YV1001_SHOOTER_CMD_HANDCMD = 2001
let YV1002_SHOOTER_CMD_HANDCMD = 2011
let YV1003_SHOOTER_CMD_HANDCMD = 2021

let YV1001_SHOOTER_CMD_FAULTRESET = 2004
let YV1002_SHOOTER_CMD_FAULTRESET = 2014
let YV1003_SHOOTER_CMD_FAULTRESET = 2024

let DCP101_POWER = (startAddr: 3000, count: 16)
let DCP102_POWER = (startAddr: 3050, count: 16)
let DCP103_POWER = (startAddr: 3100, count: 16)
let DCP104_POWER = (startAddr: 3150, count: 16)
let DCP105_POWER = (startAddr: 3200, count: 16)

let DCP101_POWER_CMD_HANDMODE = 3000
let DCP102_POWER_CMD_HANDMODE = 3050
let DCP103_POWER_CMD_HANDMODE = 3100
let DCP104_POWER_CMD_HANDMODE = 3150
let DCP105_POWER_CMD_HANDMODE = 3200

let DCP101_POWER_CMD_HANDCMD = 3001
let DCP102_POWER_CMD_HANDCMD = 3051
let DCP103_POWER_CMD_HANDCMD = 3101
let DCP104_POWER_CMD_HANDCMD = 3151
let DCP105_POWER_CMD_HANDCMD = 3201

let DCP101_POWER_CMD_FAULTRESET = 3004
let DCP102_POWER_CMD_FAULTRESET = 3054
let DCP103_POWER_CMD_FAULTRESET = 3104
let DCP104_POWER_CMD_FAULTRESET = 3154
let DCP105_POWER_CMD_FAULTRESET = 3204

let DCP101_POWER_CMD_ENABLE     = 3002
let DCP101_POWER_CMD_ON         = 3003

let DCP102_POWER_CMD_ENABLE     = 3052
let DCP102_POWER_CMD_ON         = 3053

let DCP103_POWER_CMD_ENABLE     = 3102
let DCP103_POWER_CMD_ON         = 3103

let DCP104_POWER_CMD_ENABLE     = 3152
let DCP104_POWER_CMD_ON         = 3153

let DCP105_POWER_CMD_ENABLE     = 3202
let DCP105_POWER_CMD_ON         = 3203

let DCP101_POWER_CFG_OVERRIDEVAL    = 3009
let DCP101_POWER_CFG_STARTSP        = 3010
let DCP101_POWER_CFG_WARNINGSP      = 3011
let DCP101_POWER_CFG_SHUTOFFSP      = 3012
let DCP101_POWER_CFG_STARTTIMER     = 3013
let DCP101_POWER_CFG_WARNINGTIMER   = 3014
let DCP101_POWER_CFG_SHUTOFFTIMER   = 3015

let DCP102_POWER_CFG_OVERRIDEVAL    = 3059
let DCP102_POWER_CFG_STARTSP        = 3060
let DCP102_POWER_CFG_WARNINGSP      = 3061
let DCP102_POWER_CFG_SHUTOFFSP      = 3062
let DCP102_POWER_CFG_STARTTIMER     = 3063
let DCP102_POWER_CFG_WARNINGTIMER   = 3064
let DCP102_POWER_CFG_SHUTOFFTIMER   = 3065

let DCP103_POWER_CFG_OVERRIDEVAL    = 3109
let DCP103_POWER_CFG_STARTSP        = 3110
let DCP103_POWER_CFG_WARNINGSP      = 3111
let DCP103_POWER_CFG_SHUTOFFSP      = 3112
let DCP103_POWER_CFG_STARTTIMER     = 3113
let DCP103_POWER_CFG_WARNINGTIMER   = 3114
let DCP103_POWER_CFG_SHUTOFFTIMER   = 3115

let DCP104_POWER_CFG_OVERRIDEVAL    = 3159
let DCP104_POWER_CFG_STARTSP        = 3160
let DCP104_POWER_CFG_WARNINGSP      = 3161
let DCP104_POWER_CFG_SHUTOFFSP      = 3162
let DCP104_POWER_CFG_STARTTIMER     = 3163
let DCP104_POWER_CFG_WARNINGTIMER   = 3164
let DCP104_POWER_CFG_SHUTOFFTIMER   = 3165

let DCP105_POWER_CFG_OVERRIDEVAL    = 3209
let DCP105_POWER_CFG_STARTSP        = 3210
let DCP105_POWER_CFG_WARNINGSP      = 3211
let DCP105_POWER_CFG_SHUTOFFSP      = 3212
let DCP105_POWER_CFG_STARTTIMER     = 3213
let DCP105_POWER_CFG_WARNINGTIMER   = 3214
let DCP105_POWER_CFG_SHUTOFFTIMER   = 3215





public struct DC_POWER_VALUES{
    
    var outOfRange           = 0
    var scalingFault         = 0
    var sensorFault          = 0
    var hihighTemp           = 0
    var eStop                = 0
    var faulted              = 0
    var inAuto               = 0
    var inHand               = 0
    var warningHighTemp      = 0
    var coolingFanOn         = 0
    var pwrOn                = 0
    var pwrEnabled           = 0
    
    var scaledValue       = 0
    var precision         = 0
    
    var cfg_scaleMin         = 0
    var cfg_scaleMax         = 0
    var cfg_iPadOverrideVal  = 0
    var cfg_tempStartSP      = 0
    var cfg_tempWarningSP    = 0
    var cfg_tempShutOffSP    = 0
    var cfg_tempStartTimer   = 0
    var cfg_tempWarningTimer = 0
    var cfg_tempShutOffTimer = 0
    
    var cmd_HandMode = 0
    var cmd_HandStartStop = 0
    var cmd_pwrDisable = 0
    var cmd_pwrFrceOn = 0
    var cmd_pwrFaultReset = 0
}

let BLOSSOM_PLUME_MAX_SP = (startAddr: 1006, count: 12)
let BLOSSOM_DELAYTIMERS  = (startAddr: 8511, count: 7)

let BLOSSOM_PSL10034_WARNING_TIMER = 8511
let BLOSSOM_PSL10056_WARNING_TIMER = 8512
let BLOSSOM_PSL1003_FAULT_TIMER    = 8514
let BLOSSOM_PSL1004_FAULT_TIMER    = 8515
let BLOSSOM_PSL1005_FAULT_TIMER    = 8516
let BLOSSOM_PSL1006_FAULT_TIMER    = 8517

public struct VFD_VALUES{
    
    var vfdReady = 0
    var vfdRunning = 0
    var pumpFaulted = 0
    var pumpWarning = 0
    var inHandMode = 0
    var inOffMode = 0
    var inAutoMode = 0
    var filtrationControlMode = 0
    var showControlMode = 0
    var schedulerControlMode = 0
    var plcControlMode = 0
    var vfdWarning = 0
    var strainerWarning = 0
    var notInAutoWarning = 0
    
    var cmd_setVFDHandMode = 0
    var cmd_setVFDOffMode = 0
    var cmd_setVFDAutoMode = 0
    var cmd_setVFDHandStart = 0
    var cmd_setVFDHandStop = 0
    var cmd_setVFDWarningReset = 0
    var cmd_setVFDFaultReset = 0
    var cmd_enableAutoReset = 0
    
    var fault_EStop = 0
    var fault_Network = 0
    var fault_VFDActive = 0
    var fault_lowWaterLevel = 0
    var fault_lowPressure = 0
    var fault_GFCITripped = 0
    var fault_FailToRunAlarm = 0
    
    var vfdState_ReadytoSwitchOn = 0
    var vfdState_SwitchOnReadytoRun = 0
    var vfdState_Running = 0
    var vfdState_FaultActive = 0
    var vfdState_MainVltgEnabled = 0
    var vfdState_QuickStop = 0
    var vfdState_SwitchedONDisabled = 0
    var vfdState_WarningActive = 0
    
    var status_Frequency = 0
    var status_OutputFrequency = 0
    var status_OutputVoltage = 0
    var status_OutputCurrent = 0
    var status_OutputMotorPwr = 0
    var status_OutputTemperature = 0
    var status_frequencyShowDataSP = 0
    var status_frequencyPLCDataSP = 0
    
    var cfg_frequencySP = 0
    var cfg_frequencyBWSP = 0
    var cfg_failToRunDelayTimer = 0
    
}

var VFD_101_DATAREGISTER = (startAddr: 1050, count: 19)

var VFD_103_DATAREGISTER = (startAddr: 1100, count: 19)
var VFD_104_DATAREGISTER = (startAddr: 1150, count: 19)
var VFD_105_DATAREGISTER = (startAddr: 1200, count: 19)
var VFD_106_DATAREGISTER = (startAddr: 1250, count: 19)

var VFD_107_DATAREGISTER = (startAddr: 1300, count: 19)
var VFD_108_DATAREGISTER = (startAddr: 1350, count: 19)
var VFD_109_DATAREGISTER = (startAddr: 1400, count: 19)

var VFD101_CMD_REG = (setHand:1050, setOff:1051, setAuto:1052, setHandStart:1053, setHandStop:1054, faultReset:1055, warningReset:1056, enableAutoReset:1057, setFreqSP:1066)
var VFD103_CMD_REG = (setHand:1100, setOff:1101, setAuto:1102, setHandStart:1103, setHandStop:1104, faultReset:1105, warningReset:1106, enableAutoReset:1107, setFreqSP:1116)
var VFD104_CMD_REG = (setHand:1150, setOff:1151, setAuto:1152, setHandStart:1153, setHandStop:1154, faultReset:1155, warningReset:1156, enableAutoReset:1157, setFreqSP:1166)
var VFD105_CMD_REG = (setHand:1200, setOff:1201, setAuto:1202, setHandStart:1203, setHandStop:1204, faultReset:1205, warningReset:1206, enableAutoReset:1207, setFreqSP:1216)
var VFD106_CMD_REG = (setHand:1250, setOff:1251, setAuto:1252, setHandStart:1253, setHandStop:1254, faultReset:1255, warningReset:1256, enableAutoReset:1257, setFreqSP:1266)
var VFD107_CMD_REG = (setHand:1300, setOff:1301, setAuto:1302, setHandStart:1303, setHandStop:1304, faultReset:1305, warningReset:1306, enableAutoReset:1307, setFreqSP:1316)
var VFD108_CMD_REG = (setHand:1350, setOff:1351, setAuto:1352, setHandStart:1353, setHandStop:1354, faultReset:1355, warningReset:1356, enableAutoReset:1357, setFreqSP:1366)
var VFD109_CMD_REG = (setHand:1400, setOff:1401, setAuto:1402, setHandStart:1403, setHandStop:1404, faultReset:1405, warningReset:1406, enableAutoReset:1407, setFreqSP:1416)

var VFD101_CFG_DELAYTIMER = 1068
var VFD103_CFG_DELAYTIMER = 1018
var VFD104_CFG_DELAYTIMER = 1168
var VFD105_CFG_DELAYTIMER = 1218
var VFD106_CFG_DELAYTIMER = 1268
var VFD107_CFG_DELAYTIMER = 1318
var VFD108_CFG_DELAYTIMER = 1368
var VFD109_CFG_DELAYTIMER = 1418

