//
//  UIView.swift
//  Nexpil
//
//  Created by Admin on 4/12/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

extension UIView {
    func viewShadow()
    {
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = true;
        
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 0.5;
        self.layer.contentsScale = UIScreen.main.scale;
        self.layer.shadowColor = UIColor(white: 0, alpha: 0.16).cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 3.0;
        self.layer.shadowOpacity = 1;
        self.layer.masksToBounds = false;
        self.clipsToBounds = false;
    }
    
    func viewShadow_drug()
    {
        self.layer.cornerRadius = 20;
        self.layer.masksToBounds = true;
        
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 0.5;
        self.layer.contentsScale = UIScreen.main.scale;
        self.layer.shadowColor = UIColor(white: 0, alpha: 0.16).cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 2.5)
        self.layer.shadowRadius = 3.5;
        self.layer.shadowOpacity = 1;
        self.layer.masksToBounds = false;
        self.clipsToBounds = false;
    }
    
    func viewShadow_Category()
    {
        self.layer.cornerRadius = 20;
        self.layer.masksToBounds = true;
        
//        self.layer.borderColor = UIColor.white.cgColor
//        self.layer.borderWidth = 0.5;
        self.layer.contentsScale = UIScreen.main.scale;
        self.layer.shadowColor = UIColor(white: 0, alpha: 0.3).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3.5)
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.6;
        self.layer.masksToBounds = false;
        self.clipsToBounds = false;
    }
    
    func viewUnShadow()
    {
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = true;
        
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 0;
        self.layer.contentsScale = UIScreen.main.scale;
        self.layer.shadowColor = UIColor(white: 0, alpha: 0.16).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 0;
        self.layer.shadowOpacity = 0;
        self.layer.masksToBounds = false;
        self.clipsToBounds = false;
    }
    func setGradientBackground(colorOne:UIColor,colorTwo:UIColor)
    {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
        
        self.layer.cornerRadius = 10;
        self.clipsToBounds = true
        
    }
    func backgroundBlur(view:UIView)->VisualEffectView
    {
        let visualEffectView = VisualEffectView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        // Configure the view with tint color, blur radius, etc
        visualEffectView.colorTint = UIColor.black
        visualEffectView.colorTintAlpha = 0.5
        visualEffectView.blurRadius = 5
        visualEffectView.scale = 1
        
        //addSubview(visualEffectView)
        return visualEffectView
    }
    
    // Omer's extensions
    
    func setGradient(colors: [CGColor], angle: Float = 0) {
        layer.backgroundColor = UIColor.clear.cgColor
        let gradient: CAGradientLayer = {
            if let gradientLayers = self.layer.sublayers?.filter({ $0 is CAGradientLayer }) {
                for gradientLayer in gradientLayers {
                    if gradientLayer.bounds == self.frame {
                        return gradientLayer as! CAGradientLayer
                    }
                }
                return CAGradientLayer()
            }
            else {
                return CAGradientLayer()
            }
        }()

        gradient.frame = self.bounds
        gradient.colors = colors
        
        let alpha: Float = angle / 360
        let startPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.75) / 2)),
            2
        )
        let startPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0) / 2)),
            2
        )
        let endPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.25) / 2)),
            2
        )
        let endPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0.5) / 2)),
            2
        )
        
        gradient.endPoint = CGPoint(x: CGFloat(endPointX),y: CGFloat(endPointY))
        gradient.startPoint = CGPoint(x: CGFloat(startPointX), y: CGFloat(startPointY))
        
        if let button = self as? UIButton {
            self.layer.insertSublayer(gradient, below: button.imageView?.layer)
        }
        else {
            layer.insertSublayer(gradient, at: 0)
        }
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat){
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        if let sublayers = layer.sublayers {
            for sublayer in sublayers {
                if sublayer.frame == bounds {
                    sublayer.mask = maskLayer
                    return
                }
            }
        }
        let backgroundLayer = CALayer()
        backgroundLayer.frame = bounds
        backgroundLayer.backgroundColor = layer.backgroundColor
        layer.backgroundColor = UIColor.clear.cgColor
        layer.insertSublayer(backgroundLayer, at: 0)
        backgroundLayer.mask = maskLayer
        backgroundLayer.masksToBounds = true
    }
    
    func addShadow(color: CGColor, alpha: Float, x: CGFloat, y: CGFloat, blur: CGFloat) {
        if let mask = layer.sublayers?.first?.mask as? CAShapeLayer {
            print("keraneci osman")
            layer.shadowPath = mask.path
        }
        layer.shadowColor = color
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowOpacity = alpha
        layer.shadowRadius = blur
    }
    
    func hideShadow() {
        layer.shadowOpacity = 0
    }
    
    func showShadow() {
        layer.shadowOpacity = 0.16
    }
}
