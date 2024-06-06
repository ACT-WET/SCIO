//
//  HomeGeneralSpecs.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 9/10/18.
//  Copyright © 2018 WET. All rights reserved.
//


import Foundation

/***************************************************************************
 * Section  :  UI COLORS
 * Comments :  SET DEFAULT colors we can use
 ***************************************************************************/

let GREEN_COLOR                    = UIColor(red:130.0/255.0, green:190.0/255.0, blue:0.0/255.0, alpha:1.0)
let RED_COLOR                      = UIColor(red:235.0/255.0, green:30.0/255.0, blue:35.0/255.0, alpha:1.0)
let DEFAULT_GRAY                   = UIColor(red:200.0/255.0, green:200.0/255.0, blue: 200.0/255.0, alpha:1.0)
let BABY_BLUE_COLOR                = UIColor(red:0/255.0, green:166.0/255.0, blue:255.0/255.0, alpha:1.0)
let HELP_SCREEN_GRAY               = UIColor(red:150/255, green: 150/255, blue: 150/255, alpha: 1.0)
let PICKER_VIEW_BG_COLOR           = UIColor(red:60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1.0)
let ORANGE_COLOR                   = UIColor(red:255.0/255.0, green:140.0/255.0, blue:0.0/255.0, alpha:1.0)
let WEEKEND_SELECTED_COLOR         = UIColor(red:0/255.0, green:170.0/255.0, blue:255.0/255.0, alpha: 1.0)
let YELLOW_COLOR                   = UIColor(red:255.0/255.0, green:251.0/255.0, blue: 0.0/255.0, alpha:1.0)


/***************************************************************************
 * Section  : CONNECTION ERROR TEXTS
 * Comments :  Show's up when ipad cannot connect to server nor plc
 ***************************************************************************/


let ERROR_PLC_COMM_FAILED                      = "PLC CONNECTION FAILED"
let ERROR_SERVER_COMM_FAILED                   = "SERVER CONNECTION FAILED"
let ERROR_PLC_AND_SERVER_COMM_FAILED           = "PLC AND SERVER CONNECTION FAILED"
var setUDForConnection            = false

/***************************************************************************
 * Section  : SYSTEM NETWORK SPECS
 * Comments : Always double check if the addresses & port are correct
 ***************************************************************************/

//Testing Only
let PLC_IP_ADDRESS                 = "10.0.4.230"//"192.168.1.230"
let SERVER_IP_ADDRESS              = "10.0.4.200"//"192.168.1.1"
let SPM_IP_ADDRESS                 = "10.0.4.200"//"192.168.1.201"

//let PLC_IP_ADDRESS                 = "192.168.1.230"
//let SERVER_IP_ADDRESS              = "192.168.1.1"
//let SPM_IP_ADDRESS                 = "192.168.1.201"
let PLC_PORT:Int32                 = 502


/***************************************************************************
 * Section  : SERVER HTTP PATHS
 * Comments : These paths are used to connect to the server. Path may be written differently always check with Kranti
              This is also used to sync the time from the ipad to the server
 ***************************************************************************/

let HTTP_PASS                       = "http://wet_act:A3139gg1121@"
let READ_PLAYLIST_PATH             = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/readPlaylists"
let READ_SHOWS_PATH                = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/readShows"
let ERROR_LOG_FTP_PATH             = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/readErrorLog"
let STATUS_LOG_FTP_PATH            = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/readStatusLog"
let READ_SHOW_PLAY_STAT            = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/readplayStatus"
let READ_TIME_TABLE                = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/readTimeTable"
let RESET_TIME_LAST_COMMAND        = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/setTimeLastCmnd"
let SERVER_TIME_PATH               = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/readServerTime"
let READ_AUTOMAN_PATH              = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/autoMan"
let PRESSURE_LIVE_SERVER_PATH      = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/readPressure_Live"
let PRESSURE_DAY_SERVER_PATH       = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/readPressure_Day"
let WEIR_PUMP_SERVER_PATH          = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/readBasinPumpSch"
let LIGHTS_SERVER_PATH             = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/readLights"
let SYS_CLEAR_LOGPATH             = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/clearLogClient"
let GET_FILLER_SHOW_STATE_HTTP_PATH  = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/readFillerShow"
let SET_FILLER_SHOW_STATE_HTTP_PATH  = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/writeFillerShow"
let READ_SHOW_STOPPER_FAULTS_SERVER_PATH = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/readFaultsAll"
let GET_DROUGHTMODE_HTTP_PATH            = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/readDroughtMode"
let SET_DROUGHTMODE_HTTP_PATH            = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/writeDroughtMode"
let SYS_STATUS_LOGPATH             = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/readLogClient"
let READ_SHOWSCAN_STATUS           = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/showScannerStatus"
let READ_PROJ_TEMP            = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/readPrjTempData"
let WRITE_PJ_CMD           = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/sendMirrCmd?"
let WRITE_SHW_CMD           = "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/readShowList?"
let MCRX_HTTP_PASS          = "http://10.0.4.220/cgi/mcrx?TriggerSlot="
/***************************************************************************
 * Section  : SSH Credentials
 * Comments : Credentials to access the server
 ***************************************************************************/

let SSH_HOST_IP_ADDRESS            = "\(SERVER_IP_ADDRESS):22"
let SSH_USER_LOGIN                 = "root"
let SSH_USER_PASSWORD              = "A3139gg1121"


/***************************************************************************
 * Section  : PLC Addresses
 * Comments : These addresses are used to sync the ipad time to the PLC
 ***************************************************************************/


let SYSTEM_TIME_SECOND_PLC_ADDR     = 106
let SYSTEM_TIME_HOUR_MINUTE         = 107
let SYSTEM_TIME_DAY_MONTH_PLC_ADDR  = 108
let SYSTEM_TIME_YEAR_PLC_ADDR       = 109
let SYSTEM_TIME_TRIGGER_PLC_ADDR    = 110

/***************************************************************************
 * Section  : SYSTEM CONNECTION STATE
 * Comments : Variable for the state. These should not change
 ***************************************************************************/

let CONNECTION_STATE_INACTIVE      = 0
let CONNECTION_STATE_CONNECTING    = 1
let CONNECTION_STATE_CONNECTED     = 2
let CONNECTION_STATE_FAILED        = 3
let CONNECTION_STATE_POOR_CONNECTION = 4
let SHOW_CONNECTING                = 50
let MAX_CONNECTION_FAULTS          = 40
let MAX_CONNECTION_FAILED          = 80

/* Data Acquisition */

let DATA_ACQUISITION_TIME_INTERVAL = 1
let DATA_ACQUISITION_STATE_SUCCESS = 1
let DATA_ACQUISITION_STATE_FAILED  = 0
let FAULT_DETECTED                 = 1  // was 0 in previous projects it would seem. Now in ARISE it is a 1.

let DIG_SHOW_STOP_REGISTER         = 58
let DCP_POWER_CYCLE_CMD            = 3300
let SET_ALL_AUTO_REGISTER          = 57
let WARNING_RESET_REGISTER         = 55
let FAULT_RESET_REGISTER           = 56
let SERVER_REBOOT_BIT              = 503
let SELECT_SERVER_BIT              = 502

/***************************************************************************
 * Section  : PLC CONVERSION
 * Comments : PLC returns this value when ever there is value of "1" as REAL number. So "1" = "5.87747e-39"
 ***************************************************************************/
let PLC_REAL_VALUE_ONE                    = "5.877472e-39"
let PLC_REAL_VALUE_ZERO                   = 5.8774717541114375e-39
let DEBUG_MODE                            = true

/***************************************************************************
 * Section  : SETTINGS SCREEN
 * Comments : Always change the four letter projectname (/act/projectname)
 ***************************************************************************/

let IPAD_NUMBER_USER_DEFAULTS_NAME = "iPadNum"
let CONTROLS_APP_UPDATE_URL        = "https://act:act@www.controlshelp.com/act/scio/index.php?"

/* To show the hidden settings click on the wet logo for more than 3 seconds, and type in the word "act"*/
let SETTINGS_ICON_TAG   = 99999
let LOGIN_BTN_INDEX     = 1
let APP_PASSWORD =      "act"
let SETTINGS_SHOW_DELAY = 3.0


/***************************************************************************
 * Section  : IPAD SCREEN ORDER
 * Comments : Always change the four letter projectname (/act/projectname)
 ***************************************************************************/

/** IMPORTANT NOTE: Based on the project, the screen names should be placed in SCREENS array accordingly.
 **       The full list of screens in correct order are:
 **
 **
 **        playlist
 **        scheduler
 **        lights
 **        temperature
 **        pumps
 **        pumpSafety
 **        wind
 **        waterQuality
 **        waterLevel
 **        cascade
 **        filtration
 **        fire
 **        intrusion
 **        operationManual
 **        fog
 **        settings
 **        showList
 **        systemStatus
 **
 **/
let READ_WEPLAY_SERVER_PATH                    = "readWeplay"
let WRITE_WEPLAY_SERVER_PATH                   = "writeWeplay"

let READ_FILLER_SERVER_PATH                    = "readFillerData"
let WRITE_FILLER_SERVER_PATH                   = "writeFillerData"

let READ_WEEKEND_WEPLAY_SERVER_PATH            = "readWWeplay"
let WRITE_WEEKEND_WEPLAY_SERVER_PATH           = "writeWWeplay"

let READ_WEEKEND_FILLER_SERVER_PATH            = "readWFillerData"
let WRITE_WEEKEND_FILLER_SERVER_PATH           = "writeWFillerData"

let SCREENS = [
    
    "playlist",
    "scheduler",
    "lights",
    "systemstatus",
    "pumps",
    "Shooters",
    "wind",
    "WQMultiple",
    "waterLevel",
    "DCPower",
    "filtration",
    "fog",
    "weplay",
    "audio",
    "operationManual",
    "settings",
    "showList",
    ""
    
];

public struct CS_DATA_VALUES{
    
    var status_progRunning       = 0
    var status_coldStart         = 0
    var status_warmStart         = 0
    var status_IOError           = 0
    var status_cycleTimeWarning  = 0
    
    var cfg_cycleWarningTimeDelayTimer   = 0
    
    var cmd_WarningLatch = 0
    var cmd_WarningReset = 0
    
    var status_CurrentCycleTime = 0
    var status_MaxCycleTime = 0
    var status_ProgramUpTimeDays = 0
    var status_ProgramUpTime = 0
    var status_ProjectVersion = 0
    var status_ProjectBuildNumber = 0
    var status_ProjectLibraryVersion = 0
    var status_ProjectBuildYear = 0
    var status_ProjectBuildDay = 0
    var status_ProjectBuildTime = 0
}
let PLC_DATA = (startAddr: 100, count: 15)
