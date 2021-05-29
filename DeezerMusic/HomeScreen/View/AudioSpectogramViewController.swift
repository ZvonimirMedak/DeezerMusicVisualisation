//
//  AudioSpectogramViewController.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 20.05.2021..
//  Copyright © 2021 Zvonimir Medak. All rights reserved.
//

import UIKit
class AudioSpectogramViewController: UIViewController {

    weak var stopAVPlayerDelegate: StopAVPlayerDelegate?
    
    
    deinit {
        stopAVPlayerDelegate?.stopPlayer()
    }
    
    let audioSpectrogram = AudioSpectrogram()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioSpectrogram.contentsGravity = .resize
        view.layer.addSublayer(audioSpectrogram)
  
        view.backgroundColor = .black
        
        audioSpectrogram.startRunning()
    }

    override func viewDidLayoutSubviews() {
        audioSpectrogram.frame = view.frame
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }
    
    override var prefersStatusBarHidden: Bool {
        true
    }
}
