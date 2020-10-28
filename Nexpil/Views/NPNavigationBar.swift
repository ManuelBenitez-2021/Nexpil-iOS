//
//  NPNavigationBar.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/24/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class NPNavigationBar: UINavigationBar {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        for subview in self.subviews {
            let stringFromClass = NSStringFromClass(subview.classForCoder)
            //Can't set height of the UINavigationBarContentView
            if stringFromClass.contains("UINavigationBarContentView") {
                
                //Set Center Y
                subview.frame = CGRect(x: 0, y: 9.5, width: self.frame.width, height: subview.frame.height)
                subview.sizeToFit()
            }
        }
    }
    
    override func pushItem(_ item: UINavigationItem, animated: Bool) {
        return super.pushItem(item, animated: false)
    }
    
    override func popItem(animated: Bool) -> UINavigationItem? {
        return super.popItem(animated: false)
    }
}
