//
//  HomeTabViewController.swift
//  Nexpil
//
//  Created by Admin on 4/6/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import XLPagerTabStrip
import CVCalendar

protocol HomeSubMenuDelegate {
    func selectDay(value:Int) -> String
    func navColorChange(value:Int)
}

class HomeTabViewController: ButtonBarPagerTabStripViewController,HomeSubMenuDelegate,UITabBarControllerDelegate  {
    
    @IBOutlet weak var m_vwTopNavBar: UIView!
    @IBOutlet weak var m_vwTopContainer: UIView!
    
    @IBOutlet weak var m_vwRadialRight: UIView!
    @IBOutlet weak var m_vwRadialLeft: UIView!
    
    @IBOutlet weak var m_fabAdd: FAButton!
    
    
    @IBOutlet weak var m_vwSeperate: UIView!
    @IBOutlet weak var m_stvwCalender: UIStackView!
    @IBOutlet weak var sunView: UIView!
    @IBOutlet weak var monView: UIView!
    @IBOutlet weak var tueView: UIView!
    @IBOutlet weak var wedView: UIView!
    @IBOutlet weak var thuView: UIView!
    @IBOutlet weak var friView: UIView!
    @IBOutlet weak var satView: UIView!
    
    @IBOutlet weak var sunday: UILabel!
    @IBOutlet weak var monday: UILabel!
    @IBOutlet weak var tueday: UILabel!
    @IBOutlet weak var wedday: UILabel!
    @IBOutlet weak var thuday: UILabel!
    @IBOutlet weak var friday: UILabel!
    @IBOutlet weak var satday: UILabel!
    
    @IBOutlet weak var sunlabel: UILabel!
    @IBOutlet weak var monlabel: UILabel!
    @IBOutlet weak var tuelabel: UILabel!
    @IBOutlet weak var wedlabel: UILabel!
    @IBOutlet weak var thulabel: UILabel!
    @IBOutlet weak var frilabel: UILabel!
    @IBOutlet weak var satlabel: UILabel!
    
    @IBOutlet weak var m_vwSunIndicator: UIView!
    @IBOutlet weak var m_vwMonIndicator: UIView!
    @IBOutlet weak var m_vwTueIndicator: UIView!
    @IBOutlet weak var m_vwWedIndicator: UIView!
    @IBOutlet weak var m_vwThuIndicator: UIView!
    @IBOutlet weak var m_vwFriIndicator: UIView!
    @IBOutlet weak var m_vwSatIndicator: UIView!
    
    
    @IBOutlet weak var m_vwMorning: UIView!
    @IBOutlet weak var m_ivMorning: UIImageView!
    @IBOutlet weak var m_cnstvwMorning: NSLayoutConstraint!
    
    @IBOutlet weak var m_vwMidDay: UIView!
    @IBOutlet weak var m_ivMidDay: UIImageView!
    @IBOutlet weak var m_cnstvwMidDay: NSLayoutConstraint!
    
    @IBOutlet weak var m_vwEvening: UIView!
    @IBOutlet weak var m_ivEvening: UIImageView!
    @IBOutlet weak var m_cnstvwEvening: NSLayoutConstraint!
    
    @IBOutlet weak var m_vwNight: UIView!
    @IBOutlet weak var m_ivNight: UIImageView!
    @IBOutlet weak var m_cnstvwNight: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var m_cnstTopContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var currentDate: UILabel!
    var oldCell:ButtonBarViewCell?
    var newCell:ButtonBarViewCell?
    
    var dateShow:Bool = false
    
    var dateViews:[UIView]?
    var daylabels:[UILabel]?
    var datelabels:[UILabel]?
    var indictorVWArray: [UIView] = []
    var dateString:[String] = []
    
    var child_1:MorningViewController1?
    var child_2:MiddayViewController?
    var child_3:EveningViewController?
    var child_4:NightViewController?
    
    var selectedDay = 0
    var dateString1:[String] = []
    var currentDateString = ""
    var dateColor:UIColor?
    var currentTimeTag:Int = 0
    var currentDayOfWeek:Int = 0
    
    var colorMorningActive = UIColor.init(hexString: "#39D3E3")
    var colorMidDayActive = UIColor.init(hexString: "#397EE3")
    var colorEveningActive = UIColor.init(hexString: "#415CE3")
    var colorNightActive = UIColor.init(hexString: "#4939E3")
    var colorDeactive = UIColor.init(hexString: "#707070")
    
    
    var m_fltNavLbHeight = 10
    
    var navIVArray: [UIImageView] = []
    var navVWArray: [UIView] = []
    var navColorActiveArray: [UIColor] = []
    var addBtnImagePathArray: [String] = []
    var topNavActiveArray: [String] = []
    var topNavDeactiveArray: [String] = []
    
    
    @IBOutlet weak var dayofWeek: UIButton!
    @IBOutlet weak var pointLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        initNavBar()
        
        self.view.backgroundColor = UIColor.init(hexString: "#F7F7F7")
        
        // Do any additional setup after loading the view.
        containerView.isScrollEnabled = false
        barSettings()
        
        showCalendar(bShow: false)
        
        self.tabBarController?.delegate = self
        
        dateViews = [sunView,monView,tueView,wedView,thuView,friView,satView]
        daylabels = [sunlabel,monlabel,tuelabel,wedlabel,thulabel,frilabel,satlabel]
        datelabels = [sunday,monday,tueday,wedday,thuday,friday,satday]
        indictorVWArray = [m_vwSunIndicator, m_vwMonIndicator, m_vwTueIndicator, m_vwWedIndicator, m_vwThuIndicator, m_vwFriIndicator, m_vwSatIndicator]
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        formatter.timeZone = TimeZone.current
        
        self.buttonBarView.backgroundColor = nil
        
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "yyyy-MM-dd"
        formatter2.timeZone = TimeZone.current
        
        let current = formatter2.string(from: currentDateTime)
        
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "dd"
        formatter1.timeZone = TimeZone.current
        
        /*
        //var comp: DateComponents = Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: formatter2.date(from: current)!)
        var comp: DateComponents = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: formatter2.date(from: current)!)
        //comp.timeZone = TimeZone(secondsFromGMT: 0)
        comp.timeZone = TimeZone.current
        //let mondayDate = Calendar(identifier: .iso8601).date(from: comp)!
        let mondayDate = Calendar.current.date(from: comp)!
        */
        let (mondayDate,index) = getCurrentDayIndex(current: current)
        
        
        sunday.text = formatter1.string(from: Calendar.current.date(byAdding: .day, value: -1, to: mondayDate)!)
        monday.text = formatter1.string(from: mondayDate)
        tueday?.text = formatter1.string(from: Calendar.current.date(byAdding: .day, value: 1, to: mondayDate)!)
        wedday?.text = formatter1.string(from: Calendar.current.date(byAdding: .day, value: 2, to: mondayDate)!)
        thuday?.text = formatter1.string(from: Calendar.current.date(byAdding: .day, value: 3, to: mondayDate)!)
        friday?.text = formatter1.string(from: Calendar.current.date(byAdding: .day, value: 4, to: mondayDate)!)
        satday?.text = formatter1.string(from: Calendar.current.date(byAdding: .day, value: 5, to: mondayDate)!)
        
        
        dateString.append(formatter.string(from: Calendar.current.date(byAdding: .day, value: -1, to: mondayDate)!))
        dateString.append(formatter.string(from: mondayDate))
        dateString.append(formatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: mondayDate)!))
        dateString.append(formatter.string(from: Calendar.current.date(byAdding: .day, value: 2, to: mondayDate)!))
        dateString.append(formatter.string(from: Calendar.current.date(byAdding: .day, value: 3, to: mondayDate)!))
        dateString.append(formatter.string(from: Calendar.current.date(byAdding: .day, value: 4, to: mondayDate)!))
        dateString.append(formatter.string(from: Calendar.current.date(byAdding: .day, value: 5, to: mondayDate)!))
        
        dateString1.append(formatter2.string(from: Calendar.current.date(byAdding: .day, value: -1, to: mondayDate)!))
        dateString1.append(formatter2.string(from: mondayDate))
        dateString1.append(formatter2.string(from: Calendar.current.date(byAdding: .day, value: 1, to: mondayDate)!))
        dateString1.append(formatter2.string(from: Calendar.current.date(byAdding: .day, value: 2, to: mondayDate)!))
        dateString1.append(formatter2.string(from: Calendar.current.date(byAdding: .day, value: 3, to: mondayDate)!))
        dateString1.append(formatter2.string(from: Calendar.current.date(byAdding: .day, value: 4, to: mondayDate)!))
        dateString1.append(formatter2.string(from: Calendar.current.date(byAdding: .day, value: 5, to: mondayDate)!))
        
        //date color setting
        dateColor = UIColor.init(hex: "39d3e3")
        
        for index in 0 ..< dateViews!.count
        {
            let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(timeSelect(sender:)))
            dateViews![index].tag = index
            dateViews![index].layer.cornerRadius = 10
            dateViews![index].layer.masksToBounds = true
            dateViews![index].addGestureRecognizer(gesture2)
        }
        
        for vwIndicator in indictorVWArray {
            vwIndicator.backgroundColor = UIColor.clear
            vwIndicator.layer.cornerRadius = 2
        }
        
        showSelectedDate(index: index)
        currentTimeTag = index
        //tabbar tint color setting
        setTintColor()
    }
    
    func initNavBar() {
        
        navIVArray = [m_ivMorning, m_ivMidDay, m_ivEvening, m_ivNight]
        navVWArray = [m_vwMorning, m_vwMidDay, m_vwEvening, m_vwNight]
        navColorActiveArray = [colorMorningActive, colorMidDayActive, colorEveningActive, colorNightActive] as! [UIColor]
        addBtnImagePathArray = ["icon_add_more_morning", "icon_add_more_midday", "icon_add_more_evening", "icon_add_more_night"]
        topNavActiveArray = ["morn_on", "midday_on", "even_on", "night_on"]
        topNavDeactiveArray = ["morn_off", "midday_off", "even_off", "night_off"]
        
        selectNavItem(position: 0)
        navColorChange(value: 0)
    }

    func selectNavItem(position: Int) {
        
        for i in 0...3 {
        
            if (i != position) {
                navIVArray[i].tintColor = colorDeactive
                navIVArray[i].image = UIImage.init(named: topNavDeactiveArray[i])
            }
        }
        
        navIVArray[position].image = UIImage.init(named: topNavActiveArray[position])
        moveToViewController(at: position)
        
    }
    
    func setTintColor()
    {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        var currentDate1 = ""
        formatter.timeZone = TimeZone.current
        let locale = NSLocale.current
        let formatter1 : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
        if formatter1.contains("a") {
            
            //phone is set to 12 hours
            formatter.dateFormat = "h:mm a"
            let time1 = formatter.string(from: currentDateTime)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            let date = formatter.date(from: time1)
            formatter.dateFormat = "HH:mm"
            currentDate1 = formatter.string(from: date!)
 
            
        } else {
            //phone is set to 24 hours
            formatter.dateFormat = "HH:mm"
            currentDate1 = formatter.string(from: currentDateTime)
        }
        
        
        let hour = Int(currentDate1.components(separatedBy: ":")[0])!
        let min = Int(currentDate1.components(separatedBy: ":")[1])!
        
        
        var starttime = DataUtils.getTimeRange(index: 0)!.components(separatedBy: "-")[0]
        var endtime = DataUtils.getTimeRange(index: 0)!.components(separatedBy: "-")[1]
        var startH = Int(starttime.components(separatedBy: ":")[0])!
        var startM = Int(starttime.components(separatedBy: ":")[1])!
        var endH = Int(endtime.components(separatedBy: ":")[0])!
        var endM = Int(endtime.components(separatedBy: ":")[1])!
        if startH * 60 + startM <= hour * 60 + min && endH * 60 + endM > hour * 60 + min {
            //UITabBar.appearance().tintColor = UIColor.init(hex: "39d3e3")
            self.tabBarController?.tabBar.tintColor = UIColor.init(hex: "39d3e3")
        }
        
        starttime = DataUtils.getTimeRange(index: 1)!.components(separatedBy: "-")[0]
        endtime = DataUtils.getTimeRange(index: 1)!.components(separatedBy: "-")[1]
        startH = Int(starttime.components(separatedBy: ":")[0])!
        startM = Int(starttime.components(separatedBy: ":")[1])!
        endH = Int(endtime.components(separatedBy: ":")[0])!
        endM = Int(endtime.components(separatedBy: ":")[1])!
        if startH * 60 + startM <= hour * 60 + min && endH * 60 + endM > hour * 60 + min {
            //UITabBar.appearance().tintColor = UIColor.init(hex: "397ee3")
            self.tabBarController?.tabBar.tintColor = UIColor.init(hex: "397ee3")
        }
        
        starttime = DataUtils.getTimeRange(index: 2)!.components(separatedBy: "-")[0]
        endtime = DataUtils.getTimeRange(index: 2)!.components(separatedBy: "-")[1]
        startH = Int(starttime.components(separatedBy: ":")[0])!
        startM = Int(starttime.components(separatedBy: ":")[1])!
        endH = Int(endtime.components(separatedBy: ":")[0])!
        endM = Int(endtime.components(separatedBy: ":")[1])!
        if startH * 60 + startM <= hour * 60 + min && endH * 60 + endM > hour * 60 + min {
            //UITabBar.appearance().tintColor = UIColor.init(hex: "415ce3")
            self.tabBarController?.tabBar.tintColor = UIColor.init(hex: "415ce3")
        }
        
        starttime = DataUtils.getTimeRange(index: 3)!.components(separatedBy: "-")[0]
        endtime = DataUtils.getTimeRange(index: 3)!.components(separatedBy: "-")[1]
        startH = Int(starttime.components(separatedBy: ":")[0])!
        startM = Int(starttime.components(separatedBy: ":")[1])!
        endH = Int(endtime.components(separatedBy: ":")[0])!
        endM = Int(endtime.components(separatedBy: ":")[1])!
        if startH * 60 + startM <= hour * 60 + min && endH * 60 + endM > hour * 60 + min {
            //UITabBar.appearance().tintColor = UIColor.init(hex: "4939e3")
            self.tabBarController?.tabBar.tintColor = UIColor.init(hex: "4939e3")
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        setTintColor()
        
    }
    
    func getCurrentDayIndex(current:String) -> (Date,Int) {
        
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "yyyy-MM-dd"
        formatter2.timeZone = TimeZone.current
        
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "EEEE"
        formatter3.timeZone = TimeZone.current
        let str = formatter3.string(from: formatter2.date(from: current)!)
        
        
        
        if str == "Sunday"
        {
            let date = Calendar.current.date(byAdding: .day, value: 1, to: formatter2.date(from: current)!)!
            let datestr = formatter2.string(from: date)
            currentDayOfWeek = 0
            return (formatter2.date(from: datestr)!,0)
        }
        else if str == "Monday"
        {
            let date = Calendar.current.date(byAdding: .day, value: 0, to: formatter2.date(from: current)!)!
            let datestr = formatter2.string(from: date)
            currentDayOfWeek = 1
            return (formatter2.date(from: datestr)!,1)
        }
        else if str == "Tuesday"
        {
            let date = Calendar.current.date(byAdding: .day, value: -1, to: formatter2.date(from: current)!)!
            let datestr = formatter2.string(from: date)
            currentDayOfWeek = 2
            return (formatter2.date(from: datestr)!,2)
        }
        else if str == "Wednesday"
        {
            let date = Calendar.current.date(byAdding: .day, value: -2, to: formatter2.date(from: current)!)!
            let datestr = formatter2.string(from: date)
            currentDayOfWeek = 3
            return (formatter2.date(from: datestr)!,3)
        }
        else if str == "Thursday"
        {
            let date = Calendar.current.date(byAdding: .day, value: -3, to: formatter2.date(from: current)!)!
            let datestr = formatter2.string(from: date)
            currentDayOfWeek = 4
            return (formatter2.date(from: datestr)!,4)
        }
        else if str == "Friday"
        {
            let date = Calendar.current.date(byAdding: .day, value: -4, to: formatter2.date(from: current)!)!
            let datestr = formatter2.string(from: date)
            currentDayOfWeek = 5
            return (formatter2.date(from: datestr)!,5)
        }
        else
        {
            let date = Calendar.current.date(byAdding: .day, value: -5, to: formatter2.date(from: current)!)!
            let datestr = formatter2.string(from: date)
            currentDayOfWeek = 6
            return (formatter2.date(from: datestr)!,6)
        }
        
    }
    
    @objc func timeSelect(sender : UITapGestureRecognizer) {
        let tag = sender.view!.tag
        showSelectedDate(index: tag)
        currentTimeTag = tag
    }
    
    func showSelectedDate(index:Int) {
        
        for i in 0 ..< dateViews!.count
        {
            dateViews![i].backgroundColor = UIColor.clear//UIColor.init(hex: "f7f7fa")
            daylabels![i].textColor = UIColor.init(hex: "333333")
            datelabels![i].textColor = UIColor.init(hex: "333333")
            indictorVWArray[i].backgroundColor = UIColor.clear
        }
        
        dateViews![index].backgroundColor = dateColor//UIColor.init(hex: "39d3e3")
        indictorVWArray[index].backgroundColor = dateColor
        daylabels![index].textColor = UIColor.white
        if currentDayOfWeek == index
        {
            dayofWeek.setTitle("Today", for: .normal)
        }
        else
        {
            let days = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
            dayofWeek.setTitle(days[index], for: .normal)
        }
        
        datelabels![index].textColor = UIColor.white
        currentDate.text = dateString[index].uppercased()
        currentDateString = dateString1[index]
        switch selectedDay {
        case 0:
            child_1!.currentDate = dateString1[index]
            child_1!.selectDateChange()
        case 1:
            child_2!.currentDate = dateString1[index]
            child_2!.selectDateChange()
        case 2:
            child_3!.currentDate = dateString1[index]
            child_3!.selectDateChange()
        case 3:
            child_4!.currentDate = dateString1[index]
            child_4!.selectDateChange()
        default:
            break
        }
        pointLabel.textColor = dateColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        m_vwRadialLeft.layer.cornerRadius = m_vwRadialLeft.frame.width / 2
        m_vwRadialRight.layer.cornerRadius = m_vwRadialRight.frame.width / 2
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //print("Monday \(mondayDate)")
        
    }
    

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        child_1 = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "morningviewcontroller1") as? MorningViewController1
        child_1!.delegate = self
        
        child_2 = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "middayviewcontroller") as? MiddayViewController
        child_2!.delegate = self
        
        child_3 = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "eveningviewcontroller") as? EveningViewController
        child_3!.delegate = self
        
        child_4 = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "nightviewcontroller") as? NightViewController
        child_4!.delegate = self
        
        return [child_1!,child_2!,child_3!,child_4!]
        //return [child_2,child_3,child_4]
        
    }
    
    func barSettings()
    {
        buttonBarView.selectedBar.backgroundColor = UIColor.init(hex: "39d3e3")
        settings.style.buttonBarBackgroundColor = UIColor.init(hex: "ffffff")
        settings.style.buttonBarItemBackgroundColor = UIColor.clear//init(hex: "f7f7fa")
        settings.style.selectedBarBackgroundColor = UIColor.init(hex: "ffffff")
        settings.style.buttonBarItemFont = UIFont(name: "Montserrat-Medium", size: 18)!
        settings.style.selectedBarHeight = 0.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor.init(hex: "333333")
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        m_vwTopContainer.layer.cornerRadius = 15.0
        m_vwTopContainer.addShadow(color: #colorLiteral(red: 0.2384634067, green: 0.2384634067, blue: 0.2384634067, alpha: 1), alpha: 0.3, x: 0, y: 3, blur: 4.0)
        
        
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else {
                return }
            
            oldCell?.isSelected = false
            oldCell?.isHighlighted = false
            oldCell?.label.textColor = UIColor.init(hex: "333333").withAlphaComponent(0.5)
            
            self?.oldCell = oldCell
            //newCell?.label.textColor = UIColor.init(hex: "01A2DD")
            //oldCell?.imageView.image = oldCell?.imageView.image
            
            
            newCell?.isHighlighted = true
            newCell?.label.textColor = UIColor.init(hex: "39d3e3")
            
            self?.newCell = newCell
        }
        
        
    }
    
    func selectDay(value: Int) -> String{
        
        if newCell != nil && oldCell != nil {
            selectedDay = value
            switch value{
            case 0:
                
                self.newCell?.label.textColor = UIColor.init(hex: "39d3e3")
                self.newCell?.label.font = UIFont(name: "Montserrat-Medium", size: 20)
                self.oldCell?.label.font = UIFont(name: "Montserrat-Medium", size: 18)
                buttonBarView.selectedBar.backgroundColor = UIColor.init(hex: "39d3e3")
                //currentImage.image = UIImage(named: "Morning Icon")
                dateColor = UIColor.init(hex: "39d3e3")
            case 1:
                
                self.newCell?.label.textColor = UIColor.init(hex: "397ee3")
                self.newCell?.label.font = UIFont(name: "Montserrat-Medium", size: 20)
                self.oldCell?.label.font = UIFont(name: "Montserrat-Medium", size: 18)
                buttonBarView.selectedBar.backgroundColor = UIColor.init(hex: "397ee3")
                //currentImage.image = UIImage(named: "Midday Icon")
                dateColor = UIColor.init(hex: "397ee3")
            case 2:
                
                self.newCell?.label.textColor = UIColor.init(hex: "415ce3")
                self.newCell?.label.font = UIFont(name: "Montserrat-Medium", size: 20)
                self.oldCell?.label.font = UIFont(name: "Montserrat-Medium", size: 18)
                buttonBarView.selectedBar.backgroundColor = UIColor.init(hex: "415ce3")
                //currentImage.image = UIImage(named: "Evening Icon")
                dateColor = UIColor.init(hex: "415ce3")
            case 3:
                
                self.newCell?.label.textColor = UIColor.init(hex: "4939e3")
                self.newCell?.label.font = UIFont(name: "Montserrat-Medium", size: 20)
                self.oldCell?.label.font = UIFont(name: "Montserrat-Medium", size: 18)
                buttonBarView.selectedBar.backgroundColor = UIColor.init(hex: "4939e3")
                //currentImage.image = UIImage(named: "Night Icon")
                dateColor = UIColor.init(hex: "4939e3")
            default:
                break
            }
            showSelectedDate(index: currentTimeTag)
            return currentDateString
        }
        else
        {
            return currentDateString
        }
        
    }
    
    func navColorChange(value: Int) {
        
        m_vwRadialLeft.backgroundColor = navColorActiveArray[value]
        m_vwRadialRight.backgroundColor = navColorActiveArray[value]
        
        m_fabAdd.buttonImage = UIImage.init(named: addBtnImagePathArray[value])
        
    }
    
    @IBAction func dateShow(_ sender: Any) {
        dateShow = !dateShow
        showCalendar(bShow: dateShow)
    }
    
    func showCalendar (bShow: Bool) {
        
        if bShow == true
        {
            m_cnstTopContainerHeight.constant = 163
            m_vwSeperate.isHidden = false
            m_stvwCalender.isHidden = false
        }
        else{
            m_cnstTopContainerHeight.constant = 73
            m_vwSeperate.isHidden = true
            m_stvwCalender.isHidden = true
        }
    }
    
    @IBAction func tapNavMorning(_ sender: Any) {
        selectNavItem(position: 0)
    }
    
    @IBAction func tapNavMidDay(_ sender: Any) {
        selectNavItem(position: 1)
    }
    
    @IBAction func tapNavEvening(_ sender: Any) {
        selectNavItem(position: 2)
    }
    
    @IBAction func tapNavNight(_ sender: Any) {
        selectNavItem(position: 3)
    }
    @IBAction func addMedication(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstMedicationAddViewController") as! FirstMedicationAddViewController
        //viewController.tabBar.roundCorners([.topLeft, .topRight], radius: 10)
        let navController = UINavigationController(rootViewController: viewController)
        present(navController, animated: false, completion: nil)
    }
    
}


extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
