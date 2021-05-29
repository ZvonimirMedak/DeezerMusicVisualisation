//
//  Song.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 12/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation

struct SongList: Codable{
    let id: Int
    let title: String
    let duration: Int
    let preview: String
    let artist: Artist
    let album: Album
}

