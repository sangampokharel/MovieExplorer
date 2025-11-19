//
//  MovieResponse.swift
//  MovieExplorer
//
//  Created by Ekbana on 19/11/2025.
//

import Foundation

struct MovieResponse: Decodable {
    let page:Int?
    let results: [MovieDTOs]?
    let totalPage:Int?
    let totalResults:Int?

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPage = "total_pages"
        case totalResult = "total_results"
    }

    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try? values.decode(Int.self, forKey: .page)
        results = try? values.decode([MovieDTOs].self, forKey: .results)
        totalPage = try? values.decode(Int.self, forKey: .totalPage)
        totalResults = try? values.decode(Int.self, forKey: .totalResult)
    }
}
