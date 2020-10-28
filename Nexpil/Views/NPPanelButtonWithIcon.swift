//
//  NPPanelButtonWithIcon.swift
//  Nexpil
//
//  Created by Cagri Sahan on 10/6/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

@IBDesignable class NPPanelButtonWithIcon: UIButton {

    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var parent: InformationCardEditableHolder?
    var view: UIView!
    var gradientLayer: CAGradientLayer!
    
    @IBInspectable var colorScheme: Int = 0 {
        didSet {
//            gradientLayer.colors = NPColorScheme(rawValue: colorScheme)!.gradient
            setNeedsLayout()
        }
    }
    
    @IBInspectable var titleText: String? {
        didSet {
            
            setNeedsLayout()
        }
    }
    
    @IBInspectable var descriptionText: String? {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var image: UIImage? {
        didSet {
            setNeedsLayout()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setup()
    }
    
    func xibSetup() {
        self.view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "NPPanelButtonWithIcon", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func setup() {
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = NPColorScheme(rawValue: colorScheme)!.gradient
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        view.layer.insertSublayer(gradientLayer, below: titleTextLabel.layer)
        
        gradientLayer.frame = self.bounds
        gradientLayer.masksToBounds = true
        
        self.layer.cornerRadius = 15.0
        view.layer.cornerRadius = 15.0
        self.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6.0)
    }
    
    override func layoutSubviews() {
        
        gradientLayer.colors = NPColorScheme(rawValue: colorScheme)!.gradient
        self.titleTextLabel.text = titleText
        self.iconImageView.image = image
        self.descriptionLabel.text = descriptionText
        
    }
}
