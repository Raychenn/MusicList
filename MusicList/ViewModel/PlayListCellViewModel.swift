//
//  PlayListCellViewModel.swift
//  MusicList
//
//  Created by Boray Chen on 2024/7/15.
//

import Foundation

class PlayListCellViewModel {
    let artworkURLString: String?
    let trackName: String?
    let description: String?
    let trackTime: String
    let previewURLString: String?
    var playStatusText: String?
    var isPlaying: Bool
    
    init(artworkURLString: String?, trackName: String?, description: String?, trackTime: String, previewURLString: String?, playStatusText: String, isPlaying: Bool) {
        self.artworkURLString = artworkURLString
        self.trackName = trackName
        self.description = description
        self.trackTime = trackTime
        self.previewURLString = previewURLString
        self.playStatusText = playStatusText
        self.isPlaying = isPlaying
    }
}
