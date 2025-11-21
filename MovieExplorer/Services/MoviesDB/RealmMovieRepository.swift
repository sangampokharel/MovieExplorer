//
//  RealmMovieRepository.swift
//  MovieExplorer
//
//  Created by Ekbana 25/11/2025.
//

import Foundation
import RealmSwift

class RealmMovieRepository: MoviePersistenceProtocol {
    private let realm: Realm

    init() {
        do {
            self.realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }

    func saveMovies(_ movies: [MovieModel]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                do {
                    try realm.write {
                        for movie in movies {
                            let realmMovie = RealmMovieObject.create(from: movie)
                            realm.add(realmMovie, update: .all)
                        }
                    }
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func fetchMovies() async throws -> [MovieModel] {
        return try await withCheckedThrowingContinuation { continuation in
            let realmMovies = realm.objects(RealmMovieObject.self)

            let movieModels = realmMovies.map { $0.toMovieModel() }
            continuation.resume(returning: Array(movieModels))
        }
    }

    func clearMovies() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                do {
                    try realm.write {
                        realm.deleteAll()
                    }
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func clearMovies(filter: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                do {
                    let moviesToDelete = realm.objects(RealmMovieObject.self)
                        .filter(NSPredicate(format: "category == %@", filter))
                    try realm.write {
                        realm.delete(moviesToDelete)
                    }
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func saveMovie(_ movie: MovieModel) async throws {
        try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                do {
                    try realm.write {
                        let realmMovie = RealmMovieObject.create(from: movie)
                        realm.add(realmMovie, update: .all)
                    }
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func deleteMovie(id: Int) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                do {
                    if let movieToDelete = realm.object(ofType: RealmMovieObject.self, forPrimaryKey: id) {
                        try realm.write {
                            realm.delete(movieToDelete)
                        }
                    }
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
