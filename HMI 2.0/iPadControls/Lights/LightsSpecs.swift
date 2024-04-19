//
//  LightsSpecs.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 9/6/18.
//  Copyright © 2018 WET. All rights reserved.
//

import Foundation


/***************************************************************************
 * Section  :  LIGHTS SPECS
 * Comments :  Use this file to change and write the correct address
 * Note     :  Double check if the read and write server path is correct
 ***************************************************************************/


let LIGHTS_AUTO_HAND_PLC_REGISTER              = (register: 3520,type:"EBOOL", name: "Lights_Auto_Man_mode")
let LIGHTS_STATUS                              = (register: 3503,type:"EBOOL", count: 1)
let LIGHTS_ON_OFF_WRITE_REGISTERS              = [3502]
let LIGHTS_DAY_MODE_BTN_UI_TAG_NUMBER          = 15
let SET_DAY_MODE_CMD                        = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/setDayMode?1"
let DISABLE_DAY_MODE_CMD                        = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/setDayMode?0"
let DAY_MODE_BUTTON_TAG                        = 6
let READ_LIGHT_SERVER_PATH                     = "readLights"
let WRITE_LIGHT_SERVER_PATH                    = "writeLights"

