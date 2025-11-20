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
    static let shared = SearchViewModel()
    @Published private(set) var moviesSearchList: [MovieModel] = []
    @Published private(set) var isLoading: Bool = false
    private let service = SearchService()
    
    private init() {}

    func search(query: String) {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            clearResults()
            return
        }
        
        isLoading = true
        Task {
            do {
                let searchResultsDtos = try await service.fetchSearchResults(query: query)
                let mappedMovies = searchResultsDtos.map { MovieModel(movieDto: $0) }
                self.moviesSearchList = mappedMovies
                isLoading = false
            } catch {
                isLoading = false
                print(error.localizedDescription)
            }
        }
    }
    
    func clearResults() {
        moviesSearchList.removeAll()
        isLoading = false
    }
}
