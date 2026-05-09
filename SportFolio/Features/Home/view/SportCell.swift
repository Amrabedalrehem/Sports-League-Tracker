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
        
        contentView.backgroundColor = .cardBackground
        backgroundColor = .clear
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        layer.cornerRadius = 20
        layer.masksToBounds = false
        layer.shadowColor = UIColor.shadowColorApp.cgColor
        layer.shadowOpacity = 0.13
        
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 3)
        sportImage.contentMode = .scaleAspectFit
        sportImage.clipsToBounds = true
        sportName.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        sportName.textAlignment = .center
        sportName.textColor = .mainText
        sportName.numberOfLines = 1
        sportName.adjustsFontSizeToFitWidth = true
        sportName.minimumScaleFactor = 0.8
    }
    
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
