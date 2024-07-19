//
//  SearchItem.swift
//  MusicList
//
//  Created by Boray Chen on 2024/7/14.
//

import Foundation

struct SearchResponse: Codable {
    let results: [MediaItem]
}

struct MediaItem: Codable {
    let trackName: String?
    let artWorkURL: String?
    let trackTime: Int?
    let longDescription: String?
    let previewURL: String?
    
    enum CodingKeys: String, CodingKey {
        case trackName
        case artWorkURL = "artworkUrl100"
        case trackTime = "trackTimeMillis"
        case longDescription
        case previewURL = "previewUrl"
    }
}

extension Array where Element == MediaItem {
    func toPlayListCellViewModels() -> [PlayListCellViewModel] {
        return self.compactMap { item in
            PlayListCellViewModel(artworkURLString: item.artWorkURL,
                                  trackName: item.trackName,
                                  description: item.longDescription,
                                  trackTime: (item.trackTime ?? 0).formatTime(),
                                  previewURLString: item.previewURL,
                                  playStatusText: "",
                                  isPlaying: false)
        }
    }
}
