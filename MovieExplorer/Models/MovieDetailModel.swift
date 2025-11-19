//
//  MovieDetailModel.swift
//  MovieExplorer
//
//  Created by Ekbana on 19/11/2025.
//

struct MovieDetailModel: Decodable {
    let title: String
    let overview: String
    let posterPath: String
    let adult:Bool
    let originalLanguage:String
    let releaseDate:String
    let revenue:Int
    let status:String
    let tagline:String
    let voteAverage:Double
    let popularity:String
    let duration:String
    init(movieDetailDTO:MovieDetailDTO) {
        title = movieDetailDTO.title ?? ""
        overview = movieDetailDTO.overview ?? ""
        posterPath = movieDetailDTO.imageUrl
        adult = movieDetailDTO.adult ?? false
        originalLanguage = movieDetailDTO.originalLanguage ?? ""
        releaseDate = movieDetailDTO.formattedReleaseDate
        revenue = movieDetailDTO.revenue ?? 0
        status = movieDetailDTO.status ?? ""
        tagline = movieDetailDTO.tagline ?? ""
        voteAverage = movieDetailDTO.voteAverage ?? 0.0
        popularity = movieDetailDTO.popularityCalculated
        duration = movieDetailDTO.formattedRunTime
    }
    
}
