//
//  ViewController.swift
//  morningCall
//
//  Created by Takahiro Kirifu on 2020/03/15.
//  Copyright © 2020 Takahiro Kirifu. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmMainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let alarm = Alarm()
    var appDelegate = UIApplication.shared
    @IBOutlet weak var tableView: UITableView!
    var userDefaults = UserDefaults.standard
    var index = 0
    var timeArray = [AlarmTimeArray]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 編集モードに入った時の制御
        tableView.allowsSelectionDuringEditing = true
        tableView.allowsSelection = false
        tableView.register(UINib(nibName: "AlarmTimeCell", bundle: nil), forCellReuseIdentifier: "AlarmTimeCell")
        self.navigationItem.setLeftBarButton(self.editButtonItem, animated: true)
        timeLoad()
        tableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setAlarm" {
            guard let nvc = segue.destination as? UINavigationController else {
                return
            }
            guard let vc = nvc.topViewController as? AlarmSetVC else {
                return
            }
            vc.delegate = self
            vc.isEdit = tableView.isEditing
            if tableView.isEditing {
                vc.alarmTime = timeArray[index]
            }
        }
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        timeLoad()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func timeLoad(){
        if let timeArrayData = UserDefaults.standard.object(forKey: "timeArray") as? Data {
            if let getTimeArray = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(timeArrayData) as? [AlarmTimeArray] {
                timeArray = getTimeArray
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    func setCellLabel(index:Int) -> String {
        if timeArray[index].repeatLabel == "Never" {
            return timeArray[index].label

        } else {
            return timeArray[index].label + "," + timeArray[index].repeatLabel
        }
    }
    
    func getAlarm(from uuid: String){
        timeLoad()
        guard let alarm = timeArray.first(where: { $0.uuidString == uuid }) else {
            return
        }
        if alarm.week.isEmpty {
            alarm.onOff = false
        }
        saveDate()
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
    }
    
    // 表示するセルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeArray.count
    }
    
    // 各セルを生成して返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmTimeCell") as! AlarmTimeCell
        
        cell.timeLabel.text = getTime(date: timeArray[indexPath.row].date)
        cell.fromLabel.text = setCellLabel(index: indexPath.row)
        cell.sw.isOn = timeArray[indexPath.row].onOff
        cell.editingAccessoryType = .disclosureIndicator

        return cell
    }
    
    @IBAction func addButton(_ sender: Any) {
        self.performSegue(withIdentifier: "setAlarm", sender: nil)
    }
    
    func getTime(date:Date) -> String {
        let f = DateFormatter()
        f.timeStyle = .short
        f.locale = Locale(identifier: "ja_JP")
        return f.string(from: date)
    }
    
    func saveDate(){
        let timeArrayData = try! NSKeyedArchiver.archivedData(withRootObject: timeArray, requiringSecureCoding: false)
        userDefaults.set(timeArrayData, forKey: "timeArray")
        userDefaults.synchronize()
    }
    
    
}

extension AlarmMainVC:AlarmAddDelegate{
    func AlarmSetVC(alarmAdd: AlarmSetVC, alarmTime: AlarmTimeArray) {
        if tableView.isEditing {
            timeArray[index] = alarmTime
        }else{
           timeArray.append(alarmTime)
        }
        timeArray.sort(){$0.date < $1.date}
        saveDate()
        self.setEditing(false, animated: false)
        tableView.reloadData()
    }
    
    func AlarmSetVC(alarmDelete: AlarmSetVC, alarmTime: AlarmTimeArray) {
        self.setEditing(false, animated: false)
        timeArray.remove(at: index)
        saveDate()
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [timeArray[index].uuidString])

    }
    
    func AlarmSetVC(alarmCancel:AlarmSetVC){
        self.setEditing(false, animated: false)
    }
}


