//
//  DrugInfoCard.swift
//  Nexpil
//
//  Created by Yun Lai on 2018/12/4.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

@IBDesignable class DrugInfoCard: UIView {

    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    
    var view: UIView!
    
    
    @IBInspectable var card_icon: UIImage? = nil {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var card_title: String? = nil {
        didSet {
            setNeedsLayout()
        }
    }

    override func layoutSubviews() {
        self.ivIcon.image = card_icon
        self.lbTitle.text = card_title

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
        let nib = UINib(nibName: "DrugInfoCard", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func setup() {
        self.layer.cornerRadius = 10.0
        view.layer.cornerRadius = 10.0
        self.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 2, blur: 2.0)
    }

}
