//
//  InformationCard.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/5/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

@IBDesignable class InformationCard: UIView {
        
    @IBOutlet weak var identifier: UILabel!
    @IBOutlet weak var value: UILabel!
    
    var parent: InformationCardEditableHolder?
    var view: UIView!
    
    
    @IBInspectable var identifierText: String = "Full Name" {
        didSet {
            self.identifier.text = identifierText
        }
    }
    @IBInspectable var valueText: String = "Olivia Wilson" {
        didSet {
            self.value.text = valueText
        }
    }
    
    @IBInspectable var identifierColor: UIColor = #colorLiteral(red: 0.2235294118, green: 0.8274509804, blue: 0.8901960784, alpha: 1) {
        didSet {
            self.identifier.textColor = identifierColor
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
        let nib = UINib(nibName: "InformationCard", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func setup() {
        
        self.identifier.text = identifierText
        self.value.text = valueText
        self.identifier.textColor = identifierColor
        self.backgroundColor = nil
        view.roundCorners(.allCorners, radius: 15.0)
        view.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6.0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.hideShadow()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.showShadow()
        
        guard let touchPoint = touches.first?.location(in: self) else { return }
        if self.bounds.contains(touchPoint) {
            parent?.cardTapped(withIdentifier: identifierText)
        }
        super.touchesEnded(touches, with: event)
    }
}
