//
//  HomeViewModel.swift
//  MusicList
//
//  Created by Boray Chen on 2024/7/15.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func didFetchMediaItems(_ self: HomeViewModel, items: [MediaItem])
    func didFailToFetchMediaItems(_ self: HomeViewModel, error: APIError)
}

class HomeViewModel {
    
    weak var delegate: HomeViewModelDelegate?
    
    var mediaItems: [MediaItem]?
    
    
    func fetchMediaItems() {
        NetworkService.shared.fetchMusicList { [weak self] result in
            guard let self else { 
                return
            }
            switch result {
            case .success(let items):
                print("items: \(items)")
                self.mediaItems = items
            case .failure(let error):
                self.delegate?.didFailToFetchMediaItems(self, error: error)
                print("error: \(error)")
            }
        }
    }
}
