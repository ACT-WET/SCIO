//
//  FogSpecs.swift
//  iPadControls
//
//  Created by Jan Manalo on 9/10/18.
//  Copyright © 2018 WET. All rights reserved.
//

import Foundation

/***************************************************************************
 * Section  :  FOG SPECS
 * Comments :  Use this file to change and write the correct address
 ***************************************************************************/

public struct FOG_MOTOR_SENSOR_VALUES{
    
    var failToClose          = 0
    var failToOpen           = 0
    var autoCmdActive        = 0
    var handCmdActive        = 0
    var eStop                = 0
    var faulted              = 0
    var inAuto               = 0
    var inHand               = 0
    var valveOpen            = 0
    var valveClose           = 0
    var valveTransition      = 0
    var valveEnabled         = 0
    
    var failToOperateDelayTimer   = 0
    
    var cmd_HandMode = 0
    var cmd_HandStartStop = 0
    var cmd_valveDisable = 0
    var cmd_valveFrceOpen = 0
    var cmd_valveFaultReset = 0
}
public struct FOG_SYSTEM_SENSOR_VALUES{
    
    var systemARunning       = 0
    var systemLRunning       = 0
    var systemBRunning       = 0
    var systemAFaulted       = 0
    var systemLFaulted       = 0
    var systemBFaulted       = 0
    var systemARingOpen      = 0
    var systemLRingOpen      = 0
    var systemBRingOpen      = 0
    var systemAPlumeOpen     = 0
    var systemLPlumeOpen     = 0
    var systemBPlumeOpen     = 0
}


let FOGRING_YV1583_L                         = (startAddr: 1500, count: 5)
let FOGPLUME_YV1585_L                        = (startAddr: 1520, count: 5)

let FOGRING_YV1580_A                         = (startAddr: 1540, count: 5)
let FOGPLUME_YV1582_A                        = (startAddr: 1560, count: 5)

let FOGRING_YV1587_B                         = (startAddr: 1580, count: 5)
let FOGPLUME_YV1589_B                        = (startAddr: 1600, count: 5)

let FOGSYSTEM_DATA                           = (startAddr: 1040, count: 1)

let FOGRING_YV1583_L_CMD_HANDMODE = 1500
let FOGRING_YV1583_L_CMD_HANDCMD = 1501
let FOGRING_YV1583_L_CMD_iPAD_DISABLE = 1502
let FOGRING_YV1583_L_CMD_iPAD_FORCEOPEN = 1503
let FOGRING_YV1583_L_CMD_FAULTRESET = 1504

let FOGPLUME_YV1585_L_CMD_HANDMODE = 1520
let FOGPLUME_YV1585_L_CMD_HANDCMD = 1521
let FOGPLUME_YV1585_L_CMD_iPAD_DISABLE = 1522
let FOGPLUME_YV1585_L_CMD_iPAD_FORCEOPEN = 1523
let FOGPLUME_YV1585_L_CMD_FAULTRESET = 1524

let FOGRING_YV1580_A_CMD_HANDMODE = 1540
let FOGRING_YV1580_A_CMD_HANDCMD = 1541
let FOGRING_YV1580_A_CMD_iPAD_DISABLE = 1542
let FOGRING_YV1580_A_CMD_iPAD_FORCEOPEN = 1543
let FOGRING_YV1580_A_CMD_FAULTRESET = 1544

let FOGPLUME_YV1582_A_CMD_HANDMODE = 1560
let FOGPLUME_YV1582_A_CMD_HANDCMD = 1561
let FOGPLUME_YV1582_A_CMD_iPAD_DISABLE = 1562
let FOGPLUME_YV1582_A_CMD_iPAD_FORCEOPEN = 1563
let FOGPLUME_YV1582_A_CMD_FAULTRESET = 1564

let FOGRING_YV1587_B_CMD_HANDMODE = 1580
let FOGRING_YV1587_B_CMD_HANDCMD = 1581
let FOGRING_YV1587_B_CMD_iPAD_DISABLE = 1582
let FOGRING_YV1587_B_CMD_iPAD_FORCEOPEN = 1583
let FOGRING_YV1587_B_CMD_FAULTRESET = 1584

let FOGPLUME_YV1589_B_CMD_HANDMODE = 1600
let FOGPLUME_YV1589_B_CMD_HANDCMD = 1601
let FOGPLUME_YV1589_B_CMD_iPAD_DISABLE = 1602
let FOGPLUME_YV1589_B_CMD_iPAD_FORCEOPEN = 1603
let FOGPLUME_YV1589_B_CMD_FAULTRESET = 1604

let RING_L_DELAYTIMER                 = 1504
let RING_A_DELAYTIMER                 = 1544
let RING_B_DELAYTIMER                 = 1584

let PLUME_L_DELAYTIMER                = 1524
let PLUME_A_DELAYTIMER                = 1564
let PLUME_B_DELAYTIMER                = 1604

