//
//  ColorsHelper.swift
//  SportFolio
//
//  Created by Shahuda on 05/05/2026.
//

import UIKit

extension UIColor {

    // MARK: – Backgrounds
  //  static var appBackground: UIColor  { UIColor(named: "AppBackground")!  }
    static var cardBG:        UIColor  { UIColor(named: "CardBackground")!  }
    static var imageBG:       UIColor  { UIColor(named: "ImageBackground")! }

    // MARK: – Text
  //  static var mainText:      UIColor  { UIColor(named: "MainText")!        }
  //  static var secondaryText: UIColor  { UIColor(named: "SecondaryText")!   }

    // MARK: – Brand
   // static var primaryBlue:   UIColor  { UIColor(named: "PrimaryBlue")!    }

    // MARK: – Borders & Shadows
    static var borderColor:    UIColor { UIColor(named: "BorderColor")!     }
    static var shadowColorApp: UIColor { UIColor(named: "ShadowColor")!     }

    // MARK: – Tab Bar
   // static var tabBarBlue:          UIColor { UIColor(named: "TabBarBlue ")!   }
  //  static var tabBarGray:          UIColor { UIColor(named: "TabBarGray")!    }
   // static var tabBarGradientStart: UIColor { UIColor(named: "TabBarGradientStart") ?? .primaryBlue }
 //   static var tabBarGradientEnd:   UIColor { UIColor(named: "TabBarGradientEnd")   ?? UIColor(red: 0.196, green: 0.620, blue: 0.965, alpha: 1) }

    // MARK: – Misc
   // static var goalkeeperBadge: UIColor { UIColor(named: "GoalkeeperBadge")! }

    // MARK: – Derived
    static var primaryBlueBorder: UIColor { primaryBlue.withAlphaComponent(0.15) }
    static var primaryBlueLight:  UIColor { primaryBlue.withAlphaComponent(0.35) }
}
 
 
