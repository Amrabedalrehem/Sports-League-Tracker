//
//  SportCellCollectionViewCell.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 30/04/2026.
//

import UIKit

class SportCell : UICollectionViewCell {
    
    @IBOutlet weak var sportImage: UIImageView!
    @IBOutlet weak var sportName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        // White card with elevation
        contentView.backgroundColor = .white
        backgroundColor = .clear
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true

        // Card shadow (more visible for card feel)
        layer.cornerRadius = 20
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0.08, green: 0.10, blue: 0.30, alpha: 1).cgColor
        layer.shadowOpacity = 0.13
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowRadius = 14

        // Image — fit inside card
        sportImage.contentMode = .scaleAspectFit
        sportImage.clipsToBounds = true

        // Big attractive name label
        sportName.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        sportName.textAlignment = .center
        sportName.textColor = UIColor(red: 0.07, green: 0.10, blue: 0.28, alpha: 1)
        sportName.numberOfLines = 1
        sportName.adjustsFontSizeToFitWidth = true
        sportName.minimumScaleFactor = 0.8
    }

    // Subtle scale feedback on tap
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut) {
                self.transform = self.isHighlighted
                    ? CGAffineTransform(scaleX: 0.94, y: 0.94)
                    : .identity
            }
        }
    }
}
