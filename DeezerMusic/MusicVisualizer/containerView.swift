//
//  containerView.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 20.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//
import SwiftUI

struct ContainerView: View {
    var value: CGFloat

    var body: some View {
        ZStack {
            VStack {
                
                Spacer()
                CircleView(value: value)
                    .padding()
                Spacer()
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
                
        }
    }
}
