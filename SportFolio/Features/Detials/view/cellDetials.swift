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
            
            backgroundColor = UIColor.clear
            contentView.backgroundColor = UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1.0)
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            
            if let iconContainer = leagueImageView.superview {
                iconContainer.layer.cornerRadius = iconContainer.frame.width / 2
                iconContainer.layer.masksToBounds = true
            }
            
            leagueImageView.layer.cornerRadius = leagueImageView.frame.width / 2
            leagueImageView.layer.masksToBounds = true
        }
    }
