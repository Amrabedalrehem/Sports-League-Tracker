//
//  BannerCell.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 30/04/2026.
//


import UIKit

class BannerCell: UICollectionViewCell {

    @IBOutlet weak var bannerImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        // Rounded banner
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true

        // Image fills the card
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.clipsToBounds = true

        // Soft shadow
        layer.cornerRadius = 16
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 1).cgColor
        layer.shadowOpacity = 0.12
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 10
    }
}