//
//  CallSenter.swift
//  morningCall
//
//  Created by Takahiro Kirifu on 2020/04/02.
//  Copyright © 2020 Takahiro Kirifu. All rights reserved.
//

import Foundation
import CallKit
import AVFoundation

class CallCenter: NSObject {
 
    let controller = CXCallController()
    let provider: CXProvider
    var uuid = UUID()
    
    init(supportsVideo: Bool) {
        let providerConfiguration = CXProviderConfiguration(localizedName: "朝電話")
        providerConfiguration.supportsVideo = supportsVideo
        provider = CXProvider(configuration: providerConfiguration)
    }
    
    func setup(_ delegate: CXProviderDelegate) {
        provider.setDelegate(delegate, queue: nil)
    }
    
    // 着信処理
    func IncomingCall() {
        uuid = UUID()
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: "太郎さん")
        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            if let error = error {
                print("reportNewIncomingCall error: \(error.localizedDescription)")
            }
        }
    }
    
    // 発信処理
        func StartCall() {
        uuid = UUID()
        let handle = CXHandle(type: .generic, value: "花子さん")
        let startCallAction = CXStartCallAction(call: uuid, handle: handle)
        let transaction = CXTransaction(action: startCallAction)
        controller.request(transaction) { error in
            if let error = error {
                print("CXStartCallAction error: \(error.localizedDescription)")
            }
        }
    }
    
    // 通話の終了
    func EndCall() {
        let action = CXEndCallAction(call: uuid)
        let transaction = CXTransaction(action: action)
        controller.request(transaction) { error in
            if let error = error {
                print("CXEndCallAction error: \(error.localizedDescription)")
            }
        }
    }
    
    func Connecting() {
            provider.reportOutgoingCall(with: uuid, startedConnectingAt: nil)
        }

        func Connected() {
            provider.reportOutgoingCall(with: uuid, connectedAt: nil)
        }

        func ConfigureAudioSession() {
            // Setup AudioSession
            try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .voiceChat, options: [])
        }
    }

    // MARK: DEBUG
    extension CallCenter {
        func setupNotifications() {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(handleRouteChange),
                                                   name: AVAudioSession.routeChangeNotification,
                                                   object: nil)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(handleInterruption),
                                                   name: AVAudioSession.interruptionNotification,
                                                   object: nil)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(handleMediaServerReset),
                                                   name: AVAudioSession.mediaServicesWereResetNotification,
                                                   object: nil)
        }

        @objc func handleRouteChange(notification: Notification) {
            print("handleRouteChange: \(notification)")
        }

        @objc func handleInterruption(notification: Notification) {
            print("handleInterruption: \(notification)")
        }

        @objc func handleMediaServerReset(notification: Notification) {
            print("handleMediaServerReset: \(notification)")
        }
}
