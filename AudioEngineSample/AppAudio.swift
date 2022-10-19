//
//  AppAudio.swift
//
//  Created by ToKoRo on 2022-10-19.
//

import AVKit
import Foundation

final class AppAudio {
    static let shared = AppAudio()
    private init() {}

    private var audioEngine: AVAudioEngine?

    func setup() {
        let session = AVAudioSession.sharedInstance()

        do {
            try session.setCategory(.playAndRecord, options: [.allowBluetooth, .allowBluetoothA2DP, .allowAirPlay])
            try session.setActive(true)
            AppLogger.info("AVAudioSession setActive")
        } catch {
            AppLogger.error(error)
        }
    }

    func start() {
        self.audioEngine?.stop()
        self.audioEngine = nil

        let audioEngine = AVAudioEngine()

        let inputNode = audioEngine.inputNode
        let outputNode = audioEngine.mainMixerNode
        audioEngine.connect(inputNode, to: outputNode, format: inputNode.outputFormat(forBus: 0))

        do {
            try audioEngine.start()
            AppLogger.info("AVAudioEngine started")

            self.audioEngine = audioEngine
        } catch {
            AppLogger.info("cannot start AVAudioEngine")
            AppLogger.error(error)
        }
    }
}
