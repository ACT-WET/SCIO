//
//  WaterLevelSpecs.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 4/25/24.
//  Copyright © 2024 WET. All rights reserved.
//

import Foundation

//=============== Water Level Specs

public struct WATER_LEVEL_SENSOR_VALUES{
    
    var scaledValue          = 0.0
    var below_l              = 0
    var below_ll             = 0
    var below_lll            = 0
    var above_High           = 0
    var above_HiHigh         = 0
    var malfunction          = 0
    var waterMakeupTimeout   = 0
    var eStop                = 0
    var faulted              = 0
    var inAuto               = 0
    var inHand               = 0
    var valveOpen            = 0
    var valveEnabled         = 0
    var startCmdActive       = 0
    var stopCmdActive        = 0
    
    var above_hihigh_timer   = 0
    var above_high_timer     = 0
    var below_l_timer        = 0
    var below_ll_timer       = 0
    var below_lll_timer      = 0
    var makeup_timeout_timer = 0
    
    var cmd_HandMode = 0
    var cmd_HandStart = 0
    var cmd_HandStop = 0
    var cmd_disableMkeup = 0
    var cmd_overrideFrceDosing = 0
    var cmd_deviceFaultReset = 0
    
    var scaledMin          = 0.0
    var scaledMax          = 0.0
    var aboveHiHighSP      = 0.0
    var aboveHighSP        = 0.0
    var belowlSP           = 0.0
    var belowllSP          = 0.0
    var belowlllSP         = 0.0
   
}

let WATER_LEVEL_SETTINGS_SCREEN_SEGUE          = "waterLevelSettings"
let WATER_LEVEL_LANGUAGE_DATA_PARAM            = "waterLevel"

let WATER_LEVEL_SLIDER_HEIGHT                  = 450.0
let WATER_LEVEL_SLIDER_LOWER_COORDINATE        = 650.0
let WATER_LEVEL_SLIDER_UPPER_COORDINATE        = 200.0

let BASIN_LEVEL_WATER_SENSOR                   = (startBit : 700,  count: 5)
let WATER_LEVEL_LV1001                         = (startAddr: 720, count: 5)
let WATER_LEVEL_TIMER_BITS                     = (startBit : 8500,  count: 4)

let WATER_LEVEL_ABOVE_H_DELAY_TIMER            = 8500
let WATER_LEVEL_BELOW_L_TIMER                  = 8501
let WATER_LEVEL_BELOW_LL_TIMER                 = 8502
let WATER_LEVEL_BELOW_LLL_TIMER                = 8503
let WATER_MAKEUP_TIMEROUT_TIMER                = 724

let CMD_HANDMODE = 720
let CMD_HANDSTART = 721
let CMD_HANDSTOP = 722
let CMD_iPAD_DISABLE = 723
let CMD_iPAD_DOSING = 724
let CMD_FAULTRESET = 725



