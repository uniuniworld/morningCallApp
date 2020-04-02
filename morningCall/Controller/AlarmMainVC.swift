//
//  ViewController.swift
//  morningCall
//
//  Created by Takahiro Kirifu on 2020/03/15.
//  Copyright © 2020 Takahiro Kirifu. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmMailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var appDelegate = UIApplication.shared
    @IBOutlet weak var tableView: UITableView!
    var userDefaults = UserDefaults.standard
    var index = 0
    
    var timeArray = 

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        let <#変数名#> = segue.destination as! SetViewController
//        
//        <#変数名#>.<#値を渡す先の変数名#> = <#渡す値#>
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    @IBAction func addButton(_ sender: Any) {
    }
}

