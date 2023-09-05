//
//  DetailPageVC.swift
//  BragiMovie
//
//  Created by Can Bas on 5.09.2023.
//

import UIKit
import SDWebImage

class DetailPageVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionView: UITextView!

    // MARK: - Properties
    var item: DetailDisplayable!



    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetails()
    }

    private func setupDetails() {

        title = item.name
        imageView.sd_setImage(with: URL(string: item.imageUrlString ?? ""), placeholderImage: UIImage(named: "placeholder.png"))
        
        descriptionView.text = item.description
    }
}

