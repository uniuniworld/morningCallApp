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
    
    let alarm = Alarm()
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
        tableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        let <#変数名#> = segue.destination as! SetViewController
//        
//        <#変数名#>.<#値を渡す先の変数名#> = <#渡す値#>
        
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
    
    // 表示するセルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeArray.count
    }
    
    // 各セルを生成して返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmTimeCell") as! AlarmTimeCell
        
//        cell.timeLabel.text = getTime(date: timeArray[indexPath.row].date)
//        cell.label.text = setCellLabel(index: indexPath.row)
//        cell.sw.isOn = timeArray[indexPath.row].onOff
//        cell.editingAccessoryType = .disclosureIndicator

        return cell
    }
    
    @IBAction func addButton(_ sender: Any) {
        //self.performSegue(withIdentifier: "setAlarm", sender: nil)
    }
}

