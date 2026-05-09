//
//  navBar.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 09/05/2026.
//
import UIKit
func applyNavBarAppearance(navigationController:UINavigationController?) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor   = .tabBarGradientStart
        appearance.shadowColor       = .clear

        let titleAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        appearance.titleTextAttributes = titleAttrs

        navigationController?.navigationBar.standardAppearance    = appearance
        navigationController?.navigationBar.scrollEdgeAppearance  = appearance
        navigationController?.navigationBar.compactAppearance     = appearance
        navigationController?.navigationBar.tintColor             = .white
    }
