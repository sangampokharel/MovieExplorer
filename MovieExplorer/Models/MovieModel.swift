//
//  MovieModel.swift
//  MovieExplorer
//
//  Created by Ekbana on 19/11/2025.
//
import Foundation

struct MovieModel: Equatable {
    let id: Int
    let imageUrl: String
    let movieName: String
    let movieDescription: String

    init(id: Int, imageUrl: String, movieName: String, movieDescription: String) {
        self.id = id
        self.imageUrl = imageUrl
        self.movieName = movieName
        self.movieDescription = movieDescription
    }

    init(movieDto: MovieDTO) {
        self.id = movieDto.id ?? 0
        self.movieName = movieDto.title ?? ""
        self.movieDescription = movieDto.overview ?? ""
        self.imageUrl = movieDto.imageUrl
    }

    static var mocks: [Self] = [
        MovieModel(
            id: 1,
            imageUrl: "https://picsum.photos/300/400?random=1",
            movieName: "Inception",
            movieDescription: "A thief enters dreams to steal valuable secrets."
        ),
        MovieModel(
            id: 2,
            imageUrl: "httpsum.photos/300/400?random=2",
            movieName: "Interstellar",
            movieDescription: "A team travels through a wormhole searching for a new home."
        ),
        MovieModel(
            id: 3,
            imageUrl: "https://picsum.photos/300/400?random=3",
            movieName: "The Dark Knight",
            movieDescription: "Batman faces the Joker in a battle for Gotham."
        ),
        MovieModel(
            id: 3,
            imageUrl: "https://picsum.photos/300/400?random=4",
            movieName: "Avatar",
            movieDescription: "A marine on an alien world becomes part of a native tribe."
        ),
        MovieModel(
            id: 3,
            imageUrl: "https://picsum.photos/300/400?random=5",
            movieName: "Titanic",
            movieDescription: "A tragic love story aboard the Titanic."
        ),

    ]

    static var mock: Self {
        mocks[0]
    }
}
