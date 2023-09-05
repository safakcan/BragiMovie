//
//  ShowsPageVC.swift
//  BragiMovie
//
//  Created by Can Bas on 4.09.2023.
//

import UIKit
import RxSwift

class ShowsPageVC: UIViewController, UIScrollViewDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var showCollectionView: UICollectionView!

    // MARK: - Properties
    private let viewModel = ShowsPageViewModel()
    private let disposeBag = DisposeBag()
    private let padding: CGFloat = 20
    private var itemWidth: CGFloat {
        UIScreen.main.bounds.width * 0.43
    }
    private var itemHeight: CGFloat {
        itemWidth * 1.4
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollections()
        bindViewModel()
        handleInteractions()
    }

    // MARK: - Configurations
    private func configureCollections() {
        genreCollectionView.register(GenreCollectionViewCell.nib, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        showCollectionView.register(ShowsCollectionViewCell.nib, forCellWithReuseIdentifier: ShowsCollectionViewCell.identifier)

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 3

        showCollectionView.collectionViewLayout = layout
        showCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    // MARK: - ViewModel Binding
    private func bindViewModel() {
        viewModel.genres
            .bind(to: genreCollectionView.rx.items(cellIdentifier: GenreCollectionViewCell.identifier, cellType: GenreCollectionViewCell.self)) { _, genre, cell in
                cell.setUp(with: genre)
            }
            .disposed(by: disposeBag)

        viewModel.tvShows
            .bind(to: showCollectionView.rx.items(cellIdentifier: ShowsCollectionViewCell.identifier, cellType: ShowsCollectionViewCell.self)) { _, shows, cell in
                cell.setup(with: shows)
            }
            .disposed(by: disposeBag)
    }

    // MARK: - User Interactions
    private func handleInteractions() {
        genreCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let genre = try? self?.viewModel.genres.value()[indexPath.row] else { return }
                self?.viewModel.loadTVShows(for: genre)
            })
            .disposed(by: disposeBag)

        showCollectionView.rx.contentOffset
            .subscribe(onNext: { [weak self] contentOffset in
                let offsetY = contentOffset.y
                let contentHeight = self?.showCollectionView.contentSize.height ?? 0
                if offsetY > contentHeight - (self?.showCollectionView.frame.size.height ?? 0) * 2 {
                    self?.viewModel.loadMoreTVShows()
                }
            })
            .disposed(by: disposeBag)
    }
}

