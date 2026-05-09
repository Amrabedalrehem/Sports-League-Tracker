//
//  TeamTableHeaderView.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 06/05/2026.
//

import UIKit
import SkeletonView
class TeamTableHeaderView: UIView {

    @IBOutlet weak var teamLogoImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        teamLogoImageView.isSkeletonable = true
        teamNameLabel.isSkeletonable = true
        teamLogoImageView.layer.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
    
    }

    static func loadFromNib() -> TeamTableHeaderView {
        UINib(nibName: "TeamTableHeaderView", bundle: nil)
            .instantiate(withOwner: nil, options: nil)
            .first as! TeamTableHeaderView
    }
}
