//
//  WelcomeCard.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/18/18.
//  Copyright © 2018 Admin. All rights reserved.
//


import UIKit

@IBDesignable class WelcomeCard: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var topAncher: NSLayoutConstraint!
    
    var parent: InformationCardEditableHolder?
    var view: UIView!
    
    
    var titleText: NSMutableAttributedString? {
        didSet {
            self.titleLabel.attributedText = titleText
        }
    }
    
    var descriptionText: NSMutableAttributedString? {
        didSet {
            self.descriptionLabel.attributedText = descriptionText
        }
    }
    
    var image: UIImage? {
        didSet {
            self.imageView.image = image
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
        let nib = UINib(nibName: "WelcomeCard", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func setup() {
        self.layer.cornerRadius = 10.0
        view.layer.cornerRadius = 10.0
        self.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6.0)
    }
}
