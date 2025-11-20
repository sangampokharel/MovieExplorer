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
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isPaginating: Bool = false
    @Published private(set) var movie: MovieDetailModel?
    private(set) var page = 0
    private(set) var hasMorePages = true
    private var movieService: MovieServiceProtocol?

    init(movieService: MovieServiceProtocol? = nil) {
        self.movieService = movieService
    }

    func fetchMovies(filter:String = Constants.popularKey) {
        guard !isPaginating && !isLoading && hasMorePages else { return }
        page += 1
        if page == 1 {
            isLoading = true
        } else {
            isPaginating = true
        }
        Task {
            do {
                guard let moviesDTO = try await movieService?.fetchMovies(page: page,filter:filter) else {
                    resetLoadingStates()
                    return
                }
                let newMovies = moviesDTO.map { MovieModel(movieDto: $0) }
                if page == 1 {
                    self.movies = newMovies
                } else {
                    self.movies.append(contentsOf: newMovies)
                }

                if newMovies.isEmpty {
                    hasMorePages = false
                }

                resetLoadingStates()
            } catch {
                resetLoadingStates()
                // TODO: Better error handling - show alert or error state
                print("Error fetching movies: \(error.localizedDescription)")
            }
        }
    }

    private func resetLoadingStates() {
        isLoading = false
        isPaginating = false
    }

    func resetPagination() {
        page = 0
        hasMorePages = true
        movies.removeAll()
    }

    func fetchMovieDetail(id: Int) {
        isLoading = true
        Task {
            do {
                guard let movieDetailDTO = try await movieService?.fetchMovieDetail(id: id) else { return }
                self.movie = MovieDetailModel(movieDetailDTO: movieDetailDTO)
                isLoading = false
            } catch {
                isLoading = false
                // TODO: Error Handling
                print(error.localizedDescription)
            }
        }
    }
}
