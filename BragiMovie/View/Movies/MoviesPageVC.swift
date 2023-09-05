//
//  MoviesPageVC.swift
//  BragiMovie
//
//  Created by Can Bas on 4.09.2023.
//

import UIKit
import RxSwift

class MoviesPageVC: UIViewController {
    @IBOutlet var tableView: UITableView!

    @IBOutlet weak var genreCollectionView: UICollectionView!
    private let viewModel = MoviePageViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")

        genreCollectionView.register(UINib(nibName: "GenreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GenreCollectionViewCell")

        viewModel.genres
            .bind(to: genreCollectionView.rx.items(cellIdentifier: "GenreCollectionViewCell", cellType: GenreCollectionViewCell.self)) { row, genre, cell in
                cell.setUp(with: genre)
            }
            .disposed(by: disposeBag)

        viewModel.movies
            .bind(to: tableView.rx.items(cellIdentifier: "MovieTableViewCell", cellType: MovieTableViewCell.self)) { row, movie, cell in
                cell.setup(with: movie)
            }
            .disposed(by: disposeBag)

        genreCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let genre = try? self?.viewModel.genres.value()[indexPath.row] else { return }
                self?.viewModel.loadMovies(for: genre)
            })
            .disposed(by: disposeBag)

        tableView.rx.contentOffset
            .subscribe(onNext: { [weak self] contentOffset in
                let offsetY = contentOffset.y
                let contentHeight = self?.tableView.contentSize.height ?? 0

                if offsetY > contentHeight - (self?.tableView.frame.size.height ?? 0) * 2 {
                    self?.viewModel.loadMoreMovies()
                }
            })
            .disposed(by: disposeBag)

    }
    
}
