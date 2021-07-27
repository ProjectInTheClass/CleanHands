//
//  SettingsAlarmTableViewController.swift
//  CleanHands
//
//  Created by 신호중 on 2021/06/09.
//

import UIKit
import UserNotifications

class SettingsAlarmTableViewController: UITableViewController {
    
    struct CellIdentifiers {
        static let isAlarmCell = "isAlarmCell"
        static let repeatCell = "repeatCell"
        static let isDoNotDisturbCell = "isDoNotDisturbCell"
        static let timePickerCell = "timePickerCell"
        
        static let cellCount = 4
    }
    
    var alarmController: AlarmController = AlarmController()
    var notificationController: NotificationController = NotificationController()
    var alarm: Alarm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alarmController.loadAlarmFromUserState()
        alarm = alarmController.alarm!
        
        notificationController.setNotificationPermission()
        
        self.tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellIdentifiers.cellCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.isAlarmCell, for: indexPath) as! IsAlarmCell
                
                cell.alarmSwitch.isOn = alarm.isAlarmOn
                
                return cell
            }
            else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.repeatCell, for: indexPath) as! RepeatCell
                
                cell.repeatConfigLabel.text = alarm.repeatTime
                
                return cell
            }
            else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.isDoNotDisturbCell, for: indexPath) as! IsDoNotDisturbCell
                
                cell.doNotDisturbSwitch.isOn = alarm.isDoNotDisturbOn
                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.timePickerCell, for: indexPath) as! TimePickerCell
                
                cell.fromTimePicker.date = alarm.from
                cell.toTimePicker.date = alarm.to
                
                return cell
            }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row > 0 && alarm.isAlarmOn == false {
            return 0.0
        }
        if indexPath.row > 2 && alarm.isDoNotDisturbOn == false {
            return 0.0
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    @IBAction func alarmSwitchChanged(_ sender: UISwitch) {
        alarm.isAlarmOn = !alarm.isAlarmOn
        alarmController.alarm = alarm
        alarmController.saveAlarmToUserState()
        
        notificationController.scheduleNotification(alarm)
        
        // begin animation
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func doNotDisturbSwitchChanged(_ sender: UISwitch) {
        alarm.isDoNotDisturbOn = !alarm.isDoNotDisturbOn
        alarmController.alarm = alarm
        alarmController.saveAlarmToUserState()
        
        notificationController.scheduleNotification(alarm)
        
        // begin animation
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func unwindToAlarmTableView(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as! AlarmTimeSelectModalViewController
        
        if let selectedAlarmString = sourceViewController.selectedAlarmString {
            alarm.repeatTime = selectedAlarmString
            alarmController.alarm = alarm
            alarmController.saveAlarmToUserState()
            
            notificationController.scheduleNotification(alarm)
            tableView.reloadData()
        }
        
        self.tableView.deselectRow(at: IndexPath.init(row: 1, section: 0), animated: true)
    }
    
    @IBAction func fromTimePickerChanged(_ sender: UIDatePicker) {
        alarm.from = sender.date
        alarmController.alarm = alarm
        alarmController.saveAlarmToUserState()
        
        notificationController.scheduleNotification(alarm)
    }
    
    @IBAction func toTimePickerChanged(_ sender: UIDatePicker) {
        alarm.to = sender.date
        alarmController.alarm = alarm
        alarmController.saveAlarmToUserState()
        
        notificationController.scheduleNotification(alarm)
    }
}
