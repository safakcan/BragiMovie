//
//  MovieResponse.swift
//  BragiMovie
//
//  Created by Can Bas on 4.09.2023.
//

import Foundation



struct Movie: Codable {
    let id: Int
    let title: String
    let posterPath: String
    let voteAverage: Double
    let budget: Int?
    let revenue: Int?

    enum CodingKeys: String, CodingKey {
        case id, title
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case budget, revenue
    }
}

struct MovieResponse: Codable {
    let results: [Movie]
}
