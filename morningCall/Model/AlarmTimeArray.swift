//
//  AlarmTimeArray.swift
//  morningCall
//
//  Created by Takahiro Kirifu on 2020/04/06.
//  Copyright © 2020 Takahiro Kirifu. All rights reserved.
//

import Foundation

class AlarmTimeArray: NSObject, NSCoding {
    
    var date:Date
    var uuidString:String
    var label:String
    var sound:Bool
    var snooze:Bool
    var onOff:Bool
    var repeatLabel:String
    var week:[String]
    
    override init() {
        self.date = Date()
        self.uuidString = UUID().uuidString
        self.label = "Alarm"
        self.sound = true
        self.snooze = true
        self.onOff = true
        self.repeatLabel = "Never"
        self.week = []
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.date, forKey: "date")
        coder.encode(self.uuidString, forKey: "uuidString")
        coder.encode(self.label, forKey: "label")
        coder.encode(self.sound, forKey: "sound")
        coder.encode(self.snooze, forKey: "snooze")
        coder.encode(self.onOff, forKey: "onOff")
        coder.encode(self.repeatLabel, forKey: "repeatLabel")
        coder.encode(self.week, forKey: "week")
    }
    
    required init?(coder decoder: NSCoder) {
        date = decoder.decodeObject(forKey: "date") as! Date
        uuidString = decoder.decodeObject(forKey: "uuidString") as! String
        label = decoder.decodeObject(forKey: "label") as! String
        sound = decoder.decodeBool(forKey: "sound")
        snooze = decoder.decodeBool(forKey: "snooze")
        onOff = decoder.decodeBool(forKey: "onOff")
        repeatLabel = decoder.decodeObject(forKey: "repeatLabel") as! String
        week = decoder.decodeObject(forKey: "week") as! [String]
    }
}
