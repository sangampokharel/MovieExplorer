//
//  SearchViewModel.swift
//  MovieExplorer
//
//  Created by Ekbana on 20/11/2025.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {

    @Published private(set) var moviesSearchList:[MovieModel] = []
    @Published private(set) var isLoading:Bool?
    private var service:SearchServiceProtocol!

    init(service:SearchServiceProtocol) {
        self.service = service
    }

    func search(query:String) {
        isLoading = true
        Task {
            do{
               let searchResultsDtos = try await service.fetchSearchResults(query: query)
                self.moviesSearchList.append(contentsOf: searchResultsDtos.map { MovieModel(movieDto: $0)} )
                isLoading = false
            }catch {
                isLoading = false
                print(error.localizedDescription)
            }
        }
    }
}
