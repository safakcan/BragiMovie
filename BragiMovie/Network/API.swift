//
//  API.swift
//  BragiMovie
//
//  Created by Can Bas on 4.09.2023.
//

import Foundation
import RxSwift


enum ContentType {
    case movie
    case tvShow

    var genreEndpoint: String {
        switch self {
        case .movie: return "genre/movie/list"
        case .tvShow: return "genre/tv/list"
        }
    }
}

protocol APIService {
    func fetchGenres(for contentType: ContentType) -> Observable<[Genre]>
    func fetchMovies(for genre: Genre, page: Int) -> Observable<[Movie]>
    func fetchTVShows(for genre: Genre, page: Int) -> Observable<[TVShow]>
}

class TMDBAPIService: APIService {
    private let apiKey = "4f9da36791283d432b3658ba4274469e"
    private let baseURL = URL(string: "https://api.themoviedb.org/3/")!

    // MARK: - Fetch Methods

    func fetchGenres(for contentType: ContentType) -> Observable<[Genre]> {
        return fetch(url: makeURL(endpoint: contentType.genreEndpoint))
            .decode(type: GenreResponse.self)
            .map { $0.genres }
    }

    func fetchMovies(for genre: Genre, page: Int = 1) -> Observable<[Movie]> {
        return fetch(url: makeURL(endpoint: "discover/movie", with: genre, page: page))
            .decode(type: MovieResponse.self)
            .map { $0.results }
    }

    func fetchTVShows(for genre: Genre, page: Int = 1) -> Observable<[TVShow]> {
        return fetch(url: makeURL(endpoint: "discover/tv", with: genre, page: page))
            .decode(type: TVShowsResponse.self)
            .map { $0.results }
    }

    // MARK: - Helper Methods

    private func fetch(url: URL?) -> Observable<Data> {
        guard let url = url else {
            return .error(NetworkError.invalidURL)
        }

        return Network.shared.request(url: url)
            .catch { error in
                print("Networking error: \(error)")
                return .empty()
            }
    }

    private func makeURL(endpoint: String, with genre: Genre? = nil, page: Int = 1) -> URL? {
        if let genre = genre {
            return URL(string: "\(baseURL)\(endpoint)?api_key=\(apiKey)&with_genres=\(genre.id)&page=\(page)")
        } else {
            return URL(string: "\(baseURL)\(endpoint)?api_key=\(apiKey)")
        }
    }
}

// MARK: - Observable Extensions

extension Observable where Element == Data {
    func decode<T: Decodable>(type: T.Type) -> Observable<T> {
        return self.flatMap { data -> Observable<T> in
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                return .just(response)
            } catch {
                return .error(NetworkError.decodingError)
            }
        }
    }
}

// MARK: - Network Errors

enum NetworkError: Error {
    case invalidURL
    case decodingError
}


