//
//  HTTPDataDownloader.swift
//  MusicList
//
//  Created by Boray Chen on 2024/7/15.
//

import Foundation

protocol HTTPDataDownloader {
    func fetchData<T>(
        as type: T.Type,
        endPointURL: URL?,
        completion: @escaping (Result<T, APIError>) -> Void
    ) where T : Decodable
}

extension HTTPDataDownloader {
    func fetchData<T: Decodable>(as type: T.Type,
                                 endPointURL: URL?,
                                 completion: @escaping (Result<T, APIError>) -> Void)
    {
        guard let url = endPointURL else {
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
                let responseObject = try JSONDecoder().decode(type, from: data)
                completion(.success(responseObject))
            } catch {
                print("DEBUG: failed to decode with error \(error)")
                completion(.failure(.jsonParsingFailure))
            }
        }.resume()
    }
}
