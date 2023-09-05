//
//  GenreCollectionViewCell.swift
//  BragiMovie
//
//  Created by Can Bas on 4.09.2023.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var genreLbl: UILabel?

    static let nib = UINib(nibName: "GenreCollectionViewCell", bundle: nil)
    static let identifier = "GenreCollectionViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()

        genreLbl?.text = ""
    }

    func setUp(with: Genre) {
        genreLbl?.text = with.name
    }
}
