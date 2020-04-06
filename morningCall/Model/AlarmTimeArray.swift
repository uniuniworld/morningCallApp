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
    
    override init() {
        self.date = Date()
        self.uuidString = UUID().uuidString
        self.label = "Alarm"
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.date, forKey: "date")
        coder.encode(self.uuidString, forKey: "uuidString")
        coder.encode(self.label, forKey: "label")
    }
    
    required init?(coder: NSCoder) {
        date = coder.decodeObject(forKey: "date") as! Date
        uuidString = coder.decodeObject(forKey: "uuidString") as! String
        label = coder.decodeObject(forKey: "label") as! String
        
    }
}
