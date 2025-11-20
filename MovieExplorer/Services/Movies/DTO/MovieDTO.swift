//
//  MovieDTOs.swift
//  MovieExplorer
//
//  Created by Ekbana on 19/11/2025.
//
import Foundation

struct MovieDTO: Decodable {
    let id:Int?
    let title: String?
    let overview: String?
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
    }
    
    var imageUrl:String {
        guard let posterPath else { return ""}
        return "https://image.tmdb.org/t/p/w200\(posterPath)"
    }
}
