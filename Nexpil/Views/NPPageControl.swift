//
//  NPPageControl.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/22/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class NPPageControl: UIPageControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.pageIndicatorTintColor = UIColor(hex: "333333", alpha: 0.2)
        self.currentPageIndicatorTintColor = NPColorScheme.purple.color
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.pageIndicatorTintColor = UIColor(hex: "333333", alpha: 0.2)
        self.currentPageIndicatorTintColor = NPColorScheme.purple.color
    }
    
    override func draw(_ rect: CGRect) {
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        var startPos: Int = 0
        for i in 0..<self.numberOfPages {

            self.subviews[i].layer.cornerRadius = 5
            if i == currentPage {
                self.subviews[i].frame = CGRect(x: startPos, y: 0, width: 25, height: 10)
                self.subviews[i].backgroundColor = currentPageIndicatorTintColor
                self.subviews[i].layer.cornerRadius = 5
                startPos += 30
            }
            else {
                self.subviews[i].frame = CGRect(x: startPos, y: 0, width: 10, height: 10)
                self.subviews[i].backgroundColor = pageIndicatorTintColor
                self.subviews[i].layer.cornerRadius = 5
                startPos += 15
            }
        }
    }
}
