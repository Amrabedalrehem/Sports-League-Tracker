//
//  TeamSectionHeaderView.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 06/05/2026.
//

import UIKit

class TeamSectionHeaderView: UITableViewHeaderFooterView {

    static let reuseIdentifier = "TeamSectionHeader"

    @IBOutlet weak var sectionLabel: UILabel!
    override func awakeFromNib() {
            super.awakeFromNib()

            isSkeletonable = true
            
            contentView.isSkeletonable = true
            
            sectionLabel.isSkeletonable = true
            
            sectionLabel.linesCornerRadius = 6
        }
}
 
