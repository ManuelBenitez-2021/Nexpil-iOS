//
//  CommunityMainViewController.swift
//  Nexpil
//
//  Created by Admin on 4/9/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import XLPagerTabStrip

import ASHorizontalScrollView

import Alamofire
import Kingfisher

protocol CommunitySubMenuDelegate {
    func selectDay(value:Int) -> (Int,Int)
}

class CommunityMainViewController: ButtonBarPagerTabStripViewController,CommunitySubMenuDelegate  {
    
    var startColor:UIColor?
    var endColor:UIColor?

    //let names = ["You","James W.","Dr. Smith","Jess W","Hust Wilson","Lau Keith"]
    //let photos = ["you.png","james.png","smith.png","jess.png","hust.png","lau.png"]
    var communityusers:[CommunityUser] = []
    
    var photoProfiles:[ProfilePhoto] = []
    
    @IBOutlet weak var userPhotosView: ASHorizontalScrollView!
    var selectedUser:Int = 0
    var viewSelect = 0
    var oldCell:ButtonBarViewCell?
    var newCell:ButtonBarViewCell?
    
    var child_1:FeedViewController?
    var child_2:NotificationsViewController?
    
    var userAddProfilePhoto:ProfilePhoto?
    var youImage:ProfilePhoto?
    var addState = false
    
    
    @IBOutlet weak var addViewHeight: NSLayoutConstraint!
    @IBOutlet weak var userAddbtn: GradientView!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var enterCodeViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var pointLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setColorSettings()
        // Do any additional setup after loading the view.
        containerView.isScrollEnabled = false
        barSettings()
        userPhotosView.defaultMarginSettings = MarginSettings(leftMargin: 5, miniMarginBetweenItems: 5, miniAppearWidthOfLastItem: 20)
        self.buttonBarView.backgroundColor = nil
        
        userAddbtn.topColor = UIColor.init(hex: DataUtils.getStartColor()!)
        userAddbtn.bottomColor = UIColor.init(hex: DataUtils.getEndColor()!)
        self.hideKeyboardWhenTappedAround()
        
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.addUser))
        userAddbtn.addGestureRecognizer(gesture2)
        getCommunityUsersFromBackend()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /*
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        */
        guard let _ = youImage else { return}
        if PreferenceHelper().getUserImage()! == ""
        {
            youImage!.photoImage.image = UIImage(named: "Intersection 1")
        }
        else {
            let url = URL(string: DataUtils.PROFILEURL + PreferenceHelper().getUserImage()!)
            youImage!.photoImage.kf.setImage(with: url)
        }
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                
                
                self.view.frame.origin.y -= 200
                
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 200
            }
        }
    }
    
    @objc func addUser(sender : UITapGestureRecognizer) {
        
        if codeTextField.text == "" {
            DataUtils.messageShow(view: self, message: "Please enter code", title: "")
            return
        }
        codeTextField.resignFirstResponder()
        
        let params = [
            "userid" : PreferenceHelper().getId(),
            "choice" : "2",
            "usercode" : codeTextField.text!
            ] as [String : Any]
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        Alamofire.request(DataUtils.APIURL + DataUtils.COMMUNITYUSERS_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                let user = PreferenceHelper()
                self.communityusers.append(CommunityUser.init(userid: user.getId(), firstname: user.getFirstName()!, lastname: user.getLastName()!, userimage: user.getUserImage()!))
                debugPrint(response);
                
                if let data = response.result.value {
                    print("JSON: \(data)")
                    let json : [String:Any] = data as! [String : Any]
                    
                    let result = json["status"] as? String
                    if result == "true"
                    {
                        let users = json["data"] as? [[String:Any]]
                        for user in users!
                        {
                            let communityuser = CommunityUser.init(json: user)
                            self.communityusers.append(communityuser)
                        }
                        //self.getCommunityUsers()
                        self.communityUserAdd()
                    }
                    else {
                        let message = json["message"] as! String
                        DataUtils.messageShow(view: self, message: message, title: "")
                    }
                }
            })
        
    }
    
    func selectDay(value: Int) -> (Int,Int){
        viewSelect = value
        switch value{
        case 0:
            
            self.newCell?.label.textColor = endColor//UIColor.init(hex: "4939e3")
            self.newCell?.label.font = UIFont(name: "Montserrat-Medium", size: 20)
            self.oldCell?.label.font = UIFont(name: "Montserrat-Medium", size: 18)
            buttonBarView.selectedBar.backgroundColor = endColor//UIColor.init(hex: "4939e3")
        case 1:
            
            self.newCell?.label.textColor = endColor//UIColor.init(hex: "4939e3")
            self.newCell?.label.font = UIFont(name: "Montserrat-Medium", size: 20)
            self.oldCell?.label.font = UIFont(name: "Montserrat-Medium", size: 18)
            buttonBarView.selectedBar.backgroundColor = endColor//UIColor.init(hex: "4939e3")
        default:
            break
        }
        var userid = 0
        if communityusers.count == 0
        {
            userid = PreferenceHelper().getId()
        }
        else {
            userid = communityusers[selectedUser].userid
        }
        return (selectedUser,userid)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getCommunityUsersFromBackend() {
    //override func viewDidAppear(_ animated: Bool) {
        
        addViewHeight.constant = 0
        enterCodeViewHeight.constant = 0
        
        //setColorSettings()
        pointLabel.textColor = endColor
        communityusers = []
        let params = [
            "userid" : PreferenceHelper().getId(),
            "choice" : "0"
            ] as [String : Any]
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        Alamofire.request(DataUtils.APIURL + DataUtils.COMMUNITYUSERS_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                let user = PreferenceHelper()
                self.communityusers.append(CommunityUser.init(userid: user.getId(), firstname: user.getFirstName()!, lastname: user.getLastName()!, userimage: user.getUserImage()!))
                debugPrint(response);
                
                if let data = response.result.value {
                    print("JSON: \(data)")
                    let json : [String:Any] = data as! [String : Any]
                    
                    let result = json["status"] as? String
                    if result == "true"
                    {
                        let users = json["data"] as? [[String:Any]]
                        for user in users!
                        {
                            let communityuser = CommunityUser.init(json: user)
                            self.communityusers.append(communityuser)
                            
                        }
                        
                    }
                    self.getCommunityUsers()
                    self.child_1?.communityUsers = self.communityusers
                    //self.getCommunityUsers()
                }
            })
    }
    
    func communityUserAdd()
    {
        addViewHeight.constant = 0
        enterCodeViewHeight.constant = 0
        
        let photoProfile = ProfilePhoto.init(frame: CGRect(x: 0 , y: 0, width: 110, height: 110))
        //photoProfile.frame = CGRect.init(x: 0, y: 0, width: 110, height: 110)
        var image: UIImage?
        if communityusers[communityusers.count - 1].userimage == ""
        {
            image = UIImage(named: "Intersection 1")
            photoProfile.photoImage.image = image
            photoProfile.photoImage.contentMode = .bottom
        }
        else
        {
            let url = URL(string: DataUtils.PROFILEURL + communityusers[communityusers.count - 1].userimage)
            photoProfile.photoImage.kf.setImage(with: url)
        }
        
        photoProfile.photoImage.layer.masksToBounds = false
        photoProfile.photoImage.layer.borderWidth = 0.0
        photoProfile.photoImage.layer.borderColor = endColor?.cgColor//UIColor.init(hex: "4939e3").cgColor
        //photoProfile.photoImage.contentMode = .scaleToFill
        
        photoProfile.photoImage.layer.cornerRadius =  photoProfile.photoImage.frame.size.height/2
        
        photoProfile.photoImage.clipsToBounds = true
        photoProfile.userName.text = communityusers[communityusers.count - 1].firstname + " " + communityusers[communityusers.count - 1].lastname.prefix(1).uppercased() + "." //names[i]
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(gesture:)))
        photoProfile.photoImage.tag = communityusers.count - 1
        
        photoProfile.photoImage.addGestureRecognizer(tapGesture)
        photoProfile.photoImage.isUserInteractionEnabled = true       
        
        userPhotosView.addItem(photoProfile)
        photoProfiles.append(photoProfile)
        
    }
    
    func getCommunityUsers() {
        userPhotosView.setItemsMarginOnce()
        userPhotosView.removeAllItems()
        photoProfiles.removeAll()
        
        addViewHeight.constant = 0
        enterCodeViewHeight.constant = 0
        
        userAddProfilePhoto = ProfilePhoto.init(frame: CGRect(x: 0 , y: 0, width: 110, height: 110))
        //photoProfile.frame = CGRect.init(x: 0, y: 0, width: 110, height: 110)
        userAddProfilePhoto!.userName.text = "Add"//names[i]
        //let image: UIImage = UIImage(named: photos[i])!
        //photoProfile.photoImage.image = image
        userAddProfilePhoto!.photoImage.image = UIImage(named: "Union 55")
        userAddProfilePhoto!.photoImage.layer.masksToBounds = false
        userAddProfilePhoto!.photoImage.layer.borderWidth = 0.0
        //photoProfile.photoImage.layer.borderColor = endColor?.cgColor
        userAddProfilePhoto!.photoImage.layer.cornerRadius =  userAddProfilePhoto!.photoImage.frame.size.width/2
        //photoProfile.photoImage.layer.borderWidth = 5.0
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(self.addCommunityMember(gesture:)))
        userAddProfilePhoto!.photoImage.tag = communityusers.count
        userAddProfilePhoto!.photoImage.addGestureRecognizer(tapGesture1)
        userAddProfilePhoto!.photoImage.isUserInteractionEnabled = true
        
        userPhotosView.addItem(userAddProfilePhoto!)
        //photoProfiles.append(photoProfile)
        
        for i in 0 ..< communityusers.count
        {
            //if let photoProfile = Bundle.main.loadNibNamed("PhotoProfile", owner: self, options: nil)?.first as? PhotoProfile {
            let photoProfile = ProfilePhoto.init(frame: CGRect(x: 0 , y: 0, width: 110, height: 110))
            //photoProfile.frame = CGRect.init(x: 0, y: 0, width: 110, height: 110)
            if i == 0
            {
                photoProfile.userName.text = "You"
                
            }
            else
            {
                photoProfile.userName.text = communityusers[i].firstname + " " + communityusers[i].lastname.prefix(1).uppercased() + "." //names[i]
                
            }
            
            var image: UIImage?
            if communityusers[i].userimage == ""
            {
                image = UIImage(named: "Intersection 1")
                photoProfile.photoImage.image = image
                photoProfile.photoImage.contentMode = .bottom
            }
            else
            {
                let url = URL(string: DataUtils.PROFILEURL + communityusers[i].userimage)
                photoProfile.photoImage.kf.setImage(with: url)
            }
            
            photoProfile.photoImage.layer.masksToBounds = false
            photoProfile.photoImage.layer.borderWidth = 0.0
            photoProfile.photoImage.layer.borderColor = endColor?.cgColor//UIColor.init(hex: "4939e3").cgColor
            //photoProfile.photoImage.contentMode = .scaleToFill
            
            photoProfile.photoImage.layer.cornerRadius =  photoProfile.photoImage.frame.size.height/2
            
            photoProfile.photoImage.clipsToBounds = true
            
            
            if selectedUser == i
            {
                photoProfile.photoImage.layer.borderWidth = 5.0
            }
            
            //            photoProfile.photoImage.layer.cornerRadius =  photoProfile.photoImage.frame.size.width/2
            //            let calayer = CALayer()
            //            if selectedUser == i
            //            {
            //
            //                calayer.addGradienBorder(colors: [startColor!,endColor!], width: 5.0)
            //                photoProfile.photoImage.layer.addSublayer(calayer)
            //            }
            //            else
            //            {
            //
            //                calayer.addGradienBorder(colors: [startColor!,endColor!], width: 0.0)
            //                photoProfile.photoImage.layer.addSublayer(calayer)
            //            }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(gesture:)))
            photoProfile.photoImage.tag = i
            
            photoProfile.photoImage.addGestureRecognizer(tapGesture)
            photoProfile.photoImage.isUserInteractionEnabled = true
            
            if i == 0
            {
                youImage = photoProfile
            }
            
            userPhotosView.addItem(photoProfile)
            photoProfiles.append(photoProfile)
            
        }
    }
    
    func setBorderGradient(image: UIImageView,borderWidth:CGFloat) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: image.frame.size)
        gradient.colors = [startColor!.cgColor, endColor!.cgColor]
        
        let shape = CAShapeLayer()
        shape.lineWidth = borderWidth
        shape.path = UIBezierPath(rect: image.bounds).cgPath//UIBezierPath(roundedRect: image.bounds, cornerRadius: image.frame.size.height/2).cgPath
        //shape.strokeColor = UIColor.black.cgColor
        //shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        return gradient
    }
    
    func setColorSettings()
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
        
        startColor = UIColor.init(hex: "7ce2ec")
        endColor = UIColor.init(hex: "39d3e3")
        
        if startH * 60 + startM <= hour * 60 + min && endH * 60 + endM > hour * 60 + min {
            //UITabBar.appearance().tintColor = UIColor.init(hex: "39d3e3")
            //self.tabBarController?.tabBar.tintColor = UIColor.init(hex: "39d3e3")
            startColor = UIColor.init(hex: "7ce2ec")
            endColor = UIColor.init(hex: "39d3e3")
            //return
        }
        
        starttime = DataUtils.getTimeRange(index: 1)!.components(separatedBy: "-")[0]
        endtime = DataUtils.getTimeRange(index: 1)!.components(separatedBy: "-")[1]
        startH = Int(starttime.components(separatedBy: ":")[0])!
        startM = Int(starttime.components(separatedBy: ":")[1])!
        endH = Int(endtime.components(separatedBy: ":")[0])!
        endM = Int(endtime.components(separatedBy: ":")[1])!
        if startH * 60 + startM <= hour * 60 + min && endH * 60 + endM > hour * 60 + min {
            //UITabBar.appearance().tintColor = UIColor.init(hex: "397ee3")
            //self.tabBarController?.tabBar.tintColor = UIColor.init(hex: "397ee3")
            startColor = UIColor.init(hex: "7caaec")
            endColor = UIColor.init(hex: "397ee3")
            //return
        }
        
        starttime = DataUtils.getTimeRange(index: 2)!.components(separatedBy: "-")[0]
        endtime = DataUtils.getTimeRange(index: 2)!.components(separatedBy: "-")[1]
        startH = Int(starttime.components(separatedBy: ":")[0])!
        startM = Int(starttime.components(separatedBy: ":")[1])!
        endH = Int(endtime.components(separatedBy: ":")[0])!
        endM = Int(endtime.components(separatedBy: ":")[1])!
        if startH * 60 + startM <= hour * 60 + min && endH * 60 + endM > hour * 60 + min {
            //UITabBar.appearance().tintColor = UIColor.init(hex: "415ce3")
            //self.tabBarController?.tabBar.tintColor = UIColor.init(hex: "415ce3")
            startColor = UIColor.init(hex: "8495ed")
            endColor = UIColor.init(hex: "415ce3")
            //return
        }
        
        starttime = DataUtils.getTimeRange(index: 3)!.components(separatedBy: "-")[0]
        endtime = DataUtils.getTimeRange(index: 3)!.components(separatedBy: "-")[1]
        startH = Int(starttime.components(separatedBy: ":")[0])!
        startM = Int(starttime.components(separatedBy: ":")[1])!
        endH = Int(endtime.components(separatedBy: ":")[0])!
        endM = Int(endtime.components(separatedBy: ":")[1])!
        if startH * 60 + startM <= hour * 60 + min && endH * 60 + endM > hour * 60 + min {
            //UITabBar.appearance().tintColor = UIColor.init(hex: "4939e3")
            //self.tabBarController?.tabBar.tintColor = UIColor.init(hex: "4939e3")
            startColor = UIColor.init(hex: "877cec")
            endColor = UIColor.init(hex: "4939e3")
            //return
        }
        DataUtils.setStartColor(name: startColor!.toHex()!)
        DataUtils.setEndColor(name: endColor!.toHex()!)
    }
    
    func showShareScreen()
    {
        let params = [
            "userid" : PreferenceHelper().getId(),
            "choice" : "4"
            
            ] as [String : Any]
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        Alamofire.request(DataUtils.APIURL + DataUtils.COMMUNITYUSERS_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                
                debugPrint(response);
                
                if let data = response.result.value {
                    print("JSON: \(data)")
                    let json : [String:Any] = data as! [String : Any]
                    //let statusMsg: String = json["status_msg"] as! String
                    //self.showResultMessage(statusMsg)
                    //self.showGraph(json)
                    let result = json["status"] as? String
                    if result == "true"
                    {
                        let usercode = json["usercode"] as? String
                        //DataUtils.messageShow(view: self, message: usercode!, title: "")
                        let shareText = "My code is " + usercode!
                        let activityViewController = UIActivityViewController(activityItems: [shareText] , applicationActivities: nil)
                        activityViewController.popoverPresentationController?.sourceView = self.view
                        self.present(activityViewController, animated: true, completion: nil)
                    }
                    else
                    {
                        let message = json["message"] as! String
                        DataUtils.messageShow(view: self, message: message, title: "")
                    }
                }
            })
    }
    
    @objc func addCommunityMember(gesture: UIGestureRecognizer) {
        
        if addState == false
        {
            addViewHeight.constant = 0
            enterCodeViewHeight.constant = 0
            userAddProfilePhoto!.userName.text = "Add"//names[i]
            //let image: UIImage = UIImage(named: photos[i])!
            //photoProfile.photoImage.image = image
            userAddProfilePhoto!.photoImage.image = UIImage(named: "Union 55")
            userAddProfilePhoto!.photoImage.layer.masksToBounds = false
            userAddProfilePhoto!.photoImage.layer.borderWidth = 0.0
            //photoProfile.photoImage.layer.borderColor = endColor?.cgColor
            userAddProfilePhoto!.photoImage.layer.cornerRadius =  userAddProfilePhoto!.photoImage.frame.size.width/2
            //photoProfile.photoImage.layer.borderWidth = 5.0
        }
        else {
            addViewHeight.constant = 168
            enterCodeViewHeight.constant = 64
            userAddProfilePhoto!.userName.text = "Cancel"//names[i]
            //let image: UIImage = UIImage(named: photos[i])!
            //photoProfile.photoImage.image = image
            userAddProfilePhoto!.photoImage.image = UIImage(named: "add_close")
            userAddProfilePhoto!.photoImage.layer.masksToBounds = false
            userAddProfilePhoto!.photoImage.layer.borderWidth = 0.0
            //photoProfile.photoImage.layer.borderColor = endColor?.cgColor
            userAddProfilePhoto!.photoImage.layer.cornerRadius =  userAddProfilePhoto!.photoImage.frame.size.width/2
            //photoProfile.photoImage.layer.borderWidth = 5.0
            
            showShareScreen()
        }
        addState = !addState
    }
    @objc func tapGesture(gesture: UIGestureRecognizer) {
        let view = gesture.view
        let index = view!.tag
        
        if index == selectedUser
        {
            return
        }
        else{
            selectedUser = index
        }
        for (i,obj) in photoProfiles.enumerated()
        {
            if i == index
            {
                
                obj.photoImage.layer.borderWidth = 5.0
            }
            else
            {
                obj.photoImage.layer.borderWidth = 0.0
            }
        }
        
        self.changeContent()
    }
    
    func changeContent()
    {
        if viewSelect == 0
        {
            child_1?.selectedUser = self.selectedUser
            child_1?.selectedUserid = communityusers[selectedUser].userid
            child_1?.communityUsers = self.communityusers
            child_1?.showData()
        }
        else{
            child_2?.selectedUser = self.selectedUser
            child_2?.selectedUserid = communityusers[selectedUser].userid
            child_2?.showData()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        child_1 = (UIStoryboard(name: "Community", bundle: nil).instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController)
        child_1!.delegate = self
        
        child_2 = (UIStoryboard(name: "Community", bundle: nil).instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController)
        child_2!.delegate = self
        return [child_1!, child_2!]
    }
    
    func barSettings()
    {
        buttonBarView.setBorder()
        buttonBarView.selectedBar.backgroundColor = endColor//UIColor.init(hex: "4939e3")
        settings.style.buttonBarBackgroundColor = endColor//UIColor.init(hex: "4939e3")
        settings.style.buttonBarItemBackgroundColor = UIColor.clear//UIColor.init(hex: "f7f7fa")
        settings.style.selectedBarBackgroundColor = UIColor.init(hex: "5344e4")
        
        settings.style.buttonBarItemFont = UIFont(name: "Montserrat-Medium", size: 18)!
        settings.style.selectedBarHeight = 0.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor.init(hex: "333333").withAlphaComponent(0.5)
        settings.style.selectedBarHeight = 2.0
        
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else {
                return }
            oldCell?.label.textColor = UIColor.init(hex: "333333").withAlphaComponent(0.5)
            newCell?.label.textColor = self?.endColor!//UIColor.init(hex: "4939e3")
            
            oldCell?.isSelected = false
            oldCell?.isHighlighted = false
            oldCell?.label.textColor = UIColor.init(hex: "333333").withAlphaComponent(0.5)
            self?.oldCell = oldCell
            //newCell?.label.textColor = UIColor.init(hex: "01A2DD")
            //oldCell?.imageView.image = oldCell?.imageView.image
            newCell?.isHighlighted = true
            newCell?.label.textColor = self?.endColor!//UIColor.init(hex: "4939e3")
            self?.newCell = newCell
            
        }
    }
}

