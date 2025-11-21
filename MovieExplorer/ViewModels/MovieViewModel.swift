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
    @Published var error: Error?
    private(set) var page = 0
    private(set) var hasMorePages = true
    private var movieService: MovieServiceProtocol?
    private let offlineMovieService = OfflineMovieService()
    private var currentFilter: String = Constants.popularKey
    private var lastFetchFilter: String = Constants.popularKey

    init(movieService: MovieServiceProtocol? = nil) {
        self.movieService = movieService
        loadCachedMoviesOnLaunch()
        checkNetworkConnection()
    }

    func fetchMovies(filter: String = Constants.popularKey) {
        currentFilter = filter
        lastFetchFilter = filter

        error = nil

        Task {
            await loadCachedMovies()
        }

        guard isNetworkAvailable() else {
            error = NetworkError.noInternetConnection
            return
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
                    if movies.isEmpty {
                        error = NetworkError.noData
                    }
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
                self.error = error
                if error is NetworkError {
                    await loadCachedMovies()
                }

            }
        }
    }

    private func checkNetworkConnection() {
        if !isNetworkAvailable() {
            error = NetworkError.noInternetConnection
        }
    }

    private func isNetworkAvailable() -> Bool {
        return NetworkMonitor.shared.isConnected
    }

    private func loadCachedMoviesOnLaunch() {
        Task {
            await loadCachedMovies()
        }
    }

    private func loadCachedMovies() async {
        let cachedMovies = await offlineMovieService.getCachedMovies()
        if !cachedMovies.isEmpty {
            await MainActor.run {
                if self.page == 0 || self.movies.isEmpty {
                    self.movies = cachedMovies
                }
            }
        } else if movies.isEmpty && error == nil && page == 0 {
            await MainActor.run {
                if !isNetworkAvailable() {
                    self.error = NetworkError.noInternetConnection
                }
            }
        }
    }

    func refreshMovies(filter: String = Constants.popularKey) {
        resetPagination()
        error = nil
        Task {
            await offlineMovieService.clearMovies()
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
        error = nil
    }

    func fetchMovieDetail(id: Int) {
        error = nil

        guard isNetworkAvailable() else {
            error = NetworkError.noInternetConnection
            return
        }

        isLoading = true
        Task {
            do {
                guard let movieDetailDTO = try await movieService?.fetchMovieDetail(id: id) else {
                    self.error = NetworkError.noData
                    isLoading = false
                    return
                }
                self.movie = MovieDetailModel(movieDetailDTO: movieDetailDTO)
                isLoading = false
            } catch {
                self.error = error
                isLoading = false
            }
        }
    }

    func retryLastOperation() {
        if let filter = currentFilter as String? {
            fetchMovies(filter: filter)
        }
    }
}

