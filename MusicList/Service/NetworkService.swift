//
//  NetworkService.swift
//  MusicList
//
//  Created by Boray Chen on 2024/7/14.
//

import Foundation

enum APIError: Error {
    case invalidData
    case jsonParsingFailure
    case requestFailed(description: String)
    case invalidStatusCode(statusCode: Int)
    case unknownError(error: Error)
    
    var customDescription: String {
        switch self {
        case .invalidData: return "Invalid Data"
        case .jsonParsingFailure: return "Failed to parse JSON"
        case .requestFailed(let description): return "Request failed: \(description)"
        case .invalidStatusCode(let statusCode): return "Invalid Status Code: \(statusCode)"
        case .unknownError(let error): return "An unknown error occured: \(error.localizedDescription)"
        }
    }
}

final class NetworkService {
    private let urlString = "https://itunes.apple.com/search?term=jason mars"
    
    static let shared = NetworkService()
    
    private init() {}
    
    func fetchMusicList(completion: @escaping (Result<[MediaItem], APIError>) -> Void) {
        guard let url = URL(string: urlString) else { 
            completion(.failure(.requestFailed(description: "Invalid URL")))
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.unknownError(error: error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed(description: "Request failed")))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.invalidStatusCode(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
                completion(.success(searchResponse.results))
            } catch {
                print("DEBUG: failed to decode with error \(error)")
                completion(.failure(.jsonParsingFailure))
            }
        }.resume()
    }
}
