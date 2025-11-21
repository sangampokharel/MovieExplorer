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

    @Published var searchText: String = ""
    @Published var moviesSearchList: [MovieModel] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    private let searchService: SearchServiceProtocol
    private var searchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    private var lastSearchQuery: String = ""

    private init(searchService: SearchServiceProtocol) {
        self.searchService = searchService
        setupSearchDebounce()
    }

    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }

    private func performSearch(query: String) {
        searchTask?.cancel()
        lastSearchQuery = query

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

    @available(*, deprecated, message: "Use searchText property instead")
    func search(query: String) {
        Task { @MainActor in
            self.searchText = query
        }
    }

    func clearResults() {
        searchTask?.cancel()
        moviesSearchList.removeAll()
        error = nil
    }

    func retryLastSearch() {
        Task { @MainActor in
            self.searchText = lastSearchQuery
        }
    }
}
