//
//  MovieService.swift
//  MovieExplorer
//
//  Created by Ekbana on 19/11/2025.
//
//
import Foundation

protocol MovieServiceProtocol {
    func fetchMovies() async throws -> [MovieDTOs]
    func fetchMovieDetail(id:Int) async throws -> MovieDTOs
}

class MovieService: MovieServiceProtocol {


    func fetchMovies() async throws -> [MovieDTOs] {
        guard let url = URL(string: Constants.movieListURL) else {
            throw NetworkError.invalidUrl
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(Constants.apiToken)", forHTTPHeaderField: "Authorization")
        do {
            let (data, _ ) = try await URLSession.shared.data(for: urlRequest)
            let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
            return movieResponse.results ?? []
        }catch {
            print(error.localizedDescription)
            throw NetworkError.decodingError
        }
    }

    func fetchMovieDetail(id: Int) async throws -> MovieDTOs {
        guard let url = URL(string: Urls.getMovieDetailUrl(id: id)) else {
            throw NetworkError.invalidUrl
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(Constants.apiToken)", forHTTPHeaderField: "Authorization")
        do {
            let (data, _ ) = try await URLSession.shared.data(for: urlRequest)
            let movie = try JSONDecoder().decode(MovieDTOs.self, from: data)
            return movie
        }catch {
            print(error.localizedDescription)
            throw NetworkError.decodingError
        }
    }
}
