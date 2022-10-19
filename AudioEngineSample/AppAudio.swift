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

    private(set) lazy var currentOutputNodeSubject: CurrentValueSubject<AVAudioSessionPortDescription?, Never> = .init(nil)
    private(set) lazy var useBuildInReceiverSubject: CurrentValueSubject<Bool, Never> = .init(true)

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
        stop()

        let audioEngine = AVAudioEngine()

        let inputNode = audioEngine.inputNode
        let outputNode = audioEngine.mainMixerNode
        audioEngine.connect(inputNode, to: outputNode, format: inputNode.outputFormat(forBus: 0))

        print(outputNode)
        print("outputNode: \(outputNode)")

        do {
            try audioEngine.start()
            AppLogger.info("AVAudioEngine started")

            self.audioEngine = audioEngine
        } catch {
            AppLogger.info("cannot start AVAudioEngine")
            AppLogger.error(error)
        }
    }

    private func stop() {
        audioEngine?.stop()
        audioEngine = nil
    }

    func restart() {
        start()
    }

    private func handleAudioRouteChange() {
        AppLogger.info("Detect AVAudioSession.routeChangeNotification")

        let description = AVAudioSession.sharedInstance().currentRoute
        let output = description.outputs.first

        currentOutputNodeSubject.send(output)

        if let output, output.portType == .builtInReceiver {
            useBuildInReceiverSubject.send(true)
        } else {
            useBuildInReceiverSubject.send(false)
        }

        restart()
    }
}
