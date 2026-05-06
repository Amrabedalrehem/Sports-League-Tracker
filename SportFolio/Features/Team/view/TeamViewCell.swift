//
//  TeamViewCell.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 01/05/2026.
//

import UIKit

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
        configureAppearance()
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

        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 16
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = UIColor.shadowColorApp.cgColor
        cardView.layer.shadowOpacity = 0.10
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 10
           cardView.layer.borderWidth = 0

        numberLabel.backgroundColor = .imageBG
        numberLabel.textColor = .primaryBlue
        numberLabel.font = .systemFont(ofSize: 16, weight: .bold)
        numberLabel.textAlignment = .center
        numberLabel.clipsToBounds = true

        avatarImageView.backgroundColor = .imageBG
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
