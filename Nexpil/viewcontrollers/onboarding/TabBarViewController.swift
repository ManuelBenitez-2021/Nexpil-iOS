//
//  TabBarViewController.swift
//  Nexpil
//
//  Created by Yun Lai on 2018/12/10.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

var mTabView: TabbarView = TabbarView()

class TabBarViewController: UITabBarController {
    var mTabs: [TabObj] = [TabObj]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func initUI() {
        self.selectedIndex = 0
        self.tabBar.isHidden = true
        
        let margin: CGFloat = 10
        let width: CGFloat = self.view.frame.width - CGFloat(margin * 2)
        let height: CGFloat = 66
        let x: CGFloat = margin
        let y: CGFloat = self.view.frame.size.height - CGFloat(height + margin * 2)
        
        initTabs()
        
        mTabView = TabbarView.init(frame: CGRect.init(x: x, y: y, width: width, height: height), tabs: mTabs)
        mTabView.viewShadow_drug()
        mTabView.setSelectedIndex(0)
        mTabView.blockSelected = {
            (tabObj: TabObj) -> Void in
            let index = self.mTabs.index(of: tabObj)
            self.selectedIndex = index ?? 0
        }
        
        self.view.addSubview(mTabView)
    }
    
    func initTabs() {

        let tabHome: TabObj = TabObj.init(name: "Home", image: "bot_home_grey", imageSelected: "bot_home_drk_purp")
        let tabHealth: TabObj = TabObj.init(name: "Health", image: "bot_health_grey", imageSelected: "bot_health_drk_purp")
        let tabCommunity: TabObj = TabObj.init(name: "Community", image: "bot_comm_grey", imageSelected: "bot_comm_drk_purp")
        let tabProfile: TabObj = TabObj.init(name: "Profile", image: "bot_prof_grey", imageSelected: "bot_prof_drk_purp")
        
        mTabs.append(tabHome)
        mTabs.append(tabHealth)
        mTabs.append(tabCommunity)
        mTabs.append(tabProfile)
    }
    
}
