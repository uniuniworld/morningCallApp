//
//  AlarmDeleteCell.swift
//  morningCall
//
//  Created by Takahiro Kirifu on 2020/04/07.
//  Copyright © 2020 Takahiro Kirifu. All rights reserved.
//

import UIKit

protocol AlarmDeleteCellDelegate {
    func alarmDeleteCell(delete:UITableViewCell)
}

class AlarmDeleteCell: UITableViewCell {
    var delegate: AlarmDeleteCellDelegate!

    @IBAction func deleteButton(_ sender: Any) {
        delegate.alarmDeleteCell(delete: self)
    }
}
