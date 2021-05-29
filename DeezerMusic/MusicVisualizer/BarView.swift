//
//  BarView.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 19.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import SwiftUI

let numberOfSamples: Int = 10

struct BarView: View {
    var value: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(gradient: Gradient(colors: [.purple, .blue]),
                                     startPoint: .top,
                                     endPoint: .bottom))
                .frame(width: (UIScreen.main.bounds.width - CGFloat(numberOfSamples) * 4) / CGFloat(numberOfSamples), height: value)
        }
    }
}
