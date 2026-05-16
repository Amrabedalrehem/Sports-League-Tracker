//
//  PlayerViewCell.swift
//  SportsApp
//
import UIKit
import SkeletonView
import SDWebImage

final class PlayerViewCell: UICollectionViewCell {

		

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
	@IBOutlet weak var ratingTitleLabel:   UILabel!
	@IBOutlet weak var minutesTitleLabel:  UILabel!
	@IBOutlet weak var playedTitleLabel:   UILabel!
	@IBOutlet weak var gConcTitleLabel:    UILabel!
	@IBOutlet weak var savesTitleLabel:    UILabel!



	override func awakeFromNib() {
		super.awakeFromNib()
		setupSkeletonSupport()
		prepareForReuse()
		styleCard()
		styleAvatar()
		styleRoleBadge()
		styleCaptainBadge()
		applyRTLIfNeeded()
		localizeStatTitles()
	}
	override func prepareForReuse() {
		super.prepareForReuse()

		avatarImageView.image = UIImage(named: "playerPlaceholder")

		numberLabel.text = nil
		nameLabel.text = nil
		metaLabel.text = nil

		roleBadgeLabel.text = nil
		roleBadgeLabel.isHidden = true

		ratingLabel.text = "-"
		minutesLabel.text = "-"
		matchPlayedLabel.text = "-"

		goalsConcededLabel.text = "-"
		savesLabel.text = "-"

		ageLabel.text = nil
		ageLabel.isHidden = true

		captainLabel.isHidden = true
	}

	private func setupSkeletonSupport() {
		isSkeletonable             = true
		contentView.isSkeletonable = true
		cardView.isSkeletonable    = true


		avatarImageView.isSkeletonable      = true
		avatarImageView.skeletonCornerRadius = 28


		numberLabel.isSkeletonable    = true
		roleBadgeLabel.isSkeletonable = true
		ageLabel.isSkeletonable       = true
		captainLabel.isSkeletonable   = true


		nameLabel.superview?.isSkeletonable = true
		nameLabel.isSkeletonable            = true
		metaLabel.isSkeletonable            = true


		markStatStack(value: ratingLabel,        title: ratingTitleLabel)
		markStatStack(value: minutesLabel,       title: minutesTitleLabel)
		markStatStack(value: matchPlayedLabel,   title: playedTitleLabel)
		markStatStack(value: goalsConcededLabel, title: gConcTitleLabel)
		markStatStack(value: savesLabel,         title: savesTitleLabel)
	}

	private func markStatStack(value: UILabel, title: UILabel) {
		value.isSkeletonable = true
		title.isSkeletonable = true
		if let vStack = value.superview {
			vStack.isSkeletonable            = true
			vStack.superview?.isSkeletonable = true
		}
	}



	func configure(with player: PlayerModel) {
		numberLabel.text = player.playerNumber ?? L10n.unknown
		nameLabel.text   = player.playerName   ?? L10n.playerNameUnknown

		let meta = [player.playerCountry ?? "", player.playerBirthdate ?? ""]
			.filter { !$0.isEmpty }.joined(separator: " · ")
		metaLabel.text = meta.isEmpty ? L10n.unknown : meta
		metaLabel.isHidden = false

		avatarImageView.sd_setImage(
			with: URL(string: player.avatarURL ?? ""),
			placeholderImage: UIImage(named: "playerPlaceholder")
		)

		if let type = player.playerType?.trimmingCharacters(in: .whitespacesAndNewlines),
		   !type.isEmpty {

			roleBadgeLabel.text = type.uppercased()
			roleBadgeLabel.isHidden = false

		} else {

			roleBadgeLabel.text = nil
			roleBadgeLabel.isHidden = true
		}
		roleBadgeLabel.isHidden = false
		ratingLabel.text      = player.playerRating      ?? "-"
		minutesLabel.text     = player.playerMinutes     ?? "-"
		matchPlayedLabel.text = player.playerMatchPlayed ?? "-"

		let isGoalKeeper =
		player.playerType?.lowercased().contains("goalkeeper") == true

		bind(
			value: goalsConcededLabel,
			title: gConcTitleLabel,
			text: isGoalKeeper ? player.playerGoalsConceded : nil
		)

		bind(
			value: savesLabel,
			title: savesTitleLabel,
			text: isGoalKeeper ? player.playerSaves : nil
		)
		ageLabel.text = "\(L10n.playerAge): \(player.playerAge ?? "-")"
		ageLabel.isHidden = false

		captainLabel.text     = L10n.captain
		captainLabel.isHidden = player.playerIsCaptain != "1"
	}

	private func bind(value: UILabel, title: UILabel, text: String?) {
		value.text     = text ?? "-"
		value.isHidden = text == nil
		title.isHidden = text == nil
	}



	private func localizeStatTitles() {
		ratingTitleLabel.text  = L10n.playerStatRating
		minutesTitleLabel.text = L10n.playerStatMinutes
		playedTitleLabel.text  = L10n.playerStatPlayed
		gConcTitleLabel.text   = L10n.playerStatGoalsConc
		savesTitleLabel.text   = L10n.playerStatSaves
	}



	private var isRTL: Bool {
		UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
	}

	private func applyRTLIfNeeded() {
		guard isRTL else { return }
		contentView.semanticContentAttribute = .forceRightToLeft
		cardView.semanticContentAttribute    = .forceRightToLeft
		nameLabel.textAlignment              = .right
		metaLabel.textAlignment              = .right
		ageLabel.textAlignment               = .right
	}



	private func styleCard() {
		cardView.layer.cornerRadius  = 16
		cardView.layer.masksToBounds = false
		cardView.layer.shadowColor   = UIColor.black.cgColor
		cardView.layer.shadowOpacity = 0.12
		cardView.layer.shadowOffset  = CGSize(width: 0, height: 4)
		cardView.layer.shadowRadius  = 8
		cardView.backgroundColor     = .cardBackground
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
}
