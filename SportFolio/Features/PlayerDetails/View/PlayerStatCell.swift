//
//  PlayerStatCell.swift
//  SportFolio
//

import UIKit
import SkeletonView

final class PlayerStatCell: UICollectionViewCell {


    @IBOutlet weak var cardView:        UIView!
    @IBOutlet weak var seasonLabel:     UILabel!
    @IBOutlet weak var typeLabel:       UILabel!

    @IBOutlet weak var rankTitleLabel:    UILabel!
    @IBOutlet weak var rankValueLabel:    UILabel!

    @IBOutlet weak var titlesTitleLabel:  UILabel!
    @IBOutlet weak var titlesValueLabel:  UILabel!

    @IBOutlet weak var overallTitleLabel: UILabel!
    @IBOutlet weak var overallValueLabel: UILabel!

    @IBOutlet weak var hardTitleLabel:    UILabel!
    @IBOutlet weak var hardValueLabel:    UILabel!

    @IBOutlet weak var clayTitleLabel:    UILabel!
    @IBOutlet weak var clayValueLabel:    UILabel!

    @IBOutlet weak var grassTitleLabel:   UILabel!
    @IBOutlet weak var grassValueLabel:   UILabel!



    override func awakeFromNib() {
        super.awakeFromNib()
        setupSkeletonSupport()
        styleCard()
        localizeLabels()
    }



    func configure(with stat: PlayerStat) {
        seasonLabel.text = stat.season ?? L10n.unknown
        typeLabel.text   = stat.type?.uppercased() ?? ""
        typeLabel.isHidden = stat.type == nil || stat.type!.isEmpty

        rankValueLabel.text    = stat.rank    ?? "-"
        titlesValueLabel.text  = stat.titles  ?? "-"
        overallValueLabel.text = stat.overallWL ?? "-"
        hardValueLabel.text    = stat.hardWL    ?? "-"
        clayValueLabel.text    = stat.clayWL    ?? "-"
        grassValueLabel.text   = stat.grassWL   ?? "-"

      
        setRow(title: hardTitleLabel,  value: hardValueLabel,  visible: stat.hardWL != nil)
        setRow(title: clayTitleLabel,  value: clayValueLabel,  visible: stat.clayWL != nil)
        setRow(title: grassTitleLabel, value: grassValueLabel, visible: stat.grassWL != nil)
    }



    private func setRow(title: UILabel, value: UILabel, visible: Bool) {
        title.isHidden = !visible
        value.isHidden = !visible
    }

    private func localizeLabels() {
        rankTitleLabel.text    = L10n.playerStatRank
        titlesTitleLabel.text  = L10n.playerStatTitles
        overallTitleLabel.text = L10n.playerStatOverall
        hardTitleLabel.text    = L10n.playerStatHard
        clayTitleLabel.text    = L10n.playerStatClay
        grassTitleLabel.text   = L10n.playerStatGrass
    }

    private func styleCard() {
        cardView.layer.cornerRadius  = 16
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor   = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.10
        cardView.layer.shadowOffset  = CGSize(width: 0, height: 3)
        cardView.layer.shadowRadius  = 6
        cardView.backgroundColor     = .cardBackground

        typeLabel.layer.cornerRadius  = 8
        typeLabel.layer.masksToBounds = true
        typeLabel.backgroundColor     = UIColor.systemBlue
        typeLabel.textColor           = .white
        typeLabel.textAlignment       = .center
    }

    private func setupSkeletonSupport() {
        isSkeletonable             = true
        contentView.isSkeletonable = true
        cardView.isSkeletonable    = true

        [seasonLabel, typeLabel,
         rankTitleLabel, rankValueLabel,
         titlesTitleLabel, titlesValueLabel,
         overallTitleLabel, overallValueLabel,
         hardTitleLabel, hardValueLabel,
         clayTitleLabel, clayValueLabel,
         grassTitleLabel, grassValueLabel].forEach {
            $0?.isSkeletonable = true
        }

        // Mark intermediate stack views
        rankValueLabel.superview?.isSkeletonable    = true
        titlesValueLabel.superview?.isSkeletonable  = true
        overallValueLabel.superview?.isSkeletonable = true
        hardValueLabel.superview?.isSkeletonable    = true
        clayValueLabel.superview?.isSkeletonable    = true
        grassValueLabel.superview?.isSkeletonable   = true
    }
}
