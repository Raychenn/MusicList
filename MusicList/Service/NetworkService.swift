//
//  NetworkService.swift
//  MusicList
//
//  Created by Boray Chen on 2024/7/14.
//

import Foundation

final class NetworkService: HTTPDataDownloader {
    private let urlString = "https://itunes.apple.com/search?term=jason mars"
    private var baseURLComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = "/search"
        return components
    }
    
    private func composedSearchURLString(with text: String) -> String? {
        var components = baseURLComponents
        components.queryItems = [
            .init(name: "term", value: text)
        ]
        
        return components.url?.absoluteString
    }
    
    static let shared = NetworkService()
    
    private init() {}
    
    func fetchMusicList(searchText: String, completion: @escaping (Result<[MediaItem], APIError>) -> Void) {
        guard let searchURLString = composedSearchURLString(with: searchText) else {
            completion(.failure(.requestFailed(description: "Invalid Endpoint")))
            return
        }
        fetchData(as: SearchResponse.self, endPoint: searchURLString) { result in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
