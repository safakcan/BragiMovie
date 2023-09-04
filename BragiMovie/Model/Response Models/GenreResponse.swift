//
//  GenreResponse.swift
//  BragiMovie
//
//  Created by Can Bas on 4.09.2023.
//

import Foundation

struct Genre: Codable {
    let id: Int
    let name: String
}

struct GenreResponse: Codable {
    let genres: [Genre]
}
