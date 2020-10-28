//
//  InformationCard.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/5/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

@IBDesignable class InformationCardButton: UIView {
    
    @IBOutlet weak var textView: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    var view: UIView!
    
    
    @IBInspectable var identifierText: String = "" {
        didSet {
            self.textView.placeholder = identifierText
        }
    }
    @IBInspectable var valueText: String = "" {
        didSet {
            self.textView.text = valueText
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
        let nib = UINib(nibName: "InformationCardButton", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func setup() {
        
        self.textView.text = valueText
        self.backgroundColor = nil
        view.layer.cornerRadius = 15
        view.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6.0)
    }
    
    
    
}
