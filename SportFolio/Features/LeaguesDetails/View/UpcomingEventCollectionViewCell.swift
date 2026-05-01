//
//  UpcomingEventCollectionViewCell.swift
//  SportFolio
//
//  Created by ITI_JETS on 30/04/2026.
//

import UIKit

class UpcomingEventCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var homeTeamImageView: UIImageView!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var vsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var awayTeamImageView: UIImageView!
    @IBOutlet weak var awayTeamNameLabel: UILabel!       
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
