//
//  VisualizerView.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 19.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import SwiftUI
//source: https://medium.com/swlh/swiftui-create-a-sound-visualizer-cadee0b6ad37
let samples: Int = 10

struct VisualizerView: View {
    
    @ObservedObject private var mic = MicrophoneMonitor(numberOfSamples: samples)
    weak var stopAVPlayerDelegate: StopAVPlayerDelegate?
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50) / 2
        
        return CGFloat(level * (300 / 25))
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 4) {
                ForEach(mic.soundSamples, id: \.self) { level in
                    BarView(value: self.normalizeSoundLevel(level: level))
                    
                }
            }
        }
    }
}

public protocol StopAVPlayerDelegate: class {
    func stopPlayer()
}
