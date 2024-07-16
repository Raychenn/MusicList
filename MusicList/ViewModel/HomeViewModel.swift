//
//  HomeViewModel.swift
//  MusicList
//
//  Created by Boray Chen on 2024/7/15.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func didLoadData(_ self: HomeViewModel)
    func didUpdateUI(_ self: HomeViewModel, playStatusText: String?, indexPath: IndexPath)
    func didFailToFetchData(_ self: HomeViewModel, error: APIError)
}

protocol HomeViewModelProtocol {
    func fetchMediaItems(with text: String)
    func numberOfItems() -> Int
    func cellForItemAt(_ indexPath: IndexPath) -> PlayListCellViewModel
    func selectItem(at index: Int)
    var delegate: HomeViewModelDelegate? { get set }
}

class HomeViewModel: HomeViewModelProtocol {
    
    weak var delegate: HomeViewModelDelegate?
    
    private var mediaItems: [MediaItem]?
    
    var selectedIndex: Int?
    
    private var playListCellViewModels: [PlayListCellViewModel] = []
    
    func numberOfItems() -> Int {
        playListCellViewModels.count
    }
    
    func cellForItemAt(_ indexPath: IndexPath) -> PlayListCellViewModel {
        playListCellViewModels[indexPath.row]
    }
        
    func fetchMediaItems(with text: String) {
        NetworkService.shared.fetchMusicList(searchText: text) { [weak self] result in
            guard let self else {
                return
            }
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self.playListCellViewModels = self.map(items)
                    self.delegate?.didLoadData(self)
                case .failure(let error):
                    self.delegate?.didFailToFetchData(self, error: error)
                }
            }
        }
    }
    
    func map(_ mediaItems: [MediaItem]) -> [PlayListCellViewModel] {
        return mediaItems.compactMap { item in
            return PlayListCellViewModel(artworkURLString: item.artWorkURL,
                                         trackName: item.trackName,
                                         description: item.longDescription,
                                         trackTime: formatTime(seconds: item.trackTime ?? 0),
                                         previewURLString: item.previewURL,
                                         playStatusText: "",
                                         isPlaying: false)
        }
    }
    
    func selectItem(at index: Int) {
        guard index >= 0 && index < playListCellViewModels.count else { return }
        // Deselect previously selected item
        if let previousIndex = selectedIndex, previousIndex != index {
            playListCellViewModels[previousIndex].isPlaying = false
            playListCellViewModels[previousIndex].playStatusText = nil
            delegate?.didUpdateUI(self, playStatusText: nil, indexPath: IndexPath(item: previousIndex, section: 0))
        }
        
        selectedIndex = index
        playListCellViewModels[index].isPlaying.toggle()
        playListCellViewModels[index].playStatusText = playListCellViewModels[index].isPlaying ? "正在播放 ▶️" : "正在播放 ⏸️"
        delegate?.didUpdateUI(self, playStatusText: playListCellViewModels[index].playStatusText, indexPath: IndexPath(item: index, section: 0))
    }
    
    func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}
