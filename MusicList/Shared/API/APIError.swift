//
//  APIError.swift
//  MusicList
//
//  Created by Boray Chen on 2024/7/15.
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
