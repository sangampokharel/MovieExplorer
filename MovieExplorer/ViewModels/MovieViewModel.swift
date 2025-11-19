//
//  MovieViewModel.swift
//  MovieExplorer
//
//  Created by Ekbana on 19/11/2025.
//

import Foundation
import Combine

@MainActor
class MovieViewModel: ObservableObject {

    @Published private(set) var movies: [MovieModel] = []
    @Published private(set) var isLoading: Bool?
    @Published private(set) var movie:MovieModel?
    private var movieService:MovieServiceProtocol?

    init(movieService:MovieServiceProtocol? = nil) {
        self.movieService = movieService
    }

    func fetchMovies() {
        isLoading = true

        Task {
            do {
                guard let moviesDTO = try await movieService?.fetchMovies() else { return }
                self.movies = moviesDTO.map { MovieModel.init(movieDto: $0) }
                isLoading = false
            }catch {
                isLoading = false
                //TODO: Error Handling
                print(error.localizedDescription)
            }
        }
    }

    func fetchMovieDetail(id:Int) {
        isLoading = true
        Task {
            do {
                guard let movieDTO = try await movieService?.fetchMovieDetail(id: id) else { return }
                self.movie = MovieModel.init(movieDto: movieDTO)
                isLoading = false
            }catch {
                isLoading = false
                //TODO: Error Handling
                print(error.localizedDescription)
            }
        }
    }
}
