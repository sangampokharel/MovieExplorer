//
//  MovieModel.swift
//  MovieExplorer
//
//  Created by Ekbana on 19/11/2025.
//

struct MovieModel {
    let imageUrl: String
    let movieName: String
    let movieDescription: String

    static var mocks: [Self] = [
        MovieModel(
            imageUrl: "https://picsum.photos/300/400?random=1",
            movieName: "Inception",
            movieDescription: "A thief enters dreams to steal valuable secrets."
        ),
        MovieModel(
            imageUrl: "httpsum.photos/300/400?random=2",
            movieName: "Interstellar",
            movieDescription: "A team travels through a wormhole searching for a new home."
        ),
        MovieModel(
            imageUrl: "https://picsum.photos/300/400?random=3",
            movieName: "The Dark Knight",
            movieDescription: "Batman faces the Joker in a battle for Gotham."
        ),
        MovieModel(
            imageUrl: "https://picsum.photos/300/400?random=4",
            movieName: "Avatar",
            movieDescription: "A marine on an alien world becomes part of a native tribe."
        ),
        MovieModel(
            imageUrl: "https://picsum.photos/300/400?random=5",
            movieName: "Titanic",
            movieDescription: "A tragic love story aboard the Titanic."
        ),
        MovieModel(
            imageUrl: "https://picsum.photos/300/400?random=6",
            movieName: "The Matrix",
            movieDescription: "A hacker discovers the shocking truth about reality."
        ),
        MovieModel(
            imageUrl: "https://picsum.photos/300/400?random=7",
            movieName: "Gladiator",
            movieDescription: "A betrayed general seeks revenge through the arena."
        ),
        MovieModel(
            imageUrl: "https://picsum.photos/300/400?random=8",
            movieName: "Avengers: Endgame",
            movieDescription: "The Avengers unite to defeat Thanos and restore balance."
        ),
        MovieModel(
            imageUrl: "https://picsum.photos/300/400?random=9",
            movieName: "Jurassic Park",
            movieDescription: "A theme park with cloned dinosaurs spirals into chaos."
        ),
        MovieModel(
            imageUrl: "https://picsum.photos/300/400?random=10",
            movieName: "The Shawshank Redemption",
            movieDescription: "A man wrongly imprisoned forms a deep friendship behind bars."
        )
    ]

    static var mock: Self {
        mocks[0]
    }
}
