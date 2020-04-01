//
//  Audio.swift
//  morningCall
//
//  Created by Takahiro Kirifu on 2020/04/01.
//  Copyright © 2020 Takahiro Kirifu. All rights reserved.
//
import UIKit
import AVFoundation

class Audio {
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    init() {}
    
    func setupAudioRecorder() {
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try! session.setCategory(AVAudioSession.Category.playAndRecord)
            try! session.setActive(true)
            
            let recordSetting: [String : Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 2,
                AVEncoderBitRateKey: 16,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
            audioRecorder = try AVAudioRecorder(url: getAudioFileUrl(), settings: recordSetting)
        } catch let error {
            print(error)
        }
    }
    
    func setupAudioPlayer() {
        
        let url = getAudioFileUrl()

        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            audioPlayer = sound
            audioPlayer.delegate = self as? AVAudioPlayerDelegate
            audioPlayer.prepareToPlay()
        } catch let error {
            print(error)
        }
    }
    
    func getAudioFileUrl() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let audioUrl = docsDirect.appendingPathComponent("recording.m4a")
        
        return audioUrl
    }
    
    func playSound() {
        audioPlayer.play()
    }
}
