//
//  ShowsPageViewModel.swift
//  BragiMovie
//
//  Created by Can Bas on 4.09.2023.
//

import Foundation
import RxSwift

class ShowsPageViewModel {

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let apiService: APIService
    private var currentPage: Int = 1
    private var selectedGenre: Genre?

    let genres: BehaviorSubject<[Genre]> = BehaviorSubject(value: [])
    let tvShows: BehaviorSubject<[TVShow]> = BehaviorSubject(value: [])

    // MARK: - Initializer
    init(apiService: APIService = TMDBAPIService()) {
        self.apiService = apiService
        loadGenres()
    }

    // MARK: - Private Methods
    private func loadGenres() {
        apiService.fetchGenres(for: .tvShow)
            .subscribe(
                onNext: handleGenres,
                onError: handleFetchError
            )
            .disposed(by: disposeBag)
    }

    private func handleGenres(_ genreList: [Genre]) {
        genres.onNext(genreList)
    }

    private func handleTVShows(_ tvShowList: [TVShow]) {
        tvShows.onNext(tvShowList)
    }

    private func handleFetchError(_ error: Error) {
        // TODO: Handle the error appropriately for the user.
        print("Error fetching data: \(error)")
    }

    // MARK: - Public Methods
    func loadTVShows(for genre: Genre) {
        resetPageCount()
        selectedGenre = genre

        fetchTVShows(for: genre)
    }

    func loadMoreTVShows() {
        guard let genre = selectedGenre else { return }

        incrementPageCount()
        fetchTVShows(for: genre, appendToCurrent: true)
    }

    private func fetchTVShows(for genre: Genre, appendToCurrent: Bool = false) {
        apiService.fetchTVShows(for: genre, page: currentPage)
            .subscribe(
                onNext: { [weak self] newTVShows in
                    guard let self = self else { return }
                    let finalShows = appendToCurrent ? (try? self.tvShows.value() + newTVShows) ?? newTVShows : newTVShows
                    self.handleTVShows(finalShows)
                },
                onError: { error in
                    self.handleFetchError(error)
                }
            )
            .disposed(by: disposeBag)
    }

    private func resetPageCount() {
        currentPage = 1
    }

    private func incrementPageCount() {
        currentPage += 1
    }
}
