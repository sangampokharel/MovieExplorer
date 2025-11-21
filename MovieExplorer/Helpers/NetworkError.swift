//
//  NetworkError.swift
//  MovieExplorer
//
//  Created by Ekbana on 19/11/2025.
//

import Foundation
import SystemConfiguration

enum NetworkError: LocalizedError, Equatable {
    case invalidUrl
    case decodingError
    case noData
    case noInternetConnection
    case serverError(String)
    case searchError(String)
    case filterError(String)

    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "The URL is invalid. Please try again."
        case .decodingError:
            return "Failed to decode server response. Please try again."
        case .noData:
            return "No data received from server. Please check your connection and try again."
        case .noInternetConnection:
            return "No internet connection. Please check your network settings and try again."
        case .serverError(let message):
            return "Server error: \(message). Please try again later."
        case .searchError(let query):
            return "Failed to search for '\(query)'. Please check your connection and try again."
        case .filterError(_):
            return "Failed to apply filter. Please check your connection and try again."
        }
    }
    
    var recoveryAction: String {
        switch self {
        case .noInternetConnection:
            return "Retry"
        case .searchError, .filterError:
            return "Try Offline"
        default:
            return "OK"
        }
    }
    
    var canRetry: Bool {
        switch self {
        case .noInternetConnection, .searchError, .filterError:
            return true
        default:
            return false
        }
    }
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidUrl, .invalidUrl):
            return true
        case (.decodingError, .decodingError):
            return true
        case (.noData, .noData):
            return true
        case (.noInternetConnection, .noInternetConnection):
            return true
        case (.serverError(let lhsMessage), .serverError(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.searchError(let lhsQuery), .searchError(let rhsQuery)):
            return lhsQuery == rhsQuery
        case (.filterError(let lhsFilter), .filterError(let rhsFilter)):
            return lhsFilter == rhsFilter
        default:
            return false
        }
    }
}
