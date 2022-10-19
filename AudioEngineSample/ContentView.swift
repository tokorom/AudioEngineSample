//
//  ContentView.swift
//  AudioEngineSample
//
//  Created by Yuta Tokoro on 2022/10/19.
//

import AVKit
import Combine
import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel: ViewModel = .init()

    var body: some View {
        VStack {
            Text(viewModel.outputDescription)
            HStack {
                Text("Build In Receiver:")
                Text(viewModel.useBuildInReceiver ? "Yes" : "No")
            }
        }
        .padding()
    }

}

// MARK: - ViewModel

extension ContentView {
    final class ViewModel: ObservableObject {
        @Published var outputDescription: String = "..."
        @Published var useBuildInReceiver: Bool = true

        private var cancellables: Set<AnyCancellable> = []

        init() {
            AppAudio.shared.currentOutputNodeSubject
                .sink { [weak self] in
                    self?.detectNewOutput($0)
                }
                .store(in: &cancellables)

            AppAudio.shared.useBuildInReceiverSubject
                .sink { [weak self] in
                    self?.useBuildInReceiver = $0
                }
                .store(in: &cancellables)
        }

        private func detectNewOutput(_ output: AVAudioSessionPortDescription?) {
            if let output {
                outputDescription = String(describing: output)
            } else {
                outputDescription = "No output"
            }
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
