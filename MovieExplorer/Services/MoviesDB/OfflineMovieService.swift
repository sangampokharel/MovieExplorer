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
            await clearMovies()
            try await persistenceRepository.saveMovies(movies)
        } catch {
            print("Failed to cache movies: \(error.localizedDescription)")
        }
    }
    
    func getCachedMovies() async -> [MovieModel] {
        do {
            return try await persistenceRepository.fetchMovies()
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
    
     func clearMovies() async {
        do {
            try await persistenceRepository.clearMovies()
        } catch {
            print("Failed to clear movies : \(error.localizedDescription)")
        }
    }
}
