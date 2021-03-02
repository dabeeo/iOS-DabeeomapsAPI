//
//  UIColor+Extension.swift
//  Docent
//
//  Created by Dabeeo on 2020/10/16.
//  Copyright © 2020 Dabeeo. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// red: 232.0, green: 70.0, blue: 29.0, alpha: 1.0
    @nonobjc class var docentMainColor01: UIColor {
        return UIColor(red: 232.0/255.0, green: 70.0/255.0, blue: 29.0/255.0, alpha: 1.0)
    }
    
    /// red: 33.0, green: 100.0, blue: 201.0, alpha: 1.0
    @nonobjc class var docentSubColor01: UIColor {
        return UIColor(red: 33.0/255.0, green: 100.0/255.0, blue: 201.0/255.0, alpha: 1.0)
    }
    
    /// red: 209.0, green: 47.0, blue: 61.0, alpha: 1.0
    @nonobjc class var docentSubColor02: UIColor {
        return UIColor(red: 209.0/255.0, green: 47.0/255.0, blue: 61.0/255.0, alpha: 1.0)
    }
    
    /* 이건 심플리에서 그라데이션으로 작업되어 있어서 제거
    @nonobjc class var docentMapColor01: UIColor {
        return UIColor()
    }*/
    
    /// red: 67.0, green: 255.0, blue: 232.0, alpha: 1.0
    @nonobjc class var docentMapColor02: UIColor {
        return UIColor(red: 67.0/255.0, green: 255.0/255.0, blue: 232.0/255.0, alpha: 1.0)
    }
    
    /// red: 62.0, green: 62.0, blue: 62.0, alpha: 1.0
    @nonobjc class var docentBackgroundColor01: UIColor {
        return UIColor(red: 62.0/255.0, green: 62.0/255.0, blue: 62.0/255.0, alpha: 1.0)
    }
    
    /// red: 52.0, green: 54.0, blue: 56.0, alpha: 1.0
    @nonobjc class var docentBackgroundColor02: UIColor {
        return UIColor(red: 52.0/255.0, green: 54.0/255.0, blue: 56.0/255.0, alpha: 1.0)
    }
    
    /// red: 44.0, green: 45.0, blue: 46.0, alpha: 1.0
    @nonobjc class var docentBackgroundColor03: UIColor {
        return UIColor(red: 44.0/255.0, green: 45.0/255.0, blue: 46.0/255.0, alpha: 1.0)
    }
    
    /// red: 54.0, green: 54.0, blue: 54.0, alpha: 1.0
    @nonobjc class var docentLineColor01: UIColor {
        return UIColor(red: 54.0/255.0, green: 54.0/255.0, blue: 54.0/255.0, alpha: 1.0)
    }
    
    /// red: 88.0, green: 88.0, blue: 88.0, alpha: 1.0
    @nonobjc class var docentLineColor02: UIColor {
        return UIColor(red: 88.0/255.0, green: 88.0/255.0, blue: 88.0/255.0, alpha: 1.0)
    }
    
    /// red: 214.0, green: 214.0, blue: 214.0, alpha: 1.0
    @nonobjc class var docentGrayColor01: UIColor {
        return UIColor(red: 214.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 1.0)
    }
    
    /// red: 153.0, green: 153.0, blue: 153.0, alpha: 1.0
    @nonobjc class var docentGrayColor02: UIColor {
        return UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
    }
    
    /// red: 121.0, green: 121.0, blue: 121.0, alpha: 1.0
    @nonobjc class var docentGrayColor03: UIColor {
        return UIColor(red: 121.0/255.0, green: 121.0/255.0, blue: 121.0/255.0, alpha: 1.0)
    }
    
    /// red: 84.0, green: 84.0, blue: 84.0, alpha: 1.0
    @nonobjc class var docentGrayColor04: UIColor {
        return UIColor(red: 84.0/255.0, green: 84.0/255.0, blue: 84.0/255.0, alpha: 1.0)
    }
    
    static func setColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}
