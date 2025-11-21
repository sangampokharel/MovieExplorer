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
    private let offlineMovieService = OfflineMovieService()
    private var currentFilter: String = Constants.popularKey

    init(movieService: MovieServiceProtocol? = nil) {
        self.movieService = movieService
        loadCachedMoviesOnLaunch()
    }

    func fetchMovies(filter: String = Constants.popularKey) {
        currentFilter = filter

        Task {
            await loadCachedMovies()
        }

        guard !isPaginating && !isLoading && hasMorePages else { return }

        page += 1
        if page == 1 {
            isLoading = true
        } else {
            isPaginating = true
        }

        Task {
            do {
                guard let moviesDTO = try await movieService?.fetchMovies(page: page, filter: filter) else {
                    resetLoadingStates()
                    await loadCachedMovies()
                    return
                }

                let newMovies = moviesDTO.map { MovieModel(movieDto: $0) }

                if page == 1 {
                    self.movies = newMovies
                    await offlineMovieService.cacheMovies(newMovies)
                } else {
                    self.movies.append(contentsOf: newMovies)
                }

                if newMovies.isEmpty {
                    hasMorePages = false
                }

                resetLoadingStates()
            } catch {
                resetLoadingStates()
                await loadCachedMovies()
                print("Error fetching movies: \(error.localizedDescription)")
            }
        }
    }

    private func loadCachedMoviesOnLaunch() {
        Task {
            await loadCachedMovies()
        }
    }

    private func loadCachedMovies() async {
        let cachedMovies = await offlineMovieService.getCachedMovies(filter: currentFilter)
        if !cachedMovies.isEmpty {
            await MainActor.run {
                if self.page == 0 || self.movies.isEmpty {
                    self.movies = cachedMovies
                }
            }
        }
    }

    func refreshMovies(filter: String = Constants.popularKey) {
        resetPagination()
        Task {
            await offlineMovieService.clearCache()
        }
        fetchMovies(filter: filter)
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
