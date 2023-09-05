//
//  MoviePageViewModel.swift
//  BragiMovie
//
//  Created by Can Bas on 4.09.2023.
//

import RxSwift
import RxCocoa



class MoviePageViewModel {
    private let disposeBag = DisposeBag()
    private let apiService: APIService
    private var currentPage: Int = 1
    private var selectedGenre: Genre?

    let genres: BehaviorSubject<[Genre]> = BehaviorSubject(value: [])
    let movies: BehaviorSubject<[Movie]> = BehaviorSubject(value: [])

    init(apiService: APIService = TMDBAPIService()) {
        self.apiService = apiService
        self.loadGenres()
    }

    private func loadGenres() {
        apiService.fetchGenres()
            .subscribe(
                onNext: { [weak self] genreList in
                    self?.genres.onNext(genreList)
                },
                onError: { error in
                    print("Error fetching genres: \(error)")
                    // Handle the error
                }
            )
            .disposed(by: disposeBag)
    }

    func loadMovies(for genre: Genre) {
        currentPage = 1  // Reset the page count
        selectedGenre = genre

        apiService.fetchMovies(for: genre, page: currentPage)
            .subscribe(
                onNext: { [weak self] movieList in
                    self?.movies.onNext(movieList)
                },
                onError: { error in
                    print("Error fetching movies for genre \(genre.name): \(error)")
                    // Handle the error.
                }
            )
            .disposed(by: disposeBag)
    }

    func loadMoreMovies() {
        guard let genre = selectedGenre else { return }

        currentPage += 1

        apiService.fetchMovies(for: genre, page: currentPage)
            .subscribe(
                onNext: { [weak self] newMovies in
                    if let currentMovies = try? self?.movies.value() {
                        self?.movies.onNext(currentMovies + newMovies)
                    }
                },
                onError: { error in
                    print("Error fetching more movies for genre \(genre.name): \(error)")
                    // Handle the error.
                }
            )
            .disposed(by: disposeBag)
    }

}
