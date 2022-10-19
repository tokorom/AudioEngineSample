//
//  AppAudio.swift
//
//  Created by ToKoRo on 2022-10-19.
//

import AVKit
import Combine
import Foundation

final class AppAudio {
    static let shared = AppAudio()
    private init() {}

    private var audioEngine: AVAudioEngine?

    private var cancellables: Set<AnyCancellable> = []

    func setup() {
        let session = AVAudioSession.sharedInstance()

        do {
            try session.setCategory(.playAndRecord, options: [.allowBluetooth, .allowBluetoothA2DP, .allowAirPlay])
            try session.setActive(true)
            AppLogger.info("AVAudioSession setActive")
        } catch {
            AppLogger.error(error)
        }

        start()

        NotificationCenter.default.publisher(for: AVAudioSession.routeChangeNotification, object: nil)
            .sink { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.handleAudioRouteChange()
                }
            }
            .store(in: &cancellables)
    }

    private func start() {
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

    func restart() {
        start()
    }

    private func handleAudioRouteChange() {
        AppLogger.info("Detect AVAudioSession.routeChangeNotification")

        restart()
    }
}
