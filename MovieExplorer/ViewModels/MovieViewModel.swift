//
//  MovieViewModel.swift
//  MovieExplorer
//
//  Created by Ekbana on 19/11/2025.
//

import Foundation
import Combine

class MovieViewModel: ObservableObject {

    @Published private(set) var movies: [MovieModel] = []
    @Published private(set) var isLoading: Bool?
    @Published private(set) var movie:MovieModel?

    func fetchMovies() {
        isLoading = true
        Task {
            try await Task.sleep(nanoseconds: 2_000_000_000)
            movies = MovieModel.mocks
            isLoading = false
        }
    }

    func fetchMovieDetail(id:String) {
        isLoading = true
        Task {
            try await Task.sleep(nanoseconds: 2_000_000_000)
            movie = .mock
            isLoading = false
        }
    }
}
