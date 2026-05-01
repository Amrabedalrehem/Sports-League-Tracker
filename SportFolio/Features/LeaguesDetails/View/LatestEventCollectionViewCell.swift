//
//  LatestEventCollectionViewCell.swift
//  SportFolio
//
//  Created by ITI_JETS on 30/04/2026.
//

import UIKit

class LatestEventCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var homeTeamImageView: UIImageView!
        @IBOutlet weak var homeTeamNameLabel: UILabel!
        @IBOutlet weak var awayTeamImageView: UIImageView!
        @IBOutlet weak var awayTeamNameLabel: UILabel!
        @IBOutlet weak var scoreLabel: UILabel!
        @IBOutlet weak var vsLabel: UILabel!
        @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
