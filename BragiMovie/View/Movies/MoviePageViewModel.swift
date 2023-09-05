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
        loadGenres()
    }

    // MARK: - API Calls

    private func loadGenres() {
        apiService.fetchGenres(for: .movie)
            .subscribe(onNext: handleGenres, onError: handleFetchError)
            .disposed(by: disposeBag)
    }

    func loadMovies(for genre: Genre) {
        resetPageAndGenre(for: genre)

        apiService.fetchMovies(for: genre, page: currentPage)
            .subscribe(onNext: handleMovies, onError: { [weak self] error in
                self?.handleFetchErrorForGenre(error, genre: genre)
            })
            .disposed(by: disposeBag)
    }

    func loadMoreMovies() {
        guard let genre = selectedGenre else { return }

        incrementPage()

        apiService.fetchMovies(for: genre, page: currentPage)
            .subscribe(onNext: appendMovies, onError: { [weak self] error in
                self?.handleFetchErrorForGenre(error, genre: genre)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - State Management

    private func resetPageAndGenre(for genre: Genre) {
        currentPage = 1  // Reset the page count
        selectedGenre = genre
    }

    private func incrementPage() {
        currentPage += 1
    }

    // MARK: - Response Handling

    private func handleGenres(_ genreList: [Genre]) {
        genres.onNext(genreList)
    }

    private func handleMovies(_ movieList: [Movie]) {
        movies.onNext(movieList)
    }

    private func appendMovies(_ newMovies: [Movie]) {
        if let currentMovies = try? movies.value() {
            movies.onNext(currentMovies + newMovies)
        }
    }

    private func handleFetchError(_ error: Error) {
        print("Error fetching data: \(error)")
        // Handle the error
    }

    private func handleFetchErrorForGenre(_ error: Error, genre: Genre) {
        print("Error fetching movies for genre \(genre.name): \(error)")
        // Handle the error
    }
}
