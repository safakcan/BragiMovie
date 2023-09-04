//
//  MovieTableViewCell.swift
//  BragiMovie
//
//  Created by Can Bas on 4.09.2023.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var budegtLbl: UILabel!
    @IBOutlet weak var revenueLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLbl.text = ""
        ratingLbl.text = ""
        budegtLbl.text = ""
        revenueLbl.text = ""
    }

    func setup(with: Movie) {
        titleLbl.text = with.title
        ratingLbl.text = String(with.voteAverage)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
