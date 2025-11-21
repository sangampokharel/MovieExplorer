//
//  MoviePersistenceProtocol.swift
//  MovieExplorer
//
//  Created by Ekbana 25/11/2025.
//

import Foundation

protocol MoviePersistenceProtocol {
    func saveMovies(_ movies: [MovieModel]) async throws
    func fetchMovies(filter: String) async throws -> [MovieModel]
    func clearMovies() async throws
    func saveMovie(_ movie: MovieModel) async throws
    func deleteMovie(id: Int) async throws
}
