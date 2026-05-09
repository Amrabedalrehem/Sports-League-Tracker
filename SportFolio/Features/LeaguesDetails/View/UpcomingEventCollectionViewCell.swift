//
//  UpcomingEventCollectionViewCell.swift
//  SportFolio
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
        homeTeamImageView.clipsToBounds = true
        awayTeamImageView.clipsToBounds = true
        setupCell()
    }

    private func setupCell() {
        
        contentView.backgroundColor = .cardBG
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        layer.cornerRadius = 20
        layer.masksToBounds = false
        layer.shadowColor = UIColor.shadowColorApp.cgColor
        layer.shadowOpacity = 0.13
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowRadius = 14
        
        for imageView in [homeTeamImageView, awayTeamImageView] {
            guard let iv = imageView else { continue }
            iv.layer.cornerRadius = 35
            iv.layer.masksToBounds = true
            iv.contentMode = .scaleAspectFit
            iv.backgroundColor = .appBackground
            iv.layer.borderWidth = 1
            iv.layer.borderColor = UIColor.primaryBlueBorder.cgColor
        }

       
        vsLabel?.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        vsLabel?.textColor = .primaryBlue

       
        for label in [homeTeamNameLabel, awayTeamNameLabel] {
            label?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            label?.textColor = .mainText
            label?.textAlignment = .center
            label?.numberOfLines = 2
        }
        for label in [dateLabel, timeLabel] {
            label?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            label?.textColor = UIColor.secondaryLabel
        }
    }

    func configure(homeName: String?, awayName: String?, date: String?, time: String?) {
        homeTeamNameLabel.text = homeName ?? "TBD"
        awayTeamNameLabel.text = awayName ?? "TBD"
        dateLabel.text = date ?? "Date N/A"
        timeLabel.text = time ?? "Time N/A"
        vsLabel.text = "VS"
    }
}
