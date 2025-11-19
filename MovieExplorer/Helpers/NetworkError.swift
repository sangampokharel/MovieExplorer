//
//  NetworkError.swift
//  MovieExplorer
//
//  Created by Ekbana on 19/11/2025.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidUrl
    case decodingError
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "URL is Invalid"
        case .decodingError:
            return "Failed to decode response"
        case .noData:
            return "No data received"
        }
    }
}
