//
//  TVShowsResponse.swift
//  BragiMovie
//
//  Created by Can Bas on 5.09.2023.
//

import Foundation

struct TVShowsResponse: Decodable {
//    let page: Int
    let results: [TVShow]
//    let totalPages: Int
//    let totalResults: Int
}

struct TVShow: Decodable {
    let id: Int
    let name: String
    let firstAirDate: String
    let genreIds: [Int]
    let backdropPath: String?
    let originCountry: [String]
    let originalLanguage: String
    let originalName: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let voteAverage: Double
    let voteCount: Double
    var fullPath: String {
        "https://image.tmdb.org/t/p/w500/" + (posterPath ?? "")
    }

    enum CodingKeys: String, CodingKey {
        case id, name, overview, popularity
        case firstAirDate = "first_air_date"
        case genreIds = "genre_ids"
        case backdropPath = "backdrop_path"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension TVShow: DetailDisplayable {
    var releaseDate: String { return firstAirDate }
    var rating: String { String(voteAverage) }
    var description: String { overview }
    var imageUrlString: String? { return fullPath}
}
