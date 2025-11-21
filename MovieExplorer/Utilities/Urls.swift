//
//  Urls.swift
//  MovieExplorer
//
//  Created by Ekbana on 20/11/2025.
//


struct Urls {
    static let baseUrl = "https://api.themoviedb.org/3"
    static func getMovieListUrl(page:Int = 1,filter:String = Constants.popularKey) -> String {
        return "\(baseUrl)/discover/movie?include_adult=false&include_video=false&language=en-US&page=\(page)&sort_by=\(filter)"
    }

    static func getMovieDetailUrl(id:Int) -> String {
        return "\(baseUrl)/movie/\(id)"
    }

    static func getSearchUrl(query:String) -> String {
        return "\(baseUrl)/search/movie?query=\(query)&include_adult=false&language=en-US&page=1"
    }
}
