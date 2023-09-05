//
//  MovieCollectionViewCell.swift
//  BragiMovie
//
//  Created by Can Bas on 5.09.2023.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var adultLbl: UILabel!

    private let title = "Title: "
    private let average = "Average: 10/"
    private let date = "Release Date: "
    private let adult = "Adult: "

    static let nib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
    static let identifier = "MovieCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layer.borderWidth = 0.25
        contentView.layer.borderColor = UIColor.black.withAlphaComponent(0.25).cgColor

        if UIScreen.main.bounds.width < 375 {
            titleLbl.numberOfLines = 2
            titleLbl.adjustsFontSizeToFitWidth = true
            titleLbl.adjustsFontSizeToFitWidth = true
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layoutIfNeeded()

        posterImage.layer.cornerRadius = posterImage.frame.width / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        titleLbl.text = ""
        ratingLbl.text = ""
        dateLbl.text = ""
        adultLbl.text = ""
    }
    
    func setup(with: Movie) {
        posterImage.sd_setImage(with: URL(string: with.fullPath), placeholderImage: UIImage(named: "placeholder.png"))
        titleLbl.text = title + with.title
        ratingLbl.text = average + String(with.voteAverage)
        dateLbl.text = date + with.releaseDate.prefix(4)
        adultLbl.text = adult + (with.adult ? "YES" : "NO")
    }
}
