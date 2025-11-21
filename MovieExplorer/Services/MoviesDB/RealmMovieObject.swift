//
//  RealmMovieObject.swift
//  MovieExplorer
//
//  Created by Ekbana 25/11/2025.
//

import RealmSwift
import Foundation
internal import Realm

@MainActor
class RealmMovieObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String
    @Persisted var overview: String
    @Persisted var posterPath: String
    @Persisted var category: String
    @Persisted var savedAt: Date

    nonisolated override init() {}

    @MainActor
    func configure(from movieModel: MovieModel) {
        self.id = movieModel.id
        self.title = movieModel.movieName
        self.overview = movieModel.movieDescription
        self.posterPath = movieModel.imageUrl
        self.savedAt = Date()
    }
    
    func toMovieModel() -> MovieModel {
        return MovieModel(
            id: self.id,
            imageUrl: self.posterPath,
            movieName: self.title,
            movieDescription: self.overview
        )
    }
    
    @MainActor
    static func create(from movieModel: MovieModel) -> RealmMovieObject {
        let realmMovie = RealmMovieObject()
        realmMovie.configure(from: movieModel)
        return realmMovie
    }
}
