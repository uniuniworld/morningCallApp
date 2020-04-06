//
//  AlarmSnoozeCell.swift
//  morningCall
//
//  Created by Takahiro Kirifu on 2020/04/06.
//  Copyright © 2020 Takahiro Kirifu. All rights reserved.
//

import UIKit

protocol AlarmSnoozeCellDelegte {
    func alarmSnoozeCell(swichOn:AlarmSnoozeCell,On:Bool)
}

class AlarmSnoozeCell: UITableViewCell {
    var delegate: AlarmAddDelegate!

}
