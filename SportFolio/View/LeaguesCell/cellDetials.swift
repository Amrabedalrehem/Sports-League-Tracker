//
//  cellDetialsTableViewCell.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 30/04/2026.
//

import UIKit

class cellDetialsTableViewCell: UITableViewCell {

    @IBOutlet weak var leagueImageView: UIImageView!
    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var arrowLabel: UILabel!

 

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        isSkeletonable         = true
        contentView.isSkeletonable = true
        leagueNameLabel.isSkeletonable  = true
        countryNameLabel.isSkeletonable = true
        leagueImageView.isSkeletonable  = true
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle  = .none
       contentView.backgroundColor     = .cardBackground
        contentView.layer.cornerRadius  = 20
        contentView.layer.masksToBounds = true
         layer.cornerRadius  = 20
        layer.masksToBounds = false
        layer.shadowColor   = UIColor.shadowColorApp.cgColor
         layer.shadowOpacity = 0.03
        layer.shadowOffset  = CGSize(width: 0, height: 2)
        layer.shadowRadius  = 6

        leagueNameLabel.font      = UIFont.systemFont(ofSize: 16, weight: .bold)
        leagueNameLabel.textColor = .mainText

        countryNameLabel.font      = UIFont.systemFont(ofSize: 13, weight: .regular)
        countryNameLabel.textColor = .mainText.withAlphaComponent(0.7)
        arrowLabel.textColor = .mainText.withAlphaComponent(0.6)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
          contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14)
        )

          let iconBG = UIColor.mainText.withAlphaComponent(0.05)
        leagueImageView.layer.cornerRadius  = leagueImageView.frame.width / 2
        leagueImageView.layer.masksToBounds = true
        leagueImageView.contentMode         = .scaleAspectFit
        leagueImageView.backgroundColor     = iconBG

        if let iconContainer = leagueImageView.superview {
            iconContainer.layer.cornerRadius  = iconContainer.frame.width / 2
            iconContainer.layer.masksToBounds = true
            iconContainer.backgroundColor     = iconBG
        }
    }
 

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.shadowColor     = UIColor.tabBarGradientStart.withAlphaComponent(0.45).cgColor
        }
    }

    private func gradientColors() -> [CGColor] {
        return [
            UIColor.tabBarGradientStart.cgColor,
            UIColor.tabBarGradientEnd.cgColor
        ]
    }
}

