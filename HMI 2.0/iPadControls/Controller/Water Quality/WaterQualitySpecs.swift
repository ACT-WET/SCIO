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

var pH_CMD_REG = (overrideCmd:400, frcHiCmd:401, frceLwCmd:402, overrideSP:409, abvHHSP:410, abvHSP:411, blwLSP:412, blwLLSP:413, blwLLLSP:414, abvHHTimer:415, abvHTimer:416, blwLTimer:417, blwLLTimer:418, blwLLLTimer: 419)
var ORP_CMD_REG = (overrideCmd:425, frcHiCmd:426, frceLwCmd:427, overrideSP:434, abvHHSP:435, abvHSP:436, blwLSP:437, blwLLSP:438, blwLLLSP:439, abvHHTimer:440, abvHTimer:441, blwLTimer:442, blwLLTimer:443, blwLLLTimer: 444)
var CONDUCTIVITY_CMD_REG = (overrideCmd:450, frcHiCmd:451, frceLwCmd:452, overrideSP:459, abvHHSP:460, abvHSP:461, blwLSP:462, blwLLSP:463, blwLLLSP:464, abvHHTimer:465, abvHTimer:466, blwLTimer:467, blwLLTimer:468, blwLLLTimer: 469)
var BR_CMD_REG = (overrideCmd:475, frcHiCmd:476, frceLwCmd:477, overrideSP:484, abvHHSP:485, abvHSP:486, blwLSP:487, blwLLSP:488, blwLLLSP:489, abvHHTimer:490, abvHTimer:491, blwLTimer:492, blwLLTimer:493, blwLLLTimer: 494)
var AT1001_CMD_REG = (overrideCmd:500, frcHiCmd:501, frceLwCmd:502, overrideSP:509, abvHHSP:510, abvHSP:511, blwLSP:512, blwLLSP:513, blwLLLSP:514, abvHHTimer:515, abvHTimer:516, blwLTimer:517, blwLLTimer:518, blwLLLTimer: 519)
var TT1002_CMD_REG = (overrideCmd:525, frcHiCmd:526, frceLwCmd:527, overrideSP:534, abvHHSP:535, abvHSP:536, blwLSP:537, blwLLSP:538, blwLLLSP:539, abvHHTimer:540, abvHTimer:541, blwLTimer:542, blwLLTimer:543, blwLLLTimer: 544)
var TT1003_CMD_REG = (overrideCmd:550, frcHiCmd:551, frceLwCmd:552, overrideSP:559, abvHHSP:560, abvHSP:561, blwLSP:562, blwLLSP:563, blwLLLSP:564, abvHHTimer:565, abvHTimer:566, blwLTimer:567, blwLLTimer:568, blwLLLTimer: 569)

var FREEZE_VALVE_CMD_REG = (setHandMode:600, setHandCmd:601, cmdDisableValve:602, cmdFrcOpen:603, cmdFaultReset:604, failToOperateTimer:604)
var BR_VALVE_CMD_REG = (setHandMode:575, setHandStartCmd:576, setHandStopCmd:577, cmdDisableValve:578, cmdFrcOpen:579, cmdWarningReset:580, startSP:580, stopSP:581, startTimer:582, stopTimer:583, vlveOpen:584, vlveClose:585, dosingTimeout:586)

public struct BR_VALUES{
    
    var brEnabled          = 0
    var brDosing           = 0
    var startCmdActive     = 0
    var stopCmdActive      = 0
    var brTimeout          = 0
    var inAuto             = 0
    var inHand             = 0
    var valveStatus        = 0
    
    var status_orpScaledVal = 0
    
    var cfg_dosingTimeoutDelayTimer   = 0
    var cfg_valveOpenDelayTimer   = 0
    var cfg_valveCloseDelayTimer   = 0
    var cfg_startDosingDelayTimer   = 0
    var cfg_stopDosingDelayTimer   = 0
    var cfg_stopDosingSP   = 0
    var cfg_startDosingSP   = 0
    
    
    var cmd_HandMode = 0
    var cmd_HandStar = 0
    var cmd_HandStop = 0
    var cmd_valveDisable = 0
    var cmd_valveFrceOpen = 0
    var cmd_valveWarningReset = 0
}
