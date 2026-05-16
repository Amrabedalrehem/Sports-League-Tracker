//
//  TournamentCell.swift
//  SportFolio
//

import UIKit
import SkeletonView

final class TournamentCell: UICollectionViewCell {



    @IBOutlet weak var cardView:        UIView!
    @IBOutlet weak var nameLabel:       UILabel!
    @IBOutlet weak var seasonLabel:     UILabel!
    @IBOutlet weak var typeBadgeLabel:  UILabel!

    @IBOutlet weak var surfaceTitleLabel: UILabel!
    @IBOutlet weak var surfaceValueLabel: UILabel!

    @IBOutlet weak var prizeTitleLabel:   UILabel!
    @IBOutlet weak var prizeValueLabel:   UILabel!

    @IBOutlet weak var surfaceIconLabel:  UILabel!

  

    override func awakeFromNib() {
        super.awakeFromNib()
        setupSkeletonSupport()
        styleCard()
        localizeLabels()
    }



    func configure(with tournament: Tournament) {
        nameLabel.text   = tournament.name   ?? L10n.unknown
        seasonLabel.text = tournament.season ?? ""
        seasonLabel.isHidden = tournament.season == nil || tournament.season!.isEmpty

        if let type = tournament.type, !type.isEmpty {
            typeBadgeLabel.text     = type.uppercased()
            typeBadgeLabel.isHidden = false
        } else {
            typeBadgeLabel.isHidden = true
        }


        let surface = tournament.surface
        surfaceValueLabel.text = surface ?? "-"
        surfaceIconLabel.text  = surfaceEmoji(for: surface)
        let hasSurface = surface != nil && !surface!.isEmpty
        surfaceTitleLabel.isHidden = !hasSurface
        surfaceValueLabel.isHidden = !hasSurface
        surfaceIconLabel.isHidden  = !hasSurface


        let prize = tournament.prize
        prizeValueLabel.text = prize ?? "-"
        let hasPrize = prize != nil && !prize!.isEmpty
        prizeTitleLabel.isHidden = !hasPrize
        prizeValueLabel.isHidden = !hasPrize
    }



    private func surfaceEmoji(for surface: String?) -> String {
        switch surface?.lowercased() {
        case "hard":  return "🔵"
        case "clay":  return "🟠"
        case "grass": return "🟢"
        default:      return "🎾"
        }
    }

    private func localizeLabels() {
        surfaceTitleLabel.text = L10n.tournamentSurface
        prizeTitleLabel.text   = L10n.tournamentPrize
    }

    private func styleCard() {
        cardView.layer.cornerRadius  = 14
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor   = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.09
        cardView.layer.shadowOffset  = CGSize(width: 0, height: 3)
        cardView.layer.shadowRadius  = 6
        cardView.backgroundColor     = .cardBackground

        typeBadgeLabel.layer.cornerRadius  = 8
        typeBadgeLabel.layer.masksToBounds = true
        typeBadgeLabel.backgroundColor     = UIColor.systemIndigo
        typeBadgeLabel.textColor           = .white
        typeBadgeLabel.textAlignment       = .center
    }

    private func setupSkeletonSupport() {
        isSkeletonable             = true
        contentView.isSkeletonable = true
        cardView.isSkeletonable    = true

        [nameLabel, seasonLabel, typeBadgeLabel,
         surfaceTitleLabel, surfaceValueLabel,
         prizeTitleLabel, prizeValueLabel,
         surfaceIconLabel].forEach {
            $0?.isSkeletonable = true
        }

        nameLabel.superview?.isSkeletonable    = true
        surfaceValueLabel.superview?.isSkeletonable = true
        prizeValueLabel.superview?.isSkeletonable   = true
    }
}
