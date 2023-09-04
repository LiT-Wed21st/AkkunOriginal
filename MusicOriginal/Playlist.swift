//
//  Playlist.swift
//  MusicOriginal
//
//  Created by Yuri Tsuchikawa on 2023/09/04.
//

import Foundation
import RealmSwift
import MusicKit

class Playlist: Object {
    @Persisted var duration = 0.0
    @Persisted var songIDs = List<String>()
    @Persisted var artistIDs = List<String>()
    @Persisted var createdAt = Date()
    @Persisted var error = 0.0
    
    convenience init(duration: TimeInterval, songs: [Song], artists: [Artist], error: TimeInterval) {
        self.init()
        
        let songIDList = List<String>()
        let songIDs = songs.map({ song in
            song.id.rawValue
        })
        songIDList.append(objectsIn: songIDs)
        
        let artistIDList = List<String>()
        let artistIDs = artists.map({ artist in
            artist.id.rawValue
        })
        artistIDList.append(objectsIn: artistIDs)
        
        self.duration = duration
        self.songIDs = songIDList
        self.artistIDs = artistIDList
        self.createdAt = Date()
        self.error = error
    }
}
