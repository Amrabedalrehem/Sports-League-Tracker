//
//  ColorsHelper.swift
//  SportFolio
//
//  Created by Shahuda on 05/05/2026.
//
 
import UIKit

extension UIColor {
  
    static var cardBG:   UIColor { .cardBackground }
      static var imageBG:  UIColor { .imageBackground }
     static var shadowColorApp: UIColor { UIColor(named: "ShadowColor")! }
   static var primaryBlueBorder: UIColor { .primaryBlue.withAlphaComponent(0.15) }
    static var primaryBlueLight:  UIColor { .primaryBlue.withAlphaComponent(0.35) }
}
