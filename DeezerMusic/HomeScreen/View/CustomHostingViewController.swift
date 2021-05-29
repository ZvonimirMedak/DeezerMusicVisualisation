//
//  CustomHostingViewController.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 19.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
class CustomHostingViewController: UIHostingController<VisualizerView> {
    weak var stopAVPlayerDelegate: StopAVPlayerDelegate?
    
    
    deinit {
        stopAVPlayerDelegate?.stopPlayer()
    }
}

class CustomHostingCircleViewController: UIHostingController<VisualizerCircleView> {
    weak var stopAVPlayerDelegate: StopAVPlayerDelegate?
    
    
    deinit {
        stopAVPlayerDelegate?.stopPlayer()
    }
}
