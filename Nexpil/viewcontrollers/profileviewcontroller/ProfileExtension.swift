//
//  ProfileExtension.swift
//  Nexpil
//
//  Created by JinYingZhe on 1/25/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ProfileExtension: NSObject {
    //
}

enum PFontScheme: Int {
    case large_regular
    case large_medium
    case small_regular
    case small_medium
    
    var font: UIFont {
        switch self {
        case .large_regular:
            return UIFont(name: "Montserrat-Regular", size: 20)!
        case .large_medium:
            return UIFont(name: "Montserrat-Medium", size: 20)!
        case .small_regular:
            return UIFont(name: "Montserrat-Regular", size: 15)!
        case .small_medium:
            return UIFont(name: "Montserrat-Medium", size: 15)!
        }
    }
}

enum PColorScheme: Int {
    case black
    case gray
    case blue
    
    var color: UIColor {
        switch self {
        case .black:
            return UIColor(hex: "333333", alpha: 0.5)
        case .gray:
            return UIColor(hex: "333333", alpha: 1.0)
        case .blue:
            return UIColor(hex: "415CE3", alpha: 1.0)
        }
    }
    
    var gradient: [CGColor] {
        switch self {
        case .black:
            return [UIColor.black.cgColor, UIColor.black.cgColor]
        case .gray:
            return [UIColor(hex: "333333", alpha: 0.5).cgColor, UIColor(hex: "333333", alpha: 0.5).cgColor]
        case .blue:
            return [UIColor(hex: "8495ED", alpha: 1.0).cgColor, UIColor(hex: "415CE3", alpha: 1.0).cgColor]
        }
    }
}

enum PShadowType: Int {
    case large
    case medium
    case small
}

extension UIButton {
    func setPopItemBtnStyle(color backColor: UIColor) {
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font =  UIFont(name: "Montserrat-Regular", size: 20)
        self.backgroundColor = backColor
        
        self.setPopItemViewStyle()
    }
}

extension UIView {
    func setPopItemViewStyle(radius: CGFloat = 20.0, title: PShadowType = .small) {
        self.layer.shadowColor = UIColor.black.cgColor
        switch title {
        case .large:
            do {
                self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
                self.layer.shadowOpacity = 0.16
                self.layer.shadowRadius = 15.0
            }
            break
        case .medium:
            break
        case .small:
            do {
                self.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
                self.layer.shadowOpacity = 0.16
                self.layer.shadowRadius = 6.0
            }
            break
        }
        self.layer.masksToBounds = false
        self.layer.cornerRadius = radius
    }
    
    func setGradientStyle(gradient: [CGColor] = PColorScheme(rawValue: 2)!.gradient) {
        let gradiantLayer: CAGradientLayer = CAGradientLayer()
        gradiantLayer.frame = layer.frame
        gradiantLayer.colors = gradient
        gradiantLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradiantLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradiantLayer.cornerRadius = 20.0
        layer.insertSublayer(gradiantLayer, at: 0)
    }
    
}

extension UILabel {
    func setParagraphSpacing(space value: Int) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = CGFloat(value)
        paragraphStyle.alignment = .center
        
        let attrString = NSMutableAttributedString(string: self.text!)
        attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
}
