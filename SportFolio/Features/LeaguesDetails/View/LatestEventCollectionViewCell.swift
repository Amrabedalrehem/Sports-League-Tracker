//
//  LatestEventCollectionViewCell.swift
//  SportFolio
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
        setupCell()
    }

    private func setupCell() {
       
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true

        layer.cornerRadius = 16
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0.08, green: 0.10, blue: 0.30, alpha: 1).cgColor
        layer.shadowOpacity = 0.10
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 10

       
        for imageView in [homeTeamImageView, awayTeamImageView] {
            guard let iv = imageView else { continue }
            iv.layer.cornerRadius = 25
            iv.layer.masksToBounds = true
            iv.contentMode = .scaleAspectFit
            iv.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.98, alpha: 1)
            iv.layer.borderWidth = 1
            iv.layer.borderColor = UIColor(red: 0.18, green: 0.42, blue: 0.92, alpha: 0.15).cgColor
        }

       
        scoreLabel?.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        scoreLabel?.textColor = UIColor(red: 0.07, green: 0.09, blue: 0.20, alpha: 1)
        scoreLabel?.textAlignment = .center

       
        vsLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        vsLabel?.textColor = UIColor(red: 0.18, green: 0.42, blue: 0.92, alpha: 1)

        
        for label in [homeTeamNameLabel, awayTeamNameLabel] {
            label?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            label?.textColor = UIColor(red: 0.07, green: 0.09, blue: 0.20, alpha: 1)
            label?.textAlignment = .center
            label?.numberOfLines = 2
        }

      
        dateLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        dateLabel?.textColor = UIColor.secondaryLabel
    }

    func configure(homeName: String?, awayName: String?, score: String?, date: String?) {
        homeTeamNameLabel.text = homeName ?? "TBD"
        awayTeamNameLabel.text = awayName ?? "TBD"
        let resolvedScore = (score?.trimmingCharacters(in: .whitespaces).isEmpty == false) ? score! : "- : -"
        scoreLabel.text = resolvedScore
        dateLabel.text = date ?? "N/A"
    }
}
