//
//  CircleView.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 19.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import SwiftUI

struct CircleView: View {
    var value: CGFloat

    var body: some View {
        ZStack {
                Circle()
                    .fill(Color.purple)
                    .frame(width: value*3/2 , height: value*3/2)
                
        }
    }
}
