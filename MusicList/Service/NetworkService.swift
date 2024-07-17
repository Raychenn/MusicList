//
//  NetworkService.swift
//  MusicList
//
//  Created by Boray Chen on 2024/7/14.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchMusicList(
        searchText: String,
        completion: @escaping (Result<[MediaItem], APIError>) -> Void
    )
}

final class NetworkService: HTTPDataDownloader, NetworkServiceProtocol {
    
    static let shared = NetworkService()
    
    private init() {}

    private var baseURLComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = "/search"
        return components
    }
    
    private func composedSearchURL(with text: String) -> URL? {
        var components = baseURLComponents
        components.queryItems = [
            URLQueryItem(name: "term", value: text)
        ]
        
        return components.url
    }
    

    
    func fetchMusicList(searchText: String, completion: @escaping (Result<[MediaItem], APIError>) -> Void) {
        guard let searchURL = composedSearchURL(with: searchText) else {
            completion(.failure(.requestFailed(description: "Invalid Endpoint")))
            return
        }
        
        fetchData(as: SearchResponse.self, endPointURL: searchURL) { result in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
