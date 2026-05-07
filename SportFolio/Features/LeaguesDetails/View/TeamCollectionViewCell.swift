//
//  TeamCollectionViewCell.swift
//  SportFolio
//

import UIKit
import SDWebImage

class TeamCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var teamLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    private func setupCell() {
       
        contentView.backgroundColor = .cardBG   
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true

        layer.cornerRadius = 16
        layer.masksToBounds = false
        layer.shadowColor = UIColor.shadowColorApp.cgColor
        layer.shadowOpacity = 0.12
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 12

        teamImageView.layer.cornerRadius = 30
        teamImageView.layer.masksToBounds = true
        teamImageView.contentMode = .scaleAspectFit
        teamImageView.backgroundColor = .appBackground
        teamImageView.layer.borderWidth = 1
        teamImageView.layer.borderColor = UIColor.primaryBlueBorder.cgColor

      
        teamLabel.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        teamLabel.textColor = .mainText
        teamLabel.textAlignment = .center
        teamLabel.numberOfLines = 2
        teamLabel.adjustsFontSizeToFitWidth = true
        teamLabel.minimumScaleFactor = 0.8
    }

   
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut) {
                self.transform = self.isHighlighted
                    ? CGAffineTransform(scaleX: 0.93, y: 0.93)
                    : .identity
            }
        }
    }
}
