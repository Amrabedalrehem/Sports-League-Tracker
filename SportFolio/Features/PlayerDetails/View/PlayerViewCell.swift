//
//  PlayerViewCell.swift
//  SportsApp
//

import UIKit
import SkeletonView
final class PlayerViewCell: UITableViewCell {



    @IBOutlet weak var cardView:           UIView!
    @IBOutlet weak var numberLabel:        UILabel!
    @IBOutlet weak var avatarImageView:    UIImageView!
    @IBOutlet weak var nameLabel:          UILabel!
    @IBOutlet weak var metaLabel:          UILabel!
    @IBOutlet weak var roleBadgeLabel:     UILabel!
    @IBOutlet weak var ratingLabel:        UILabel!
    @IBOutlet weak var minutesLabel:       UILabel!
    @IBOutlet weak var matchPlayedLabel:   UILabel!
    @IBOutlet weak var goalsConcededLabel: UILabel!
    @IBOutlet weak var savesLabel:         UILabel!
    @IBOutlet weak var ageLabel:           UILabel!
    @IBOutlet weak var captainLabel:       UILabel!


    @IBOutlet weak var ratingTitleLabel:        UILabel!
    @IBOutlet weak var minutesTitleLabel:       UILabel!
    @IBOutlet weak var playedTitleLabel:        UILabel!
    @IBOutlet weak var gConcTitleLabel:         UILabel!
    @IBOutlet weak var savesTitleLabel:         UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()


		cardView.isSkeletonable = true
		numberLabel.isSkeletonable = true
		avatarImageView.isSkeletonable = true
		nameLabel.isSkeletonable = true
		metaLabel.isSkeletonable = true
		roleBadgeLabel.isSkeletonable = true
		ratingLabel.isSkeletonable = true
		minutesLabel.isSkeletonable = true
		matchPlayedLabel.isSkeletonable = true
		goalsConcededLabel.isSkeletonable = true
		savesLabel.isSkeletonable = true

        styleCard()
        styleAvatar()
        styleRoleBadge()
        styleCaptainBadge()
        applyRTLIfNeeded()
        localizeStatTitles()
    }



    private var isRTL: Bool {
        UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }

    private func applyRTLIfNeeded() {
        guard isRTL else { return }
        contentView.semanticContentAttribute        = .forceRightToLeft
        cardView.semanticContentAttribute           = .forceRightToLeft
        nameLabel.textAlignment                     = .right
        metaLabel.textAlignment                     = .right
        ageLabel.textAlignment                      = .right
    }

    private func localizeStatTitles() {
        ratingTitleLabel.text   = L10n.playerStatRating
        minutesTitleLabel.text  = L10n.playerStatMinutes
        playedTitleLabel.text   = L10n.playerStatPlayed
        gConcTitleLabel.text    = L10n.playerStatGConc
        savesTitleLabel.text    = L10n.playerStatSaves
    }




	func configure(with player: PlayerModel) {

		numberLabel.text = player.playerNumber ?? L10n.unknown
		nameLabel.text   = player.playerName ?? L10n.playerNameUnknown

		let country = player.playerCountry ?? ""
		let birth   = player.playerBirthdate ?? ""

		metaLabel.text = [country, birth]
			.filter { !$0.isEmpty }
			.joined(separator: " · ")

		roleBadgeLabel.text = player.playerType?.uppercased() ?? L10n.unknown

		ratingLabel.text        = player.playerRating ?? "-"
		minutesLabel.text       = player.playerMinutes ?? "-"
		matchPlayedLabel.text   = player.playerMatchPlayed ?? "-"
		goalsConcededLabel.text = player.playerGoalsConceded ?? "-"
		savesLabel.text         = player.playerSaves ?? "-"

		ageLabel.text = "\(L10n.playerAge): \(player.playerAge ?? L10n.playerAgeUnknown)"

		captainLabel.isHidden = player.playerIsCaptain != "1"
		captainLabel.text = L10n.captain
	}


    private func styleCard() {
        cardView.layer.cornerRadius  = 16
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor   = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.12
        cardView.layer.shadowOffset  = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius  = 8
        cardView.backgroundColor     = UIColor.secondarySystemBackground
    }

    private func styleAvatar() {
        avatarImageView.layer.cornerRadius  = 28
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.borderWidth   = 2
        avatarImageView.layer.borderColor   = UIColor.systemBlue.cgColor
    }

    private func styleRoleBadge() {
        roleBadgeLabel.layer.cornerRadius  = 9
        roleBadgeLabel.layer.masksToBounds = true
        roleBadgeLabel.backgroundColor     = UIColor.systemBlue
        roleBadgeLabel.textColor           = .white
        roleBadgeLabel.textAlignment       = .center


    }

    private func styleCaptainBadge() {
        captainLabel.layer.cornerRadius  = 11
        captainLabel.layer.masksToBounds = true
        captainLabel.backgroundColor     = UIColor.systemYellow
        captainLabel.textColor           = .black
        captainLabel.textAlignment       = .center

    }



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
