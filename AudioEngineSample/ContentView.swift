//
//  ContentView.swift
//  AudioEngineSample
//
//  Created by Yuta Tokoro on 2022/10/19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Play Audio", action: playAudio)
        }
        .padding()
    }
}

// MARK: - Actions

extension ContentView {
    private func playAudio() {
        AppAudio.shared.start()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
