//
//  TeamEmptyStateView.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 06/05/2026.
//

import UIKit

class TeamEmptyStateView: UIView {

    static func loadFromNib() -> TeamEmptyStateView {
        UINib(nibName: "TeamEmptyStateView", bundle: nil)
            .instantiate(withOwner: nil, options: nil)
            .first as! TeamEmptyStateView
    }
}
