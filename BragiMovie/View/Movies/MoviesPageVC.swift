//
//  MoviesPageVC.swift
//  BragiMovie
//
//  Created by Can Bas on 4.09.2023.
//

import UIKit
import RxSwift

class MoviesPageVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var movieCollectionView: UICollectionView!

    private let viewModel = MoviePageViewModel()
    private let disposeBag = DisposeBag()

    private let padding: CGFloat = 20
    private let itemRatio: CGFloat = 1.4
    private var itemHeight: CGFloat {
        return itemWidth * itemRatio
    }
    private var itemWidth: CGFloat {
        return UIScreen.main.bounds.width * 0.43
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        setupCollectionView()
        bindViewModel()
    }

    private func setupCollectionView() {
        registerCells()
        configureMovieCollectionViewLayout()
    }

    private func registerCells() {
        genreCollectionView.register(GenreCollectionViewCell.nib, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        movieCollectionView.register(MovieCollectionViewCell.nib, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
    }

    private func configureMovieCollectionViewLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 3
        movieCollectionView.collectionViewLayout = layout
        movieCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    private func bindViewModel() {
        bindGenres()
        bindMovies()
        bindGenreSelection()
        bindMovieScrolling()
        bindItemSelected()
        selectFirstGenre()
    }

    private func bindGenres() {
        viewModel.genres
            .bind(to: genreCollectionView.rx.items(cellIdentifier: GenreCollectionViewCell.identifier, cellType: GenreCollectionViewCell.self)) { _, genre, cell in
                cell.setUp(with: genre)
            }
            .disposed(by: disposeBag)
    }

    private func bindMovies() {
        viewModel.movies
            .bind(to: movieCollectionView.rx.items(cellIdentifier: MovieCollectionViewCell.identifier, cellType: MovieCollectionViewCell.self)) { _, movie, cell in
                cell.setup(with: movie)
            }
            .disposed(by: disposeBag)
    }

    private func bindGenreSelection() {
        genreCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let genre = try? self?.viewModel.genres.value()[indexPath.row] else { return }
                self?.viewModel.loadMovies(for: genre)
            })
            .disposed(by: disposeBag)
    }

    private func bindMovieScrolling() {
        movieCollectionView.rx.contentOffset
            .subscribe(onNext: { [weak self] contentOffset in
                let offsetY = contentOffset.y
                let contentHeight = self?.movieCollectionView.contentSize.height ?? 0

                if offsetY > contentHeight - (self?.movieCollectionView.frame.size.height ?? 0) * 2 {
                    self?.viewModel.loadMoreMovies()
                }
            })
            .disposed(by: disposeBag)
    }

    private func bindItemSelected() {
        movieCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }

                if let movie = try? self.viewModel.movies.value()[indexPath.row] {

                    if let detailVC = UIStoryboard(name: "Detail", bundle: nil).instantiateViewController(withIdentifier: "Detail") as? DetailPageVC {
                        detailVC.item = movie

                        self.navigationController?.pushViewController(detailVC, animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    private func selectFirstGenre() {
        viewModel.genres
            .take(1)
            .subscribe(onNext: { [weak self] genres in
                guard !genres.isEmpty else { return }

                let firstIndexPath = IndexPath(row: 0, section: 0)
                self?.genreCollectionView.selectItem(at: firstIndexPath, animated: false, scrollPosition: .top)
                guard let genre = try? self?.viewModel.genres.value().first else { return }
                self?.viewModel.loadMovies(for: genre)
            })
            .disposed(by: disposeBag)
    }
}
