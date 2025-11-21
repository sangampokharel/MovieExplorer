//
//  OfflineMovieService.swift
//  MovieExplorer
//
//  Created by Ekbana 25/11/2025.
//

import Foundation

class OfflineMovieService {
    private let persistenceRepository: MoviePersistenceProtocol
    
    init(persistenceRepository: MoviePersistenceProtocol = RealmMovieRepository()) {
        self.persistenceRepository = persistenceRepository
    }
    
    func cacheMovies(_ movies: [MovieModel]) async {
        do {
            try await persistenceRepository.saveMovies(movies)
            print("Successfully cached \(movies.count) movies")
        } catch {
            print("Failed to cache movies: \(error.localizedDescription)")
        }
    }
    
    func getCachedMovies(filter: String = "default") async -> [MovieModel] {
        do {
            return try await persistenceRepository.fetchMovies(filter: filter)
        } catch {
            print("Failed to fetch cached movies: \(error.localizedDescription)")
            return []
        }
    }
    
    func clearCache() async {
        do {
            try await persistenceRepository.clearMovies()
        } catch {
            print("Failed to clear cache: \(error.localizedDescription)")
        }
    }
}
