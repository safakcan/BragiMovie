//
//  ShowsCollectionViewCell.swift
//  BragiMovie
//
//  Created by Can Bas on 5.09.2023.
//

import UIKit

class ShowsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!

    private let title = "Title: "
    private let average = "Average: 10/"
    private let date = "Release Date: "
    private let country = "Country: "

    static let nib = UINib(nibName: "ShowsCollectionViewCell", bundle: nil)
    static let identifier = "ShowsCollectionViewCell"

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
        countryLbl.text = ""
    }

    func setup(with: TVShow) {
        posterImage.sd_setImage(with: URL(string: with.fullPath), placeholderImage: UIImage(named: "placeholder.png"))
        titleLbl.text = title + with.name
        ratingLbl.text = average + String(with.voteAverage)
        dateLbl.text = date + with.firstAirDate.prefix(4)
        countryLbl.text = country + (with.originCountry.first ?? "")
    }
}
