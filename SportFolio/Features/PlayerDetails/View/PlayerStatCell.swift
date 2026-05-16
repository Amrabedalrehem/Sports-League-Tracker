	///
	//  PlayerStatCell.swift
	//  SportFolio
	//

import UIKit
import SkeletonView

final class PlayerStatCell: UICollectionViewCell {

	@IBOutlet weak var cardView: UIView!

	@IBOutlet weak var seasonLabel: UILabel!
	@IBOutlet weak var typeLabel: UILabel!

	@IBOutlet weak var rankTitleLabel: UILabel!
	@IBOutlet weak var rankValueLabel: UILabel!

	@IBOutlet weak var titlesTitleLabel: UILabel!
	@IBOutlet weak var titlesValueLabel: UILabel!

	@IBOutlet weak var overallTitleLabel: UILabel!
	@IBOutlet weak var overallValueLabel: UILabel!

	@IBOutlet weak var hardTitleLabel: UILabel!
	@IBOutlet weak var hardValueLabel: UILabel!

	@IBOutlet weak var clayTitleLabel: UILabel!
	@IBOutlet weak var clayValueLabel: UILabel!

	@IBOutlet weak var grassTitleLabel: UILabel!
	@IBOutlet weak var grassValueLabel: UILabel!



	override func awakeFromNib() {
		super.awakeFromNib()

		setupSkeletonSupport()
		styleCard()
		localizeLabels()
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		hideSkeleton()
		contentView.hideSkeleton()
	}



		// MARK: - Configure

	func configure(with stat: PlayerStat) {

		seasonLabel.text = safeText(stat.season)

		let type = safeText(stat.type)

		if type == "-" {
			typeLabel.isHidden = true
		} else {
			typeLabel.isHidden = false
			typeLabel.text = type.uppercased()
		}

		rankValueLabel.text    = safeText(stat.rank)
		titlesValueLabel.text  = safeText(stat.titles)
		overallValueLabel.text = safeText(stat.overallWL)

		hardValueLabel.text  = safeText(stat.hardWL)
		clayValueLabel.text  = safeText(stat.clayWL)
		grassValueLabel.text = safeText(stat.grassWL)

		hideSkeleton()
		contentView.hideSkeleton()
	}



		// MARK: - Helpers

	private func safeText(_ text: String?) -> String {

		guard let text,
			  !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
		else {
			return "-"
		}

		return text
	}

	private func localizeLabels() {
		rankTitleLabel.text    = L10n.playerStatRank
		titlesTitleLabel.text  = L10n.playerStatTitles
		overallTitleLabel.text = L10n.playerStatOverall
		hardTitleLabel.text    = L10n.playerStatHard
		clayTitleLabel.text    = L10n.playerStatClay
		grassTitleLabel.text   = L10n.playerStatGrass
	}



		// MARK: - Styling

	private func styleCard() {

		cardView.layer.cornerRadius = 16
		cardView.layer.masksToBounds = false

		cardView.layer.shadowColor = UIColor.black.cgColor
		cardView.layer.shadowOpacity = 0.10
		cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
		cardView.layer.shadowRadius = 6

		cardView.backgroundColor = .cardBackground

		typeLabel.layer.cornerRadius = 8
		typeLabel.layer.masksToBounds = true
		typeLabel.backgroundColor = UIColor.systemBlue
		typeLabel.textColor = .white
		typeLabel.textAlignment = .center
	}
	private func setupSkeletonSupport() {

		isSkeletonable = true
		contentView.isSkeletonable = true
		cardView.isSkeletonable = true

		[
			seasonLabel,
			typeLabel,

			rankTitleLabel,
			rankValueLabel,

			titlesTitleLabel,
			titlesValueLabel,

			overallTitleLabel,
			overallValueLabel,

			hardTitleLabel,
			hardValueLabel,

			clayTitleLabel,
			clayValueLabel,

			grassTitleLabel,
			grassValueLabel

		].forEach {
			$0?.isSkeletonable = true
		}

		rankValueLabel.superview?.isSkeletonable = true
		titlesValueLabel.superview?.isSkeletonable = true
		overallValueLabel.superview?.isSkeletonable = true
		hardValueLabel.superview?.isSkeletonable = true
		clayValueLabel.superview?.isSkeletonable = true
		grassValueLabel.superview?.isSkeletonable = true
	}
}
