//
//  SetViewController.swift
//  morningCall
//
//  Created by Takahiro Kirifu on 2020/03/29.
//  Copyright © 2020 Takahiro Kirifu. All rights reserved.
//

import UIKit
import UserNotifications

protocol AlarmAddDelegate {
    func AlarmSetVC(alarmAdd: AlarmSetVC, alarmTime: AlarmTimeArray)
    func AlarmSetVC(alarmDelete: AlarmSetVC, alarmTime: AlarmTimeArray)
    func AlarmSetVC(alarmCancel: AlarmSetVC)
}

class AlarmSetVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: AlarmAddDelegate!
    var alarmTime = AlarmTimeArray()
    var isEdit = false
    var titleText = ["繰り返し", "表示名", "音声"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.date = alarmTime.date
        registerCell(cellName: "AlarmSnoozeCell")
        registerCell(cellName: "AlarmAddCell")
        registerCell(cellName: "AlarmDeleteCell")
        tableView.tableFooterView = UIView()
    }
    // セル登録
    func registerCell(cellName:String){
        tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isEdit ? 2:1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row{
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmAddCell") as! AlarmAddCell
                cell.titleLabel.text = titleText[indexPath.row]
                cell.subTitleLabel.text = alarmTime.repeatLabel
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmAddCell") as! AlarmAddCell
                cell.titleLabel.text = titleText[indexPath.row]
                cell.subTitleLabel.text = alarmTime.label
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmAddCell") as! AlarmAddCell
                cell.titleLabel.text = titleText[indexPath.row]
                cell.subTitleLabel.text = "Default"
                cell.selectionStyle = .none
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmSnoozeCell") as! AlarmSnoozeCell
                cell.delegate = self
                cell.snoozeSwitch.isOn = alarmTime.snooze
                return cell
            default:
                break
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmDeleteCell") as! AlarmDeleteCell
            cell.delegate = self
            return cell
            default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "showRepeat", sender: nil)
            case 1:
                performSegue(withIdentifier: "showLabel",sender: nil)
                break
            case 2:break
            default:break
            }
        default:
            break
        }
    }
        
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 50
        }else{
            return 0
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        alarmSet()
        delegate.AlarmSetVC(alarmAdd: self, alarmTime: alarmTime)
        dismiss(animated: true, completion: nil)
    }
    
    //スヌーズ設定
    func setCategories(){
        let snoozeAction = UNNotificationAction(
            identifier: "snooze",
            title: "Snooze 5 Minutes",
            options: []
        )
        let noAction = UNNotificationAction(
            identifier: "stop",
            title: "stop",
            options: []
        )
        var alarmCategory:UNNotificationCategory!
        if alarmTime.snooze {
           alarmCategory = UNNotificationCategory(
            identifier: "alarmCategory",
            actions: [snoozeAction, noAction],
            intentIdentifiers: [],
            options: [])
        }else{
            alarmCategory = UNNotificationCategory(
                identifier: "alarmCategory",
                actions: [],
                intentIdentifiers: [],
                options: [])
        }
        UNUserNotificationCenter.current().setNotificationCategories([alarmCategory])
    }
    
    //通知設定
    func setNotificationC(day:String, repeats:Bool){
        let content = UNMutableNotificationContent()
        content.title = alarmTime.label
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "alarmCategory"
        var dateComponents = DateComponents()
        
        if !day.isEmpty {
        dateComponents.weekday = weekDay(day: day)
        }
        dateComponents.hour = Calendar.current.component(.hour, from: datePicker.date)
        dateComponents.minute = Calendar.current.component(.minute, from: datePicker.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
        let request = UNNotificationRequest(identifier: alarmTime.uuidString+day, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        alarmTime.date = datePicker.date
    }
    
    //アラート設定
    func alarmSet(){
        removeAlarm(identifiers: alarmTime.uuidString)
        let shortWeekday = DateFormatter().shortWeekdaySymbols!
        for i in shortWeekday {
            removeAlarm(identifiers: alarmTime.uuidString+i)
        }
        if alarmTime.week.isEmpty {
            setCategories()
            
            setNotificationC(day:"", repeats: false)
        }else{
        for i in alarmTime.week {
                setCategories()
            setNotificationC(day: i, repeats: true)
            }
        }
    }
    
    //アラート設定削除
    func removeAlarm(identifiers:String){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifiers])
    }
    
    //曜日
    func weekDay(day:String) -> Int{
        var week = DateFormatter().weekdaySymbols!
        switch day {
        case week[0]:
            return 1
        case week[1]:
            return 2
        case week[2]:
            return 3
        case week[3]:
            return 4
        case week[4]:
            return 5
        case week[5]:
            return 6
        case week[6]:
            return 7
        default:
            return Int()
        }
    }

    @IBAction func cancelButton(_ sender: Any) {
        delegate.AlarmSetVC(alarmCancel: self)
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showRepeat":
            guard let nextVC:AlarmRepeatVC = segue.destination as? AlarmRepeatVC else {return}
            nextVC.delegate = self
        
            nextVC.selectDay = alarmTime.week
        case "showLabel":
            guard let nextVC:AlarmAddLabelVC = segue.destination as? AlarmAddLabelVC else {return}
            nextVC.delegate = self
            nextVC.text = alarmTime.label
        default:
            return
        }
    }
}

extension AlarmSetVC: AlarmRepeatVCDelegate {
    func AlarmRepeatVC(addRepeat: AlarmRepeatVC, week: [String]) {
        alarmTime.week = []
        alarmTime.repeatLabel = ""
        alarmTime.week += week
        if alarmTime.week.count == 1 {
            alarmTime.repeatLabel = "Every" + alarmTime.week[0]
        }else if alarmTime.week.isEmpty {
            alarmTime.repeatLabel = "Never"
        }else if alarmTime.week.count == 7{
            alarmTime.repeatLabel = "Every day"
        }else{
            let shortWeekday = DateFormatter().shortWeekdaySymbols!
            for i in alarmTime.week {
                if alarmTime.repeatLabel != "" {
                    alarmTime.repeatLabel += ","
                }
            alarmTime.repeatLabel += shortWeekday[weekDay(day: i)]
            }
        }
        tableView.reloadData()
    }
    
}

extension AlarmSetVC: AlarmAddLabelDelegate {
    func alarmAddLabel(labelText: AlarmAddLabelVC, text: String) {
        alarmTime.label = text
        tableView.reloadData()
    }
}

extension AlarmSetVC: AlarmSnoozeCellDelegte{
    func alarmSnoozeCell(swichOn: AlarmSnoozeCell, On: Bool) {
        alarmTime.snooze = On
    }
}

extension AlarmSetVC: AlarmDeleteCellDelegate{
    func alarmDeleteCell(delete: UITableViewCell) {
        delegate.AlarmSetVC(alarmDelete: self,alarmTime:alarmTime)
        dismiss(animated: true, completion: nil)
    }
}

