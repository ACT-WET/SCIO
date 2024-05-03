//=================================== ABOUT ===================================

/*
 *  @FILE:          WindViewController.swift
 *  @AUTHOR:        Arpi Derm
 *  @RELEASE_DATE:  July 28, 2017, 4:13 PM
 *  @Description:   This Module reads all wind sensor data and allows to set the 
 *                  wind sensor settings and setpoints
 *  @VERSION:       2.0.0
 */

 /***************************************************************************
 *
 * PROJECT SPECIFIC CONFIGURATION
 *
 * 1 : Wind Screen screen configuration parameters located in specs.swift file
 *     should be modified
 * 2 : If multiple wind sensors, the readings and data declerations need to be coppied
 ***************************************************************************/

import UIKit

class WindViewController: UIViewController{

        @IBOutlet weak var windStat: UIImageView!
        @IBOutlet weak var noConnectionView: UIView!
        @IBOutlet weak var noConnectionErrorLbl: UILabel!

        //MARK: - Class Reference Objects -- Dependencies
        
        private let logger = Logger()
        private let helper = Helper()
        
        //MARK: - Data Structures
        
        private var langData = Dictionary<String, String>()
        private var wind_sensor_1   = WEATHER_SYSTEM_SENSOR_VALUES()  //If there are more wind sensors, this variable needs to be duplicated and number incremented
        
        private var sensorNumber    = 0
        private var counter         = 0
        private var aboveHigh       = 0
        private var belowLow        = 0
        var windId = 0
        private var windChannelFaults: [Int] = []

        /***************************************************************************
         * Function :  viewDidLoad
         * Input    :  none
         * Output   :  none
         * Comment  :
         ***************************************************************************/

        override func viewDidLoad(){
            
            super.viewDidLoad()
       
        }
        
        /***************************************************************************
         * Function :  viewWillAppear
         * Input    :  none
         * Output   :  none
         * Comment  :
         ***************************************************************************/

        override func viewWillAppear(_ animated: Bool){
            //Get Wind Parameters From Local Storage
            
            NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
            //Add notification observer to get system stat

        }
        
        /***************************************************************************
         * Function :  viewWillDisappear
         * Input    :  none
         * Output   :  none
         * Comment  :
         ***************************************************************************/

        override func viewWillDisappear(_ animated: Bool){
            
            NotificationCenter.default.removeObserver(self)
            
        }


        /***************************************************************************
         * Function :  checkSystemStat
         * Input    :  none
         * Output   :  none
         * Comment  :
         ***************************************************************************/
        
        @objc func checkSystemStat(){
            let (plcConnection,_) = (CENTRAL_SYSTEM?.getConnectivityStat())!
            
            if plcConnection == CONNECTION_STATE_CONNECTED {
                //Change the connection stat indicator
                noConnectionView.alpha = 0
                noConnectionView.isUserInteractionEnabled = false
                
                //Now that the connection is established, run functions
                readWindSensorData()
                
            } else {
                noConnectionView.alpha = 1
                if plcConnection == CONNECTION_STATE_FAILED {
                    noConnectionErrorLbl.text = "PLC CONNECTION FAILED, SERVER GOOD"
                } else if plcConnection == CONNECTION_STATE_CONNECTING {
                    noConnectionErrorLbl.text = "CONNECTING TO PLC, SERVER CONNECTED"
                } else if plcConnection == CONNECTION_STATE_POOR_CONNECTION {
                    noConnectionErrorLbl.text = "PLC POOR CONNECTION, SERVER CONNECTED"
                }
            }
        }
        /***************************************************************************
         * Function :  setWindSpeedUnitOfMeasure
         * Input    :  metric yes/no, ui label tag
         * Output   :  none
         * Comment  :
         ***************************************************************************/

        private func setWindSpeedUnitOfMeasure(metric:Bool,labelTag:Int){
        
            let sensorMetricLbl = self.view.viewWithTag(labelTag) as! UILabel

            if metric == true{
                
                sensorMetricLbl.text = "KM/H"
                
            }else{
                
                sensorMetricLbl.text = "MPH"

            }
            
        }
        
        /***************************************************************************
         * Function :  enableDisableSetPoints
         * Input    :  none
         * Output   :  none
         * Comment  :
         ***************************************************************************/

        private func enableDisableSetPoints(setPointEnabled:Bool,buttonTag:Int){
            
            let setPointButton = self.view.viewWithTag(buttonTag) as! UIButton
            
            if setPointEnabled == true{
                
                setPointButton.isHidden = false
                
            }else{
                
                setPointButton.isHidden = true
                
            }
            
        }
        
        /***************************************************************************
         * Function :  readWindSensorData
         * Input    :  none
         * Output   :  none
         * Comment  :  read all wind sensor speed data
         ***************************************************************************/
        
        private func readWindSensorData(){
                
            CENTRAL_SYSTEM?.readRegister(length: Int32(WEATHER_SYSTEM_DATA.count), startingRegister: Int32(WEATHER_SYSTEM_DATA.startAddr), completion:{ (success, response) in
                    
                   guard success == true else { return }
                
                   self.wind_sensor_1.measuredSpeed = Int(truncating: response![0] as! NSNumber)
                   self.wind_sensor_1.correctedSpeed = Int(truncating: response![1] as! NSNumber)
                   self.wind_sensor_1.measuredDirection = Int(truncating: response![2] as! NSNumber)
                   self.wind_sensor_1.correctedDirection = Int(truncating: response![3] as! NSNumber)
                   self.wind_sensor_1.temperatureinC = Int(truncating: response![4] as! NSNumber)
                   self.wind_sensor_1.temperatureinF = Int(truncating: response![5] as! NSNumber)
                   self.wind_sensor_1.dewPointinC = Int(truncating: response![6] as! NSNumber)
                   self.wind_sensor_1.dewPointinF = Int(truncating: response![7] as! NSNumber)
                   self.wind_sensor_1.precipitation = Int(truncating: response![8] as! NSNumber)
                   self.wind_sensor_1.precipIntensity = Int(truncating: response![9] as! NSNumber)
                   self.wind_sensor_1.atmosPressure = Int(truncating: response![10] as! NSNumber)
                   self.wind_sensor_1.humidity = Int(truncating: response![11] as! NSNumber)
                   self.wind_sensor_1.solarRadiation = Int(truncating: response![12] as! NSNumber)
                   self.wind_sensor_1.gpsLatitude = Int(truncating: response![13] as! NSNumber)
                   self.wind_sensor_1.gpsLogitude = Int(truncating: response![14] as! NSNumber)
                   self.wind_sensor_1.gpsHeightAbvSea = Int(truncating: response![15] as! NSNumber)
                
                   self.readWindDirection(response: self.wind_sensor_1.correctedDirection, directionTag: 104)
                
                   let speed = self.view.viewWithTag(1) as? UILabel
                   let tempC = self.view.viewWithTag(2) as? UILabel
                   let tempF = self.view.viewWithTag(3) as? UILabel
                   let dewC = self.view.viewWithTag(4) as? UILabel
                   let dewF = self.view.viewWithTag(5) as? UILabel
                   let precip = self.view.viewWithTag(6) as? UILabel
                   let precipInt = self.view.viewWithTag(7) as? UILabel
                   let atmos = self.view.viewWithTag(8) as? UILabel
                   let humid = self.view.viewWithTag(9) as? UILabel
                   let solar = self.view.viewWithTag(10) as? UILabel
                   let gpsLat = self.view.viewWithTag(11) as? UILabel
                   let gpsLong = self.view.viewWithTag(12) as? UILabel
                   let gpsHeight = self.view.viewWithTag(13) as? UILabel
                 
                   speed?.text = String(format: "%.1f", Float(self.wind_sensor_1.measuredSpeed)/10.0)
                   tempC?.text = String(format: "%.1f", Float(self.wind_sensor_1.temperatureinC)/10.0)
                   tempF?.text = String(format: "%.1f", Float(self.wind_sensor_1.temperatureinF)/10.0)
                   dewC?.text = String(format: "%.1f", Float(self.wind_sensor_1.dewPointinC)/10.0)
                   dewF?.text = String(format: "%.1f", Float(self.wind_sensor_1.dewPointinF)/10.0)
                   precip?.text = String(format: "%.1f", Float(self.wind_sensor_1.precipitation)/10.0)
                   precipInt?.text = String(format: "%.1f", Float(self.wind_sensor_1.precipIntensity)/10.0)
                   atmos?.text = String(format: "%.1f", Float(self.wind_sensor_1.atmosPressure)/10.0)
                   humid?.text = String(format: "%.1f", Float(self.wind_sensor_1.humidity)/10.0)
                   solar?.text = String(format: "%.1f", Float(self.wind_sensor_1.solarRadiation)/10.0)
                   gpsLat?.text = String(format: "%.1f", Float(self.wind_sensor_1.gpsLatitude)/10.0)
                   gpsLong?.text = String(format: "%.1f", Float(self.wind_sensor_1.gpsLogitude)/10.0)
                   gpsHeight?.text = String(format: "%.1f", Float(self.wind_sensor_1.gpsHeightAbvSea)/10.0)
            })
            
        }
        
        /***************************************************************************
         * Function :  changeWindSpeedColor
         * Input    :  none
         * Output   :  none
         * Comment  :  Change the wind speed indicator color based on current value
         ***************************************************************************/
        
        private func changeWindSpeedColor(labelTag:Int){
            
            let windSpeedLbl = self.view.viewWithTag(labelTag) as! UILabel

            if self.aboveHigh == 1{
                windSpeedLbl.textColor = RED_COLOR
            }else if self.belowLow == 1 {
                windSpeedLbl.textColor = GREEN_COLOR
            }else if self.aboveHigh == 0 && self.belowLow == 0{
                windSpeedLbl.textColor = ORANGE_COLOR
            }
            
        }
        
        /***************************************************************************
         * Function :  readWindDirection
         * Input    :  direction plc address, direction ui tag
         * Output   :  none
         * Comment  :
         ***************************************************************************/

        private func readWindDirection(response:Int, directionTag:Int){
       
           //Calculate wind speed direction
           let rotationAngle = (Float(response) * 0.0174533)
       
           let directionImage = self.view.viewWithTag(directionTag) as! UIImageView
           directionImage.transform = CGAffineTransform(rotationAngle: CGFloat(rotationAngle))
        }
    
        @IBAction func showAlertSettings(_ sender: UIButton) {
            self.addAlertAction(button: sender)
        }
    }
