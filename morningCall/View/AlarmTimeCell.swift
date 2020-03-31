//
//  AlarmTimeCell.swift
//  morningCall
//
//  Created by Takahiro Kirifu on 2020/03/31.
//  Copyright © 2020 Takahiro Kirifu. All rights reserved.
//

import UIKit

protocol AlarmTimeCellDelegate {
    func alarmTimeCell(switchTappe: UITableViewCell, isOn: Bool)
}

class AlarmTimeCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var sw: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryView = sw
    }
}
