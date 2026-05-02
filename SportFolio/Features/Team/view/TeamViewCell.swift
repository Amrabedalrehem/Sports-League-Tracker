//
//  TeamViewCell.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 01/05/2026.
//

//
//  TeamViewCell.swift
//  SportsApp
//
//  Created by Codex on 01/05/2026.
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

        cardView.backgroundColor = UIColor(red: 0.18, green: 0.17, blue: 0.16, alpha: 1.0)
        cardView.layer.cornerRadius = 18
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor(white: 1.0, alpha: 0.08).cgColor

        numberLabel.backgroundColor = UIColor(red: 0.07, green: 0.29, blue: 0.55, alpha: 1.0)
        numberLabel.textColor = .white
        numberLabel.font = .systemFont(ofSize: 16, weight: .bold)
        numberLabel.textAlignment = .center
        numberLabel.clipsToBounds = true

        avatarImageView.backgroundColor = UIColor(red: 0.14, green: 0.13, blue: 0.15, alpha: 1.0)
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true

        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        nameLabel.numberOfLines = 2

        subtitleLabel.textColor = UIColor(white: 1.0, alpha: 0.68)
        subtitleLabel.font = .systemFont(ofSize: 17, weight: .regular)

        roleBadgeLabel.textColor = .white
        roleBadgeLabel.font = .systemFont(ofSize: 14, weight: .bold)
        roleBadgeLabel.textAlignment = .center
        roleBadgeLabel.layer.cornerRadius = 8
        roleBadgeLabel.clipsToBounds = true
        roleBadgeLabel.backgroundColor = UIColor(red: 0.72, green: 0.49, blue: 0.10, alpha: 1.0)
    }
}
