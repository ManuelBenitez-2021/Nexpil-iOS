//
//  ShadowInput.swift
//  Nexpil
//
//  Created by Yun Lai on 2018/12/13.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

@IBDesignable class ShadowInput: UIView {
    
    @IBOutlet weak var textView: UITextField!
    
    var parent: InformationCardEditableHolder?
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
        let nib = UINib(nibName: "ShadowInput", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func setup() {
        
        self.textView.text = valueText
        self.backgroundColor = nil
        view.layer.cornerRadius = 15
        view.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6.0)
    }
    
    @objc func cardPressed(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .began {
            view.hideShadow()
            print("began")
        }
        else {
            view.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6.0)
            print("else")
            if recognizer.state == .recognized {
                parent?.cardTapped(withIdentifier: identifierText)
                print("recognized")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.hideShadow()
        textView.becomeFirstResponder()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        view.showShadow()
        
        guard let touchPoint = touches.first?.location(in: self) else { return }
        if self.bounds.contains(touchPoint) {
            parent?.cardTapped(withIdentifier: identifierText)
        }
    }
}

