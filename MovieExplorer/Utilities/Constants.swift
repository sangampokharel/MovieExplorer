//
//  Constants.swift
//  MovieExplorer
//
//  Created by Ekbana on 18/11/2025.
//

struct Constants {
    static let movieTableViewCell = "MovieTableViewCell"
    static let movieListURL = "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc"
    static let apiToken =  """
        eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2Mjk1OGI4ODhhZmNkNGNkMzA5ZDI2NGJhZTUzZmJiYyIsIm5iZiI6MTY5NzI5NzA5Ni45MSwic3ViIjoiNjUyYWIyYzgwMjRlYzgwMTFlMzM1YmYyIiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.aUO1vKKGYJswRNm-GrakUlfOFKXgDNisD6MnpuoFoTk
"""
}

struct Urls {

    static func getMovieListUrl() -> String {
        return Constants.movieListURL
    }

    static func getMovieDetailUrl(id:Int) -> String {
        return "https://api.themoviedb.org/3/movie/\(id)"
    }
}
