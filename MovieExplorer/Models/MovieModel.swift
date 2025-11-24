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
    
}
