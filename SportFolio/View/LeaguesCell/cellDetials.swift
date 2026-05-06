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
        isSkeletonable = true
           contentView.isSkeletonable = true

           leagueNameLabel.isSkeletonable = true
           countryNameLabel.isSkeletonable = true
           leagueImageView.isSkeletonable = true
    }

    private func setupUI() {
     
        backgroundColor = .clear
        selectionStyle  = .none
 
        contentView.backgroundColor    = .white
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        layer.cornerRadius  = 16
        layer.masksToBounds = false
        layer.shadowColor   = UIColor(red: 0.08, green: 0.10, blue: 0.30, alpha: 1).cgColor
        layer.shadowOpacity = 0.10
        layer.shadowOffset  = CGSize(width: 0, height: 4)
        layer.shadowRadius  = 10
        leagueNameLabel.font      = UIFont.systemFont(ofSize: 16, weight: .bold)
        leagueNameLabel.textColor = UIColor(red: 0.07, green: 0.09, blue: 0.20, alpha: 1)

        countryNameLabel.font      = UIFont.systemFont(ofSize: 13, weight: .regular)
        countryNameLabel.textColor = .secondaryLabel

        arrowLabel.textColor = UIColor(red: 0.18, green: 0.42, blue: 0.92, alpha: 1)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14))
        leagueImageView.layer.cornerRadius  = leagueImageView.frame.width / 2
        leagueImageView.layer.masksToBounds = true
        leagueImageView.contentMode         = .scaleAspectFit
        leagueImageView.backgroundColor     = UIColor(red: 0.93, green: 0.95, blue: 0.98, alpha: 1)

        if let iconContainer = leagueImageView.superview {
            iconContainer.layer.cornerRadius  = iconContainer.frame.width / 2
            iconContainer.layer.masksToBounds = true
            iconContainer.backgroundColor     = UIColor(red: 0.93, green: 0.95, blue: 0.98, alpha: 1)
        }
    }
}
