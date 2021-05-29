//
//  HomeScreenViewModel.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 11/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation
import RxSwift
import AVFoundation

enum AlertType{
    case errorAlert(String)
}

enum CellType{
    case Trending, Song
}

struct SongListCell {
    var songList: SongList? = nil
    var artistCollection: [Artist]? = nil
    let cellType: CellType
}

protocol HomeScreenViewModel{
    var audioSubject: ReplaySubject<String> {get}
    var loaderSubject: ReplaySubject<Bool> {get}
    var screenData: [SongListCell] {get}
    var dataStatusObservable: ReplaySubject<Bool> {get}
    var alertObservable: ReplaySubject<AlertType> {get}
    var avPlayer: AVPlayer? {get}
    
    func loadData()
    func initializeViewModelObservables() -> [Disposable]
}
