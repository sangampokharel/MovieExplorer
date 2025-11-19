//
//  MovieDetailDTO.swift
//  MovieExplorer
//
//  Created by Ekbana on 19/11/2025.
//

struct MovieDetailDTO: Decodable {
    let id:Int?
    let title: String?
    let overview: String?
    let posterPath: String?
    let backDropPath: String?
    let adult:Bool?
    let originalLanguage:String?
    let releaseDate:String?
    let revenue:Int?
    let status:String?
    let tagline:String?
    let voteAverage:Double?
    let popularity:Double?
    let runtime:Int?
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backDropPath = "backdrop_path"
        case adult
        case originalLanguage = "original_language"
        case releaseDate = "release_date"
        case revenue
        case status
        case tagline
        case voteAverage = "vote_average"
        case popularity
        case runtime
    }

    var imageUrl:String {
        guard let posterPath else { return ""}
        return "https://image.tmdb.org/t/p/w500\(posterPath)"
    }

    var popularityCalculated:String {
        guard let popularity else { return ""}
        return "Popularity: \(popularity) %"
    }

    var formattedReleaseDate:String {
        guard let releaseDate else { return ""}
        return "Release Date: \(releaseDate)"
    }

    var formattedRunTime:String {
        guard let runtime else { return ""}
        return runtime.formatAsHoursAndMinutes()
    }
}

