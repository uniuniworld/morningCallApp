//
//  Alarm.swift
//  morningCall
//
//  Created by Takahiro Kirifu on 2020/03/29.
//  Copyright © 2020 Takahiro Kirifu. All rights reserved.
//

import Foundation
import AVFoundation

class Alarm{
    var selectedWakeUpTime: Date?
    var aoudioPlayer: AVAudioPlayer!
    var sleepTimer: Timer?
    var secounds = 0
    
    func startTimer(){
        secounds = calculateInterva
    }
    
    
    
    
}
