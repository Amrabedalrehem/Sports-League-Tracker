//
//  NetworkMonitor.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 05/05/2026.
//


import Foundation
import Alamofire
import UIKit

final class NetworkMonitor {
    
   
    static let shared = NetworkMonitor()
    private init() {}
   
    var isConnected: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
 
    func showNoInternet(on viewController: UIViewController) {
        let titleStr = "📡  " + L10n.noInternetTitle
        let msgStr   = "\n" + L10n.noInternetMessage

        let alert = UIAlertController(
            title: titleStr,
            message: msgStr,
            preferredStyle: .actionSheet
        )

        let titleAttr = NSAttributedString(
            string: titleStr,
            attributes: [
                .font: UIFont.systemFont(ofSize: 17, weight: .bold),
                .foregroundColor: UIColor.systemRed
            ]
        )
        let msgAttr = NSAttributedString(
            string: msgStr,
            attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                .foregroundColor: UIColor.secondaryLabel
            ]
        )

        alert.setValue(titleAttr, forKey: "attributedTitle")
        alert.setValue(msgAttr,   forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: L10n.alertOK, style: .cancel))

        viewController.present(alert, animated: true)
    }
}
