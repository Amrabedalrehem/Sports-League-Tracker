//
//  TeamEmptyStateView.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 06/05/2026.
//

import UIKit

class TeamEmptyStateView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    static func loadFromNib() -> TeamEmptyStateView {
        let view = UINib(nibName: "TeamEmptyStateView", bundle: nil)
            .instantiate(withOwner: nil, options: nil)
            .first as! TeamEmptyStateView
        view.configure()
        return view
    }

    private func configure() {
        titleLabel?.text    = L10n.emptySquadTitle
        subtitleLabel?.text = L10n.emptySquadSubtitle
    }
}
