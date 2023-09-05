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
    let releaseDate: String
    let adult: Bool
    let budget: Int?
    let revenue: Int?
    var fullPath: String {
        "https://image.tmdb.org/t/p/w500/" + posterPath
    }
    enum CodingKeys: String, CodingKey {
        case id, title, adult
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case budget, revenue
    }
}

struct MovieResponse: Codable {
    let results: [Movie]
}
