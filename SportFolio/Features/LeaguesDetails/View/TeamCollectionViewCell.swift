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
       
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true

        layer.cornerRadius = 16
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0.08, green: 0.10, blue: 0.30, alpha: 1).cgColor
        layer.shadowOpacity = 0.12
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 12

        teamImageView.layer.cornerRadius = 30
        teamImageView.layer.masksToBounds = true
        teamImageView.contentMode = .scaleAspectFit
        teamImageView.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.98, alpha: 1)
        teamImageView.layer.borderWidth = 1
        teamImageView.layer.borderColor = UIColor(red: 0.18, green: 0.42, blue: 0.92, alpha: 0.15).cgColor

      
        teamLabel.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        teamLabel.textColor = UIColor(red: 0.07, green: 0.09, blue: 0.20, alpha: 1)
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
