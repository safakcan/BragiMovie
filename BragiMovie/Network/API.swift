//
//  API.swift
//  BragiMovie
//
//  Created by Can Bas on 4.09.2023.
//

import Foundation
import RxSwift

protocol APIService {
    func fetchGenres() -> Observable<[Genre]>
    func fetchMovies(for genre: Genre, page: Int) -> Observable<[Movie]>
}

class TMDBAPIService: APIService {
    private let apiKey = "4f9da36791283d432b3658ba4274469e"
    private let baseURL = URL(string: "https://api.themoviedb.org/3/")!

    func fetchGenres() -> Observable<[Genre]> {
        guard let url = URL(string: "\(baseURL)genre/movie/list?api_key=\(apiKey)") else {
            return Observable.error(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        return Network.shared.request(url: url)
            .flatMap { data -> Observable<[Genre]> in
                do {
                    let response = try JSONDecoder().decode(GenreResponse.self, from: data)
                    return Observable.just(response.genres)
                } catch {
                    return Observable.error(error)
                }
            }
            .catch { error in
                print("Networking error: \(error)")
                return Observable.empty()
            }
    }

    func fetchMovies(for genre: Genre, page: Int = 1) -> Observable<[Movie]> {
        guard let url = URL(string: "\(baseURL)discover/movie?api_key=\(apiKey)&with_genres=\(genre.id)&page=\(page)") else {
            return Observable.error(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        return Network.shared.request(url: url)
            .flatMap { data -> Observable<[Movie]> in
                do {
                    let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                    return Observable.just(response.results)
                } catch {
                    return Observable.error(error)
                }
            }
            .catch { error in
                print("Networking error: \(error)")
                return Observable.empty()
            }
    }

}
