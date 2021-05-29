//
//  HomeScreenViewModelImpl.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 11/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation
import RxSwift

import AVFoundation
import AVKit

class HomeScreenViewModelImpl: HomeScreenViewModel{
    let audioSubject = ReplaySubject<String>.create(bufferSize: 1)
    let alertObservable = ReplaySubject<AlertType>.create(bufferSize: 1)
    var screenData = [SongListCell]()
    let loaderSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    let dataStatusObservable = ReplaySubject<Bool>.create(bufferSize: 1)
    private let dataArtistSubject = ReplaySubject<()>.create(bufferSize: 1)
    private let dataSubject = ReplaySubject<()>.create(bufferSize: 1)
    private let songRepository: SongRepository
    private var currentPage = 0
    var avPlayer: AVPlayer?
    
    
    init(songRepository: SongRepository) {
        self.songRepository = songRepository
    }
    
    func loadData() {
        loaderSubject.onNext(true)
        if screenData.isEmpty{
            dataArtistSubject.onNext(())
        }
        dataSubject.onNext(())
    }
    
    func initializeViewModelObservables() -> [Disposable]{
        var disposables = [Disposable]()
        disposables.append(initializeDataObservable())
        disposables.append(initializeAudioObservable())
        return disposables
    }
    
    
    func initializeAudioObservable() -> Disposable{
        audioSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { [unowned self] url in
                let playerItem:AVPlayerItem = AVPlayerItem(url: URL(string: url) ?? URL(fileURLWithPath: ""))
            avPlayer = AVPlayer(playerItem: playerItem)
                avPlayer?.play()
        })
    }
    
    private func getSongFromCell(for cell: SongListCell) -> SongList{
        var song = SongList(id: 0, title: "", duration: 0, preview: "", artist: Artist(id: 0, name: "", picture: "", pictureXl: ""), album: Album(id: 0, title: "", cover: ""))
        for songCell in screenData {
            if songCell.cellType == CellType.Song{
                if cell.songList?.title == songCell.songList?.title{
                    song = songCell.songList ?? SongList(id: 0, title: "", duration: 0, preview: "", artist: Artist(id: 0, name: "", picture: "", pictureXl: ""), album: Album(id: 0, title: "", cover: ""))
                }
            }
        }
        return song
    }
    
    fileprivate func getSongObservable() -> Observable<[SongList]> {
        return dataSubject
            .flatMap{ [unowned self] _ in
                return self.songRepository.getAll(onPage: self.currentPage)
        }
        .flatMap{ songResponse -> Observable<[SongList]> in
            return Observable.just(songResponse.tracks?.data ?? [SongList]())
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
    }
    
    func initializeDataObservable() -> Disposable{
        let songSubject = getSongObservable()
        return songSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext:{[unowned self] list in
                self.currentPage += 1
                self.checkIfEmpty(list)
                }, onError: {[unowned self] error in
                    self.loaderSubject.onNext(false)
                    self.alertObservable.onNext(.errorAlert(error.localizedDescription))
            })
    }
    
    private func checkIfContainsArtistTrending(artists: [Artist]){
        for cell in screenData{
            if cell.cellType == CellType.Trending{
                return
            }
        }
        self.screenData.append(SongListCell(songList: nil, artistCollection: nil, cellType: .Trending))
    }
    
    fileprivate func checkIfEmpty(_ songs: [SongList]) {
        if songs.isEmpty{
            dataSubject.onNext(())
        }
        else{
            loaderSubject.onNext(false)
            if !checkIfContains(songs: songs){
                for song in songs{
                    screenData.append(SongListCell(songList: song, artistCollection: nil, cellType: .Song))
                }
            }
            dataStatusObservable.onNext(true)
        }
    }
    
    private func checkIfContains(songs: [SongList]) -> Bool{
        for song in songs{
            return screenData.contains { (songListCell) -> Bool in
                if songListCell.cellType == CellType.Song{
                    return songListCell.songList?.title == song.title
                }
                return false
            }
        }
        return false
    }
}
