//
//  TeamViewCell.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 01/05/2026.
//

import UIKit
import SkeletonView
final class TeamViewCell: UITableViewCell {
    static let reuseIdentifier = "TeamViewCell"

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var roleBadgeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        [cardView, nameLabel, numberLabel, subtitleLabel, roleBadgeLabel, avatarImageView].forEach {
            $0?.skeletonCornerRadius = 8
        }
        isSkeletonable = true
        contentView.isSkeletonable = true
        cardView.isSkeletonable = true

        nameLabel.isSkeletonable = true
        numberLabel.isSkeletonable = true
        subtitleLabel.isSkeletonable = true
        roleBadgeLabel.isSkeletonable = true
        avatarImageView.isSkeletonable = true

        configureAppearance()
    }
    override func prepareForReuse() {
        super.prepareForReuse()

        nameLabel.text = ""
        numberLabel.text = ""
        subtitleLabel.text = ""
        avatarImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        numberLabel.layer.cornerRadius = numberLabel.bounds.height / 2
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
    }

    private func configureAppearance() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        cardView.backgroundColor = .cardBG    
        cardView.layer.cornerRadius = 16
        cardView.layer.masksToBounds = false
        if let shadowColor = UIColor(named: "ShadowColor") {
            cardView.layer.shadowColor = shadowColor.cgColor
        }
        cardView.layer.shadowOpacity = 0.10
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 10
           cardView.layer.borderWidth = 0

        numberLabel.backgroundColor = .imageBackground
        numberLabel.textColor = .primaryBlue
        numberLabel.font = .systemFont(ofSize: 16, weight: .bold)
        numberLabel.textAlignment = .center
        numberLabel.clipsToBounds = true

        avatarImageView.backgroundColor = .imageBackground
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true

        nameLabel.textColor = .mainText
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.numberOfLines = 2

        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .regular)

        roleBadgeLabel.textColor = .white
        roleBadgeLabel.font = .systemFont(ofSize: 12, weight: .bold)
        roleBadgeLabel.textAlignment = .center
        roleBadgeLabel.layer.cornerRadius = 8
        roleBadgeLabel.clipsToBounds = true
    }
}
