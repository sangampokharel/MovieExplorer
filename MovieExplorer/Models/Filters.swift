//
//  Filters.swift
//  MovieExplorer
//
//  Created by Ekbana on 20/11/2025.
//
import Foundation

struct Filters {
    let title:String
    let isSelected:Bool
    let key:String
    static var data:[Self] {
        [
            Self(
                title: "Popular",
                isSelected: true,
                key: Constants.popularKey
            ),

            Self(
                title: "Revenue",
                isSelected: false,
                key: Constants.revenueKey
            ),

            Self(
                title: "Voted",
                isSelected: false,
                key: Constants.votedKey
            ),
        ]
    }

}
