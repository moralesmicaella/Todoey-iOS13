//
//  Color.swift
//  Todoey
//
//  Created by Micaella Morales on 12/28/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
    
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return(red, green, blue, alpha)
    }
    
    var hexString: String {
        let hex: Int = (Int) (rgba.red * 255) << 24 |
                       (Int) (rgba.green * 255) << 16 |
                       (Int) (rgba.blue * 255) << 8 |
                       (Int) (rgba.alpha * 255) << 0
        return String(format:"#%08x", hex)
    }
    
    var isDark: Bool {
        let lum = 0.2126 * rgba.red + 0.7152 * rgba.green + 0.0722 * rgba.blue
        return  lum < 0.50
    }
    
    convenience init(hex: String) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 8, "Invalid hex code used.")

        var rgbaValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbaValue)

        self.init(red: CGFloat((rgbaValue & 0xFF000000) >> 24) / 255.0,
                  green: CGFloat((rgbaValue & 0x00FF0000) >> 16) / 255.0,
                  blue: CGFloat((rgbaValue & 0x0000FF00) >> 8) / 255.0,
                  alpha: CGFloat((rgbaValue & 0x000000FF) >> 0) / 255.0)
    }
    
    private func adjust(by percentage: CGFloat) -> UIColor {
        let minValue = 0.1
        let maxValue = 0.9
        return UIColor(
            red: max(minValue, min(maxValue, rgba.red + percentage)),
            green: max(minValue, min(maxValue, rgba.green + percentage)),
            blue: max(minValue, min(maxValue, rgba.blue + percentage)),
            alpha: rgba.alpha)
    }
    
    func darken(by percentage: CGFloat = 0.1) -> UIColor {
        return adjust(by: percentage * -1)
    }
    
}
