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
        let alert = UIAlertController(
            title: "📡  No Internet Connection",
            message: "\nIt looks like you're offline.\nPlease check your Wi-Fi or mobile data and try again.",
            preferredStyle: .actionSheet
        )
        
        let titleAttr = NSAttributedString(
            string: "📡  No Internet Connection",
            attributes: [
                .font: UIFont.systemFont(ofSize: 17, weight: .bold),
                .foregroundColor: UIColor.systemRed
            ]
        )
        let msgAttr = NSAttributedString(
            string: "\nIt looks like you're offline.\nPlease check your Wi-Fi or mobile data and try again.",
            attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                .foregroundColor: UIColor.secondaryLabel
            ]
        )
        
        alert.setValue(titleAttr, forKey: "attributedTitle")
        alert.setValue(msgAttr,   forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        viewController.present(alert, animated: true)
    }
}
