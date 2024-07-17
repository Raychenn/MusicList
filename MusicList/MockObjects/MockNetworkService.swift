//
//  MockNetworkService.swift
//  MusicList
//
//  Created by Boray Chen on 2024/7/17.
//

import Foundation

class MockNetworkService: HTTPDataDownloader, NetworkServiceProtocol {
    
    static let shared = MockNetworkService()
    
    var mockData: Data?
    var mockError: APIError?
    
    private init() {}
    
    func fetchMusicList(searchText: String, completion: @escaping (Result<[MediaItem], APIError>) -> Void) {
        if let mockError { completion(.failure(mockError)) }
        
        do {
            let musicListResponse = try JSONDecoder().decode(SearchResponse.self, from: mockData ?? testMusicListData)
            completion(.success(musicListResponse.results))
        } catch {
            completion(.failure(.jsonParsingFailure))
        }
    }
}
