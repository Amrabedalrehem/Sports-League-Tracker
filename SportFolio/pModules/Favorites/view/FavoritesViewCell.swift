//
//  FavoritesViewCell.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 01/05/2026.
//

import UIKit
import UIKit

final class FavoritesViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var leagueLogoImageView: UIImageView!
    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var sportTypeLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        leagueLogoImageView.layer.cornerRadius = leagueLogoImageView.bounds.height / 2

        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.10
        cardView.layer.shadowOffset = CGSize(width: 0, height: 6)
        cardView.layer.shadowRadius = 10
        cardView.layer.shadowPath = UIBezierPath(
            roundedRect: cardView.bounds,
            cornerRadius: 18
        ).cgPath
    }

    private func setupStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = UIColor.systemGroupedBackground

        cardView.layer.cornerRadius = 18
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.systemGray5.cgColor

        leagueLogoImageView.clipsToBounds = true
        leagueLogoImageView.contentMode = .scaleAspectFill
        leagueLogoImageView.backgroundColor = UIColor.systemGray6

        leagueNameLabel.textColor = UIColor.label
              sportTypeLabel.textColor = UIColor.systemBlue
        sportTypeLabel.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.12)
    }

    func configure(leagueKey: Int64, leagueName: String, leagueLogo: UIImage?, sportType: String) {
           leagueNameLabel.text = leagueName
        leagueLogoImageView.image = leagueLogo ?? UIImage(named: "placeholder_league")
        sportTypeLabel.text = sportType.capitalized
    }
}
