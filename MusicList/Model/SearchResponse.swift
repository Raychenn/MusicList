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
    
    enum CodingKeys: String, CodingKey {
        case trackName
        case artWorkURL = "artworkUrl100"
        case trackTime = "trackTimeMillis"
        case longDescription
    }
}
