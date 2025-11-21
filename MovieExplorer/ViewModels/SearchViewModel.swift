//
//  SearchViewModel.swift
//  MovieExplorer
//
//  Created by Ekbana on 20/11/2025.
//
import Foundation
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    static let shared: SearchViewModel = {
        let searchService: SearchServiceProtocol = SearchService()
        return SearchViewModel(searchService: searchService)
    }()

    @Published var moviesSearchList: [MovieModel] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    private let searchService: SearchServiceProtocol
    private var searchTask: Task<Void, Never>?

    private init(searchService: SearchServiceProtocol) {
        self.searchService = searchService
    }

    func search(query: String) {
        searchTask?.cancel()

        guard !query.isEmpty else {
            clearResults()
            return
        }

        error = nil

        guard NetworkMonitor.shared.isConnected else {
            error = NetworkError.noInternetConnection
            return
        }

        searchTask = Task {
            isLoading = true

            do {
                let moviesDTO = try await searchService.fetchSearchResults(query: query)
                let newMovies = moviesDTO.map { MovieModel(movieDto: $0) }
                moviesSearchList = newMovies
                isLoading = false
            } catch {
                self.error = NetworkError.searchError(query)
                isLoading = false
            }
        }
    }

    func clearResults() {
        searchTask?.cancel()
        moviesSearchList.removeAll()
        error = nil
    }

    func retryLastSearch(query: String) {
        search(query: query)
    }
}
