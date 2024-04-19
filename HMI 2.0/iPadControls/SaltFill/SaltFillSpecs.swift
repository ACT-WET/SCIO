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

struct SALTFILL_STATS {
    var fillStatus = 0
    var fillTimeout = 0
    var ltScaledValue = 0.0
    var ptScaledValue = 0.0
    var fill2Status = 0
    var fill2Timeout = 0
    var lt2ScaledValue = 0.0
    var pt2ScaledValue = 0.0
}


let TANK1_SALT_STATUS = 5000
let TANK1_SCALEDVALUE_STATUS = 5000
let TANK1_PTSCALEDVALUE_STATUS = 5120


let TANK2_SALT_STATUS = 5020
let TANK2_SCALEDVALUE_STATUS = 5020
let TANK2_PTSCALEDVALUE_STATUS = 5140


let TANK3_SALT_STATUS = 5040
let TANK3_SCALEDVALUE_STATUS = 5040
let TANK3_PTSCALEDVALUE_STATUS = 5160


let TANK4_SALT_STATUS = 5060
let TANK4_SCALEDVALUE_STATUS = 5060
let TANK4_PTSCALEDVALUE_STATUS = 5180


let TANK5_SALT_STATUS = 5080
let TANK5_SCALEDVALUE_STATUS = 5080
let TANK5_PTSCALEDVALUE_STATUS = 5200


let TANK6_SALT_STATUS = 5100
let TANK6_SCALEDVALUE_STATUS = 5100
let TANK6_PTSCALEDVALUE_STATUS = 5220

let LT1_SCALEDMAX = 5004
let LT1_SCALEDMIN = 5002
let LT1_ABVH = 5012
let LT1_BLWL = 5010
let PT1_SCALEDMAX = 5124
let PT1_SCALEDMIN = 5122
let PT1_ABVH = 5132
let PT1_BLWL = 5130

let SALT_FILLABVH_TIMER = 6532
let SALT_FILLBLWL_TIMER = 6533
let SALT_FILLTIMEOUT_TIMER = 6534

let EOD_TOGGLE_PURGE_BIT = 5230
let BOD_TOGGLE_PURGE_BIT = 5231
let ZS401_VLV_OPENCMD = 6085
let ZS401_VLV_STATUS = 6095
let EOD_RUNSTATUS = 5232
let BOD_RUNSTATUS = 5233
let PURGE_ONSP = 5236
let PURGE_OFFSP = 5238
let PURGEVALVE_TIMER = 5234

let ZS401_SALTVLV_OPENCMD = 6120
let ZS401_SALTVLV_STATUS = 6130
