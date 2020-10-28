//
//  CALayer.swift
//  Nexpil
//
//  Created by Admin on 6/16/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

extension CALayer {
    func addGradienBorder(colors:[UIColor],width:CGFloat = 1) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame =  CGRect(origin: CGPoint(x: 0, y:0), size: self.bounds.size)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)//CGPointMake(0.0, 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)//CGPointMake(1.0, 0.5)
        gradientLayer.colors = colors.map({$0.cgColor})
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        shapeLayer.path = UIBezierPath(rect: self.bounds).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = nil//UIColor.black.cgColor
        gradientLayer.mask = shapeLayer
        
        self.addSublayer(gradientLayer)
    }
    
}
