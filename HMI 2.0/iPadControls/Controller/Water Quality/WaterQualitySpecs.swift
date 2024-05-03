//
//  WaterQualitySpecs.swift
//  iPadControls
//
//  Created by Jan Manalo on 9/18/18.
//  Copyright © 2018 WET. All rights reserved.
//

import Foundation

public struct AI_VALUES{
    
    var status_abvHH = 0
    var status_abvH = 0
    var status_blwL = 0
    var status_blwLL = 0
    var status_blwLLL = 0
    var status_faulted = 0
    var status_channelFault = 0
    var status_scalingFault = 0
    var status_outOFRangeFault = 0
    
    var cmd_iPadOverride = 0
    var cmd_frceHigh = 0
    var cmd_frceLow = 0
    
    var status_ScaledVal = 0
    var status_precision = 0
    var status_ScaledValMax = 0
    var status_ScaledValMin = 0
    
    var cfg_overrideValSP = 0
    var cfg_abvHHSP = 0
    var cfg_abvHSP = 0
    var cfg_blwLSP = 0
    var cfg_blwLLSP = 0
    var cfg_blwLLLSP = 0
    var cfg_abvHHTimer = 0
    var cfg_abvHTimer = 0
    var cfg_blwLTimer = 0
    var cfg_blwLLTimer = 0
    var cfg_blwLLLTimer = 0
    
}

var pH_SENSOR_DATAREGISTER           = (startAddr: 400, count: 20)
var ORP_SENSOR_DATAREGISTER          = (startAddr: 425, count: 20)
var CONDUCTIVITY_SENSOR_DATAREGISTER = (startAddr: 450, count: 20)
var BR_SENSOR_DATAREGISTER           = (startAddr: 475, count: 20)
var AT1001_TEMP_DATAREGISTER         = (startAddr: 500, count: 20)
var TT1002_TEMP_DATAREGISTER         = (startAddr: 525, count: 20)
var TT1003_TEMP_DATAREGISTER         = (startAddr: 550, count: 20)

var BR_VALVE_DATAREGISTER            = (startAddr: 575, count: 20)
var FREEZE_VALVE_DATAREGISTER        = (startAddr: 600, count: 20)
