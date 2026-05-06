//
//  TeamLoadingOverlayView.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 06/05/2026.
//

import UIKit

class TeamLoadingOverlayView: UIView {

    @IBOutlet weak var spinner: UIActivityIndicatorView!

    static func loadFromNib() -> TeamLoadingOverlayView {
        UINib(nibName: "TeamLoadingOverlayView", bundle: nil)
            .instantiate(withOwner: nil, options: nil)
            .first as! TeamLoadingOverlayView
    }
}
