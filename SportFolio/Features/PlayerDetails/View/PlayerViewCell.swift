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

		// MARK: - Lifecycle

	override func awakeFromNib() {
		super.awakeFromNib()
		setupSkeletonSupport()
		styleCard()
		styleAvatar()
		styleRoleBadge()
		styleCaptainBadge()
		applyRTLIfNeeded()
		localizeStatTitles()
	}

		// MARK: - Skeleton
		// ─────────────────────────────────────────────────────────────────────────
		// SkeletonView rule: shimmer only reaches a view when EVERY ancestor
		// between it and the skeletonable root is also isSkeletonable = true.
		//
		// XIB hierarchy:
		//   Cell → contentView → cardView
		//     ├─ numberLabel          (direct child ✓)
		//     ├─ avatarImageView      (direct child ✓)
		//     ├─ INFO-stack           ← stack view, must be marked
		//     │    ├─ nameLabel
		//     │    └─ metaLabel
		//     ├─ roleBadgeLabel       (direct child ✓)
		//     ├─ STATS-hstack         ← must be marked
		//     │    ├─ STAT1-vstack    ← must be marked
		//     │    │    ├─ ratingLabel
		//     │    │    └─ ratingTitleLabel
		//     │    ├─ STAT2-vstack … (same pattern)
		//     ├─ ageLabel             (direct child ✓)
		//     └─ captainLabel         (direct child ✓)
		// ─────────────────────────────────────────────────────────────────────────
	private func setupSkeletonSupport() {
		isSkeletonable             = true
		contentView.isSkeletonable = true
		cardView.isSkeletonable    = true

			// Avatar – circular placeholder
		avatarImageView.isSkeletonable      = true
		avatarImageView.skeletonCornerRadius = 28

			// Direct children of cardView
		numberLabel.isSkeletonable    = true
		roleBadgeLabel.isSkeletonable = true
		ageLabel.isSkeletonable       = true
		captainLabel.isSkeletonable   = true

			// INFO stack (nameLabel.superview = UIStackView)
		nameLabel.superview?.isSkeletonable = true
		nameLabel.isSkeletonable            = true
		metaLabel.isSkeletonable            = true

			// STATS hstack → 5 vStacks → labels
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
			vStack.superview?.isSkeletonable = true   // hStack
		}
	}

		// MARK: - Configure

	func configure(with player: PlayerModel) {
		numberLabel.text = player.playerNumber ?? L10n.unknown
		nameLabel.text   = player.playerName   ?? L10n.playerNameUnknown

		let meta = [player.playerCountry ?? "", player.playerBirthdate ?? ""]
			.filter { !$0.isEmpty }.joined(separator: " · ")
		metaLabel.text     = meta.isEmpty ? nil : meta
		metaLabel.isHidden = meta.isEmpty

		avatarImageView.sd_setImage(
			with: URL(string: player.avatarURL ?? ""),
			placeholderImage: UIImage(named: "playerPlaceholder")
		)

		if let type = player.playerType, !type.isEmpty {
			roleBadgeLabel.text     = type.uppercased()
			roleBadgeLabel.isHidden = false
		} else {
			roleBadgeLabel.isHidden = true
		}

		ratingLabel.text      = player.playerRating      ?? "-"
		minutesLabel.text     = player.playerMinutes     ?? "-"
		matchPlayedLabel.text = player.playerMatchPlayed ?? "-"

		bind(value: goalsConcededLabel, title: gConcTitleLabel,  text: player.playerGoalsConceded)
		bind(value: savesLabel,         title: savesTitleLabel,   text: player.playerSaves)

		if let age = player.playerAge, !age.isEmpty {
			ageLabel.text     = "\(L10n.playerAge): \(age)"
			ageLabel.isHidden = false
		} else {
			ageLabel.isHidden = true
		}

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

		// MARK: - Styling

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
