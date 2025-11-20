//
//  SearchService.swift
//  MovieExplorer
//
//  Created by Ekbana on 20/11/2025.
//

import Foundation

protocol SearchServiceProtocol {
    func fetchSearchResults(query:String) async throws -> [MovieDTO]
}


class SearchService: SearchServiceProtocol {
    func fetchSearchResults(query: String) async throws -> [MovieDTO] {
        guard let url = URL(string: Urls.getSearchUrl(query: query)) else {
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


}
