//
//  MockNetworkService.swift
//  MusicList
//
//  Created by Boray Chen on 2024/7/17.
//

import Foundation

class MockNetworkService: NetworkServiceProtocol, HTTPDataDownloader {
    
    var mockData: Data?
    var mockError: APIError?
    
    init() {}
    
    func fetchMusicList(searchText: String, completion: @escaping (Result<[MediaItem], APIError>) -> Void) {
        if let mockError {
            completion(.failure(mockError))
            return
        }
        
        do {
            let musicListResponse = try JSONDecoder().decode(SearchResponse.self, from: mockData ?? testMusicListData)
            completion(.success(musicListResponse.results))
        } catch {
            completion(.failure(.jsonParsingFailure))
        }
    }
}
