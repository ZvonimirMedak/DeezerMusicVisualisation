//
//  VisualizerCircleView.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 19.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import SwiftUI


struct VisualizerCircleView: View {
    
    @ObservedObject private var mic = MicrophoneMonitor(numberOfSamples: 1)
    weak var stopAVPlayerDelegate: StopAVPlayerDelegate?
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.8, CGFloat(level) + 50) / 2
        
        return CGFloat(level * (300 / 25))
    }
    
    var body: some View {
        CircleView(value: CGFloat(normalizeSoundLevel(level: mic.soundSamples.first ?? 0)))
            .shadow(color: .purple, radius: 30, x: 0, y: 0)
    }
}
