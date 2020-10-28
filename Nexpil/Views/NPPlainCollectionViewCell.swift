//
//  NPPlainCollectionViewCell.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/28/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class NPPlainCollectionViewCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.view.backgroundColor = NPColorScheme.aqua.color
                self.textLabel.textColor = .white
                self.hideShadow()
                
            }
            else {
                self.view.backgroundColor = .white
                self.textLabel.textColor = .black
                self.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6)
                
            }
        }
    }

    @IBOutlet weak var textLabel: UILabel!
    var view: UIView!
    
    
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
        let nib = UINib(nibName: "NPPlainCollectionViewCell", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func setup() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        //view.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6)
        //view.layer.masksToBounds = true
        //view.clipsToBounds = true
        //self.layer.cornerRadius = 20
        //self.addShadow(color: UIColor.black.cgColor, alpha: 0.16, x: 0, y: 3, blur: 6)
        
    }
}
