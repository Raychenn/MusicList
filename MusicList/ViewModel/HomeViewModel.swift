//
//  HomeViewModel.swift
//  MusicList
//
//  Created by Boray Chen on 2024/7/15.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {    
    func homeViewModelDidLoadData(_ self: HomeViewModel)
    func homeViewModel(_ self: HomeViewModel, didUpdateUIWithPlayStatusText playStatusText: String?, indexPath: IndexPath)
    func homeViewModel(_ self: HomeViewModel, didFailToFetchDataWithError error: APIError)
    func homeViewModel(_ self: HomeViewModel, didFailToLoadPlayerWithError error: Error)
    func homeViewModelDidStartLoading(_ self: HomeViewModel)
    func homeViewModelDidFinishLoading(_ self: HomeViewModel)
}

protocol HomeViewModelProtocol {
    func fetchMediaItems(with text: String)
    func numberOfItems() -> Int
    func cellForItemAt(_ indexPath: IndexPath) -> PlayListCellViewModel
    func selectItem(at index: Int)
    
    func play(url: URL) throws
    func pause()
    func resetPlayer(completion: () -> Void)
    
    var delegate: HomeViewModelDelegate? { get set }
}

class HomeViewModel: HomeViewModelProtocol {
    
    // MARK: - Properties
    
    weak var delegate: HomeViewModelDelegate?
    
    private var mediaItems: [MediaItem]?
    
    private(set) var selectedIndex: Int?
    
    private(set) var playListCellViewModels: [PlayListCellViewModel] = []
    
    private let service: NetworkServiceProtocol
    
    private let player: AudioPlayerProtocol
    
    // MARK: - Life cycle
    
    init(service: NetworkServiceProtocol, audioPlayer: AudioPlayerProtocol) {
        self.service = service
        self.player = audioPlayer
    }
    
    // MARK: - Helpers
    
    func numberOfItems() -> Int {
        playListCellViewModels.count
    }
    
    func cellForItemAt(_ indexPath: IndexPath) -> PlayListCellViewModel {
        playListCellViewModels[indexPath.row]
    }
        
    func fetchMediaItems(with text: String) {
        DispatchQueue.main.async { self.delegate?.homeViewModelDidStartLoading(self) }
        service.fetchMusicList(searchText: text) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.delegate?.homeViewModelDidFinishLoading(self)
                
                switch result {
                case .success(let items):
                    self.playListCellViewModels = items.toPlayListCellViewModels()
                    self.delegate?.homeViewModelDidLoadData(self)
                    
                case .failure(let error):
                    self.delegate?.homeViewModel(self, didFailToFetchDataWithError: error)
                }
            }
        }
    }
    
    func map(_ mediaItems: [MediaItem]) -> [PlayListCellViewModel] {
        return mediaItems.compactMap { item in
            return PlayListCellViewModel(artworkURLString: item.artWorkURL,
                                         trackName: item.trackName,
                                         description: item.longDescription,
                                         trackTime: (item.trackTime ?? 0).formatTime(),
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
            delegate?.homeViewModel(self, didUpdateUIWithPlayStatusText: nil, indexPath: IndexPath(item: previousIndex, section: 0))
        }
        
        selectedIndex = index
        playListCellViewModels[index].isPlaying.toggle()
        let isPlaying = playListCellViewModels[index].isPlaying
        playListCellViewModels[index].playStatusText = isPlaying ? "正在播放 ▶️" : "正在播放 ⏸️"
        delegate?.homeViewModel(self, didUpdateUIWithPlayStatusText: playListCellViewModels[index].playStatusText, indexPath: IndexPath(item: index, section: 0))
        
        guard let targetAudioURLString = playListCellViewModels[index].previewURLString,
           let audioURL = URL(string: targetAudioURLString) else {
            return
        }
        
        resetPlayer {
            do {
                if isPlaying {
                    try play(url: audioURL)
                } else {
                    pause()
                }
            } catch {
                delegate?.homeViewModel(self, didFailToLoadPlayerWithError: error)
            }
        }
    }
    
    func formatTime(seconds: Int) -> String {
        let totalSeconds = seconds / 1000
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Player

extension HomeViewModel {
    func play(url: URL) throws {
        try player.load(url: url)
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func resetPlayer(completion: () -> Void) {
        player.reset()
        completion()
    }
}
