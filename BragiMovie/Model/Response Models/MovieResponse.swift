//
//  MovieResponse.swift
//  BragiMovie
//
//  Created by Can Bas on 4.09.2023.
//

import Foundation

struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let title: String
    let posterPath: String
    let voteAverage: Double
    let releaseDate: String
    let overview: String
    let adult: Bool
    let budget: Int?
    let revenue: Int?
    var fullPath: String {
        "https://image.tmdb.org/t/p/w500/" + posterPath
    }
    enum CodingKeys: String, CodingKey {
        case id, title, adult, overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case budget, revenue
    }
}

extension Movie: DetailDisplayable {
    var rating: String { return  String(voteAverage) }
    var name: String { return title }
    var description: String { return overview }
    var imageUrlString: String? { return fullPath }
}
