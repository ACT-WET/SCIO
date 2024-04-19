//
//  WeplayViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 4/15/24.
//  Copyright © 2024 WET. All rights reserved.
//

import UIKit

class TimeCell : UITableViewCell {
    @IBOutlet var startTime : UILabel?
    @IBOutlet var endTime : UILabel?
}

class fTimeCell : UITableViewCell {
    @IBOutlet var startTime : UILabel?
    @IBOutlet var endTime : UILabel?
}

class WeplayViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var scheduleView: UIView!
    @IBOutlet weak var startTimePicker: UIPickerView!
    @IBOutlet weak var endTimePicker: UIPickerView!
    @IBOutlet weak var endTimeTxt: UITextField!
    @IBOutlet weak var startTimeTxt: UITextField!
    @IBOutlet weak var weekDayTableView: UITableView!
    @IBOutlet weak var addRowView: UIView!
    
    @IBOutlet weak var fstartTimePicker: UIPickerView!
    @IBOutlet weak var fendTimePicker: UIPickerView!
    @IBOutlet weak var fendTimeTxt: UITextField!
    @IBOutlet weak var fstartTimeTxt: UITextField!
    @IBOutlet weak var fweekDayTableView: UITableView!
    @IBOutlet weak var faddRowView: UIView!
    
    @IBOutlet weak var dropDown: UIPickerView!
    @IBOutlet weak var fillerShowNumberTxt: UITextField!
    
    private let httpComm = HTTPComm()
    private let homeVC  = ACTHomeViewController()
    private var strtcomponent0AlreadySelected = false
    private var strtcomponent1AlreadySelected = false
    private var strtcomponent2AlreadySelected = false
    private var endcomponent0AlreadySelected = false
    private var endcomponent1AlreadySelected = false
    private var endcomponent2AlreadySelected = false
    
    private var fstrtcomponent0AlreadySelected = false
    private var fstrtcomponent1AlreadySelected = false
    private var fstrtcomponent2AlreadySelected = false
    private var fendcomponent0AlreadySelected = false
    private var fendcomponent1AlreadySelected = false
    private var fendcomponent2AlreadySelected = false
    
    var currentFillerShowState  = 0
    var currentFillerShowNumber = 0
    private var fillerShowStatus: Int = 0
    var showNumberRead          = 0
    private var shows: [Any]? = nil
    var list:[String] = []
    
    var weplayData:[Int] = []
    var weplayOld:[Int] = []
    var localData:[Int] = []
    var fflag = 1
    
    var fillerData:[Int] = []
    var fillerOld:[Int] = []
    var flocalData:[Int] = []
    var flag = 1
    
        
    override func viewWillAppear(_ animated: Bool){
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
        weekDayTableView.delegate = self
        weekDayTableView.dataSource = self
        self.addRowView.isHidden = true
        self.startTimePicker.isHidden = true
        self.endTimePicker.isHidden = true
        weekDayTableView.backgroundColor = UIColor(red:35/255, green: 35/255, blue: 35/255, alpha: 1.0)
        
        fweekDayTableView.delegate = self
        fweekDayTableView.dataSource = self
        self.faddRowView.isHidden = true
        self.fstartTimePicker.isHidden = true
        self.fendTimePicker.isHidden = true
        fweekDayTableView.backgroundColor = UIColor(red:35/255, green: 35/255, blue: 35/255, alpha: 1.0)
        
        dropDown.delegate = self
        dropDown.dataSource = self
        readShowFile()
        
        super.viewWillAppear(true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.localData.removeAll()
        self.flocalData.removeAll()
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func checkSystemStat(){
        let (plcConnection,_) = CENTRAL_SYSTEM!.getConnectivityStat()
        
        if plcConnection == CONNECTION_STATE_CONNECTED{
            
            //Change the connection stat indicator
            //noConnectionView.alpha = 0
            //noConnectionView.isUserInteractionEnabled = false
            weplayData = homeVC.readWeplayData()
            if localData.count == 0 {
                weplayData = homeVC.readWeplayData()
                localData = weplayData
            }
            if localData.count > 0 && flag == 1{
                weekDayTableView.reloadData()
                flag = 0
            }
            
            fillerData = homeVC.readFillerData()
            if flocalData.count == 0 {
                fillerData = homeVC.readFillerData()
                flocalData = fillerData
            }
            if flocalData.count > 0 && fflag == 1{
                fweekDayTableView.reloadData()
                fflag = 0
            }
            if weplayOld.count != weplayData.count{
                weplayOld = weplayData
                self.scheduleView.subviews.forEach({ $0.removeFromSuperview() })
                let line = UIView()
                line.frame = CGRect.init(x: 0, y: 80, width: 960 , height: 1)
                line.backgroundColor = UIColor(red:178.0/255.0, green:180.0/255.0, blue: 178.0/255.0, alpha:1.0)
                self.scheduleView.addSubview(line)
                for index in stride(from: 0, to:weplayData.count , by: 2){
                    createBlockView(start: weplayData[index], end: weplayData[index+1], tag:1)
                }
                for index in stride(from: 0, to:fillerData.count , by: 2){
                    createBlockView(start: fillerData[index], end: fillerData[index+1], tag:2)
                }
            }
            if fillerOld.count != fillerData.count{
                fillerOld = fillerData
                self.scheduleView.subviews.forEach({ $0.removeFromSuperview() })
                let line = UIView()
                line.frame = CGRect.init(x: 0, y: 80, width: 960 , height: 1)
                line.backgroundColor = UIColor(red:178.0/255.0, green:180.0/255.0, blue: 178.0/255.0, alpha:1.0)
                self.scheduleView.addSubview(line)
                for index in stride(from: 0, to:fillerData.count , by: 2){
                    createBlockView(start: fillerData[index], end: fillerData[index+1], tag:2)
                }
                for index in stride(from: 0, to:weplayData.count , by: 2){
                    createBlockView(start: weplayData[index], end: weplayData[index+1], tag:1)
                }
            }
            
            
            
        }  else {
            //noConnectionView.alpha = 1
            if plcConnection == CONNECTION_STATE_FAILED {
                //noConnectionErrLbl.text = "PLC CONNECTION FAILED, SERVER GOOD"
            } else if plcConnection == CONNECTION_STATE_CONNECTING {
                //noConnectionErrLbl.text = "CONNECTING TO PLC, SERVER CONNECTED"
            } else if plcConnection == CONNECTION_STATE_POOR_CONNECTION {
                //noConnectionErrLbl.text = "PLC POOR CONNECTION, SERVER CONNECTED"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == weekDayTableView{
            return localData.count/2
        }
        if tableView.tag == 2{
            return flocalData.count/2
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == weekDayTableView{
            if editingStyle == .delete {
              print("Deleted")
              print(localData.count)
              self.localData.remove(at: (indexPath.row * 2))
              self.localData.remove(at: (indexPath.row * 2))
              self.weekDayTableView.deleteRows(at: [indexPath], with: .automatic)
              let jsonData = try? JSONSerialization.data(withJSONObject: localData, options: .prettyPrinted)
              let jsonString = String(data: jsonData!, encoding: String.Encoding.utf8)
              let escapedDataString = jsonString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
              httpComm.httpGet(url: "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/\(WRITE_WEPLAY_SERVER_PATH)?\(escapedDataString!)") { (response, success) in
                  if success == true {
                  }
              }
              self.weekDayTableView.reloadData()
            }
        }
        if tableView == fweekDayTableView {
            if editingStyle == .delete {
              print("Deleted")
              print(flocalData.count)
              self.flocalData.remove(at: (indexPath.row * 2))
              self.flocalData.remove(at: (indexPath.row * 2))
              self.fweekDayTableView.deleteRows(at: [indexPath], with: .automatic)
              let jsonData = try? JSONSerialization.data(withJSONObject: flocalData, options: .prettyPrinted)
              let jsonString = String(data: jsonData!, encoding: String.Encoding.utf8)
              let escapedDataString = jsonString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
              httpComm.httpGet(url: "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/\(WRITE_FILLER_SERVER_PATH)?\(escapedDataString!)") { (response, success) in
                  if success == true {
                  }
              }
              self.fweekDayTableView.reloadData()
            }
        }
        
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell") as! TimeCell
            cell.startTime!.text = convertToAMAPM(a: localData[indexPath.row * 2])
            cell.endTime!.text = convertToAMAPM(a: localData[indexPath.row * 2 + 1])
            cell.backgroundColor = UIColor(red:35/255, green: 35/255, blue: 35/255, alpha: 1.0)
            cell.contentView.layer.borderColor = UIColor.darkGray.cgColor
            cell.contentView.layer.borderWidth = 1
            
            return cell
        }
        if tableView.tag == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ftimeCell") as! fTimeCell
            cell.startTime!.text = convertToAMAPM(a: flocalData[indexPath.row * 2])
            cell.endTime!.text = convertToAMAPM(a: flocalData[indexPath.row * 2 + 1])
            cell.backgroundColor = UIColor(red:35/255, green: 35/255, blue: 35/255, alpha: 1.0)
            cell.contentView.layer.borderColor = UIColor.darkGray.cgColor
            cell.contentView.layer.borderWidth = 1
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func createBlockView(start: Int, end: Int, tag:Int){
        let customView = UIView()
        let endTime = end
        let strtTime = start
        let startIndex = (strtTime/100)*40 + (strtTime%100)*2/3
        let vwidth = (((endTime-strtTime)/100) * 40) + ((endTime-strtTime)%100) * 2/3
        if tag == 1{
            customView.frame = CGRect.init(x:startIndex, y: 0, width: vwidth , height: 80)
            customView.backgroundColor = UIColor(red:178.0/255.0, green:180.0/255.0, blue: 178.0/255.0, alpha:1.0)
            let lbl = UILabel()
            lbl.text = "WP"
            lbl.textColor = .white
            lbl.frame = CGRect(x: vwidth/2-14, y: 20, width:28, height: 50)
            customView.addSubview(lbl)
            customView.bringSubviewToFront(lbl)
        } else if tag == 2 {
            customView.frame = CGRect.init(x:startIndex, y: 80, width: vwidth , height: 80)
            customView.backgroundColor = RED_COLOR
            let lbl = UILabel()
            lbl.text = "F"
            lbl.textColor = .black
            lbl.frame = CGRect(x: vwidth/2-5, y: 20, width:28, height: 50)
            customView.addSubview(lbl)
            customView.bringSubviewToFront(lbl)
        }
        
        self.scheduleView.addSubview(customView)
    }
    func convertToAMAPM(a: Int) -> String{
        var str = ""
        
        var valhh = a/100
        let valmm = a%100
        var valap = ""
        if valhh < 12{
            valap = "AM"
        } else {
            valap = "PM"
        }
        if valhh == 0{
            valhh = 12
        } else if valhh > 12 {
            valhh = valhh - 12
        }
        
        str = "\(valhh)" + ":" + String(format: "%02i", valmm) + "  " + valap
        return str
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func addRow(_ sender: UIButton) {
        if sender.tag == 3{
           self.addRowView.isHidden = false
        }
        if sender.tag == 4{
            self.faddRowView.isHidden = false
        }
        
    }
    
    @IBAction func saveRow(_ sender: UIButton) {
        if sender.tag == 19{
            self.startTimePicker.isHidden = true
            self.endTimePicker.isHidden = true
            var startTime = 0
            let sap = UserDefaults.standard.integer(forKey: "startSelectedAMPM")
            var shh = UserDefaults.standard.integer(forKey: "startSelectedHour")
            let smm = UserDefaults.standard.integer(forKey: "startSelectedMinute")
            if shh == 12{
                shh = 0
            }
            if sap == 0{
                startTime = 0
            } else {
                startTime = 1200
            }
            startTime = startTime + shh*100 + smm
            
            var endTime = 0
            let eap = UserDefaults.standard.integer(forKey: "endSelectedAMPM")
            var ehh = UserDefaults.standard.integer(forKey: "endSelectedHour")
            let emm = UserDefaults.standard.integer(forKey: "endSelectedMinute")
            if ehh == 12{
                ehh = 0
            }
            if eap == 0{
                endTime = 0
            } else {
                endTime = 1200
            }
            endTime = endTime + ehh*100 + emm
            
            
            print(startTime)
            print(endTime)
            self.localData.append(startTime)
            self.localData.append(endTime)
            self.localData = self.localData.sorted()
            let jsonData = try? JSONSerialization.data(withJSONObject: self.localData, options: .prettyPrinted)
            let jsonString = String(data: jsonData!, encoding: String.Encoding.utf8)
            let escapedDataString = jsonString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            httpComm.httpGet(url: "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/\(WRITE_WEPLAY_SERVER_PATH)?\(escapedDataString!)") { (response, success) in
                if success == true {
                }
            }
            self.weekDayTableView.reloadData()
            self.addRowView.isHidden = true
            self.startTimeTxt.text = ""
            self.endTimeTxt.text = ""
        }
        if sender.tag == 20{
            self.fstartTimePicker.isHidden = true
            self.fendTimePicker.isHidden = true
            var startTime = 0
            let sap = UserDefaults.standard.integer(forKey: "fstartSelectedAMPM")
            var shh = UserDefaults.standard.integer(forKey: "fstartSelectedHour")
            let smm = UserDefaults.standard.integer(forKey: "fstartSelectedMinute")
            if shh == 12{
                shh = 0
            }
            if sap == 0{
                startTime = 0
            } else {
                startTime = 1200
            }
            startTime = startTime + shh*100 + smm
            
            var endTime = 0
            let eap = UserDefaults.standard.integer(forKey: "fendSelectedAMPM")
            var ehh = UserDefaults.standard.integer(forKey: "fendSelectedHour")
            let emm = UserDefaults.standard.integer(forKey: "fendSelectedMinute")
            if ehh == 12{
                ehh = 0
            }
            if eap == 0{
                endTime = 0
            } else {
                endTime = 1200
            }
            endTime = endTime + ehh*100 + emm
            
            
            print(startTime)
            print(endTime)
            self.flocalData.append(startTime)
            self.flocalData.append(endTime)
            self.flocalData = self.flocalData.sorted()
            let jsonData = try? JSONSerialization.data(withJSONObject: self.flocalData, options: .prettyPrinted)
            let jsonString = String(data: jsonData!, encoding: String.Encoding.utf8)
            let escapedDataString = jsonString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            httpComm.httpGet(url: "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/\(WRITE_FILLER_SERVER_PATH)?\(escapedDataString!)") { (response, success) in
                if success == true {
                }
            }
            self.fweekDayTableView.reloadData()
            self.faddRowView.isHidden = true
            self.fstartTimeTxt.text = ""
            self.fendTimeTxt.text = ""
        }
        
    }
    
    @IBAction func cancelRow(_ sender: UIButton) {
        if sender.tag == 21{
            self.addRowView.isHidden = true
            self.startTimePicker.isHidden = true
            self.endTimePicker.isHidden = true
            self.startTimeTxt.text = ""
            self.endTimeTxt.text = ""
        }
        if sender.tag == 22{
            self.faddRowView.isHidden = true
            self.fstartTimePicker.isHidden = true
            self.fendTimePicker.isHidden = true
            self.fstartTimeTxt.text = ""
            self.fendTimeTxt.text = ""
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 15{
            return 1
        } else if pickerView.tag > 10 && pickerView.tag < 15 {
            return 3
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 15{
            if component == 0{
                
                return list.count
                
            }
        } else if pickerView.tag > 10 && pickerView.tag < 15 {
            if component == 0{
                
                return 12
                
            } else if component == 1{
                
                return 60
                
            } else if component == 2{
                
                return 2
                
            }
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerView.tag == 15{
            pickerLabel = UILabel()
            pickerLabel?.textColor = .white
            pickerLabel?.textAlignment = .center
            pickerLabel?.text = list[row]
        } else {
            if pickerLabel == nil {
                pickerLabel = UILabel()
                pickerLabel?.textColor = .white
                pickerLabel?.font = UIFont(name: ".SFUIDisplay", size: 20)
                pickerLabel?.textAlignment = .left
                
                
                switch component {
                case 0:
                    pickerLabel?.textAlignment = .right
                    
                    pickerLabel?.text = "\(row + 1)"
                    
                case 1:
                    let formattedMinutes = String(format: "%02i", row)
                    pickerLabel?.text = ": \(formattedMinutes)"
                    
                case 2:
                    pickerLabel?.text = AM_PM_PICKER_DATA_SOURCE[row]
                    
                default:
                    pickerLabel?.text = "Error"
                }
                
            }
        }
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var a = 0
        var b = 0
        var c = 0
        
        if pickerView.tag == 11{
                if component == 0 {
                    
                    a = row + 1
                    UserDefaults.standard.set(a, forKey: "startSelectedHour")
                    strtcomponent0AlreadySelected = true
                }
            
                if component == 1 {
                    b = row
                    UserDefaults.standard.set(b, forKey: "startSelectedMinute")
                    strtcomponent1AlreadySelected = true
                }
                if component == 2 {
                    c =  row
                    UserDefaults.standard.set(c, forKey: "startSelectedAMPM")
                    strtcomponent2AlreadySelected = true
                }
                
                a = UserDefaults.standard.integer(forKey: "startSelectedHour")
                b = UserDefaults.standard.integer(forKey: "startSelectedMinute")
                c = UserDefaults.standard.integer(forKey: "startSelectedAMPM")
                let selectedTxt = "\(a)" + ":" + String(format: "%02d", b) + "  " + AM_PM_PICKER_DATA_SOURCE[c]
                self.startTimeTxt.text = selectedTxt
                if strtcomponent0AlreadySelected == true && strtcomponent1AlreadySelected == true && strtcomponent2AlreadySelected == true {
                    self.startTimePicker.isHidden = true
                    strtcomponent0AlreadySelected = false
                    strtcomponent1AlreadySelected = false
                    strtcomponent2AlreadySelected = false
                }
        }
        if pickerView.tag == 12{
                if component == 0 {
                    
                    a = row + 1
                    UserDefaults.standard.set(a, forKey: "endSelectedHour")
                    endcomponent0AlreadySelected = true
                }
            
                if component == 1 {
                    b = row
                    UserDefaults.standard.set(b, forKey: "endSelectedMinute")
                    endcomponent1AlreadySelected = true
                }
                if component == 2 {
                    c =  row
                    UserDefaults.standard.set(c, forKey: "endSelectedAMPM")
                    endcomponent2AlreadySelected = true
                }
                
                a = UserDefaults.standard.integer(forKey: "endSelectedHour")
                b = UserDefaults.standard.integer(forKey: "endSelectedMinute")
                c = UserDefaults.standard.integer(forKey: "endSelectedAMPM")
                let selectedTxt = "\(a)" + ":" + String(format: "%02d", b) + "  " + AM_PM_PICKER_DATA_SOURCE[c]
                self.endTimeTxt.text = selectedTxt
                if endcomponent0AlreadySelected == true && endcomponent1AlreadySelected == true && endcomponent2AlreadySelected == true {
                    self.endTimePicker.isHidden = true
                    endcomponent0AlreadySelected = false
                    endcomponent1AlreadySelected = false
                    endcomponent2AlreadySelected = false
                }
        }
        if pickerView.tag == 13{
                if component == 0 {
                    
                    a = row + 1
                    UserDefaults.standard.set(a, forKey: "fstartSelectedHour")
                    fstrtcomponent0AlreadySelected = true
                }
            
                if component == 1 {
                    b = row
                    UserDefaults.standard.set(b, forKey: "fstartSelectedMinute")
                    fstrtcomponent1AlreadySelected = true
                }
                if component == 2 {
                    c =  row
                    UserDefaults.standard.set(c, forKey: "fstartSelectedAMPM")
                    fstrtcomponent2AlreadySelected = true
                }
                
                a = UserDefaults.standard.integer(forKey: "fstartSelectedHour")
                b = UserDefaults.standard.integer(forKey: "fstartSelectedMinute")
                c = UserDefaults.standard.integer(forKey: "fstartSelectedAMPM")
                let selectedTxt = "\(a)" + ":" + String(format: "%02d", b) + "  " + AM_PM_PICKER_DATA_SOURCE[c]
                self.fstartTimeTxt.text = selectedTxt
                if fstrtcomponent0AlreadySelected == true && fstrtcomponent1AlreadySelected == true && fstrtcomponent2AlreadySelected == true {
                    self.fstartTimePicker.isHidden = true
                    fstrtcomponent0AlreadySelected = false
                    fstrtcomponent1AlreadySelected = false
                    fstrtcomponent2AlreadySelected = false
                }
        }
        if pickerView.tag == 14{
            if component == 0 {
                    
                    a = row + 1
                    UserDefaults.standard.set(a, forKey: "fendSelectedHour")
                    fendcomponent0AlreadySelected = true
                }
            
                if component == 1 {
                    b = row
                    UserDefaults.standard.set(b, forKey: "fendSelectedMinute")
                    fendcomponent1AlreadySelected = true
                }
                if component == 2 {
                    c =  row
                    UserDefaults.standard.set(c, forKey: "fendSelectedAMPM")
                    fendcomponent2AlreadySelected = true
                }
                
                a = UserDefaults.standard.integer(forKey: "fendSelectedHour")
                b = UserDefaults.standard.integer(forKey: "fendSelectedMinute")
                c = UserDefaults.standard.integer(forKey: "fendSelectedAMPM")
                let selectedTxt = "\(a)" + ":" + String(format: "%02d", b) + "  " + AM_PM_PICKER_DATA_SOURCE[c]
                self.fendTimeTxt.text = selectedTxt
                if fendcomponent0AlreadySelected == true && fendcomponent1AlreadySelected == true && fendcomponent2AlreadySelected == true {
                    self.fendTimePicker.isHidden = true
                    fendcomponent0AlreadySelected = false
                    fendcomponent1AlreadySelected = false
                    fendcomponent2AlreadySelected = false
                }
        }
        if pickerView.tag == 15{
            let showName = self.list[row]
                let defaults = UserDefaults.standard
            
                if defaults.object(forKey: "shows") != nil {
                    
                    if let object = defaults.object(forKey: "shows") as? [Any] {
                        shows = object
                    }
                }
                 for show in self.shows!{
                    let dictionary  = show as! NSDictionary
                    let number      = dictionary.object(forKey: "number") as! Int
                    
                    let selectedShow = dictionary.object(forKey: "name") as? String
                    if selectedShow == showName {
                        self.fillerShowNumberTxt.text = "\(number)"
                    }
                }
            self.dropDown.isHidden = true
            writeToServer()
    }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if startTimeTxt.isEditing {
            self.startTimePicker.isHidden = false
            self.startTimeTxt.endEditing(true)
        } else {
            
        }
        if endTimeTxt.isEditing {
            self.endTimePicker.isHidden = false
            self.endTimeTxt.endEditing(true)
        } else {
            
        }
        
        if fstartTimeTxt.isEditing {
            self.fstartTimePicker.isHidden = false
            self.fstartTimeTxt.endEditing(true)
        } else {
            
        }
        if fendTimeTxt.isEditing {
            self.fendTimePicker.isHidden = false
            self.fendTimeTxt.endEditing(true)
        } else {
            
        }
        if fillerShowNumberTxt.isEditing {
            self.dropDown.isHidden = false
            self.fillerShowNumberTxt.endEditing(true)
            if list.count == 0{
                self.view.endEditing(true)
                let alert = UIAlertController(title: "FillerShow", message: "FILLER SHOW NOT SET", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.dropDown.isHidden = true
                self.fillerShowNumberTxt.text = "0"
                return
            }
        }
    }
    
    @IBAction func enableDisableFillerShows(_ sender: UISwitch){
        
        var setState = 0
        
        if(currentFillerShowState == 1){
            setState = 0
        }else if(currentFillerShowState == 0){
            setState = 1
        }
        
        let sendData = [
            "FillerShow_Enable" : setState,
            "FillerShow_Number" : currentFillerShowNumber
        ]
        
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: sendData, options: .prettyPrinted)
        var jsonString: String? = nil
        
        if let aData = jsonData{
            jsonString = String(data: aData, encoding: .utf8)
        }
        
        let escapedString = jsonString!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let strURL = "\(SET_FILLER_SHOW_STATE_HTTP_PATH)?\(String(describing: escapedString))"
        
        self.httpComm.httpGetResponseFromPath(url: strURL) { (response) in
            
        }

    }
    
    func readShowFile() {
        
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: "shows") != nil {
            
            if let object = defaults.object(forKey: "shows") as? [Any] {
                shows = object
            }
            for show in self.shows!{
                
                let dictionary  = show as! NSDictionary
                let test       = dictionary.object(forKey: "test") as? Int
                let name        = dictionary.object(forKey: "name") as? String
                let number      = dictionary.object(forKey: "number") as? Int
                let duration      = dictionary.object(forKey: "duration") as? Int
                
                if number != 0 {
                    if duration != 0 {
                        if test != nil {
                            if test != 1 {
                                if !list.contains(name!){
                                    self.list.append(name!)
                                }
                            }
                        } else {
                            if !list.contains(name!){
                                self.list.append(name!)
                            }
                        }
                    }
                }
            }
            print(list)
            dropDown.reloadAllComponents()
            print(list.count)
        }
        
        
    }
    func readFillerShowState(){
        
        httpComm.httpGetResponseFromPath(url: GET_FILLER_SHOW_STATE_HTTP_PATH) { (response) in
            
            let dictionary  = response as! NSDictionary
            let enabledDisabled    = dictionary.object(forKey: "FillerShow_Enable") as? Int
            let fillerShowNumber   = dictionary.object(forKey: "FillerShow_Number") as? Int
            
           
            
            if fillerShowNumber != nil && self.showNumberRead == 0 {
                self.currentFillerShowNumber  = fillerShowNumber!
                self.showNumberRead = 1
                
            }

            self.currentFillerShowState = enabledDisabled!
        }
    }
    func writeToServer(){
        let showNumber = Int(self.fillerShowNumberTxt.text!)
        
        guard showNumber != nil else{
            return
        }
        
        self.currentFillerShowNumber = showNumber!
        let sendData = [
            "FillerShow_Enable" : currentFillerShowState,
            "FillerShow_Number" : showNumber!
        ]
        
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: sendData, options: .prettyPrinted)
        var jsonString: String? = nil
        
        if let aData = jsonData{
            jsonString = String(data: aData, encoding: .utf8)
        }
        
        let escapedString = jsonString!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let strURL = "\(SET_FILLER_SHOW_STATE_HTTP_PATH)?\(String(describing: escapedString))"
        
        self.httpComm.httpGetResponseFromPath(url: strURL) { (response) in
            
        }
    }
    
}

