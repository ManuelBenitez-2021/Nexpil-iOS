//
//  ProfileViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/08/20.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire
import ALCameraViewController

let items = 8

let arrayCard : [NSDictionary] = [
    ["memberName": "Oliva Wilson",
     "memberId": "xyz123456789",
     "groupNumber": "123456",
     "bin": "987654",
     "benifitPlan": "HIOPT",
     "effectiveDate": "12/12/18",
     "plan": "PPO",
     "officeVisit": "$15",
     "specialistCopay": "$15",
     "emergency": "$75",
     "deductible": "$50",
     ],
]

let arrayMedication: [NSDictionary] = [
    ["name": "Acetaminophen"],
    ["name": "Calcitriil"],
    ["name": "Calcium Carbonate"],
    ["name": "Ciprofloxacin"],
    ["name": "Ferrous Fumaarate"],
    ["name": "Furosemide",],
    ["name": "Glipizide"],
    ["name": "Metformin"],
    ["name": "Metoprolol"],
    ["name": "Ramipril"],
    ["name": "Simvasatin"]
]

//let arrayMedication: [NSDictionary] = []

//let arrayCondition : [NSDictionary] = [
//    ["title": "High Blood Pressure"],
//    ["title": "High Cholesterol"],
//    ["title": "Osteoartheritis"],
//    ["title": "Type 2 Diabetes"]
//]
var arrayCondition = [NSDictionary]()

//let arrayCondition : [NSDictionary] = []

let arrayDoctor : [NSDictionary] = [
    ["name": "Dr. Julie Smith", "phone": "(827) 484-1919", "image": "james"],
    ["name": "Dr. Robert Phillip", "phone": "(874) 884-9020", "image": "jess"],
    ["name": "Dr. Tonia Birch", "phone": "(708) 409-0000", "image": "lau"]
]

//let arrayDoctor : [NSDictionary] = [
//    ["name": "Dr. Julie Smith", "phone": "(827) 484-1919", "image": "james"]
//]

let arrayPharmacy : [NSDictionary] = [
    ["name": "CVS Pharmacy", "phone": "(312) 970-2881", "image": "icon_cvs"],
    ["name": "Walgreens", "phone": "(312) 973-3708", "image": "icon_walgreen"]
]

var arrayCommunity: [NSDictionary] = [
    ["name": "James Wilson", "image": "james"],
    ["name": "Jess Wilson", "image": "jess"],
    ["name": "Dr. Julie Smith", "image": "smith"],
    ["name": "Dr. Robert Phillip", "image": "hust"],
    ["name": "Dr. Tonia Birch", "image": "lau"]
]

let arraySchedule : [NSDictionary] = [
    ["title": "Morning", "timeStart": "5:00am", "timeEnd": "12:00pm", "image": "Morning Icon"],
    ["title": "Midday", "timeStart": "12:00pm", "timeEnd": "5:00pm", "image": "Midday Icon"],
    ["title": "Evening", "timeStart": "5:00pm", "timeEnd": "8:00pm", "image": "Evening Icon"],
    ["title": "Night", "timeStart": "8:00pm", "timeEnd": "12:00am", "image": "Night Icon"]
]

let arrayApp : [NSDictionary] = [
    ["name": "Alexa", "image": "icon_alexa"],
    ["name": "Fitbit", "image": "icon_fitbit"],
    ["name": "Health", "image": "icon_health"]
]

let menus = ["Insurance Cards","Medications","Health Conditions","Doctors","Pharmacies","Community","Schedules","Apps",""]

class ProfileViewController:
    UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    ProfileModelViewDelegate,
    ProfileConditionDetailModalViewDelegate,
    ProfileAddConditionModalViewDelegate,
    ProfileDoctorDetailModalViewDelegate,
    ProfilePharmacyDetailModalViewDelegate,
    ProfileCommunityDetailModalViewDelegate,
    ProfileAddCommunityModalViewDelegate,
    ProfileScheduleDetailModalViewDelegate,
    ProfileAddAppModalViewDelegate,
    ProfilePersonDetailModalViewDelegate,
    ProfileAddCardModalViewDelegate,
    ProfileSettingModalViewDelegate,
    SettingTermModalViewDelegate,
    SettingSnoozeModalViewDelegate,
    SettingPasswordModalViewDelegate
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblMemberSince: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var m_vwRadialRight: UIView!
    @IBOutlet weak var m_vwRadialLeft: UIView!
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var tableList: UITableView!
    @IBOutlet weak var settingFAB: FAButton!
    
    var window = UIWindow()
    var bgView = UIView()
    var visualEffectView:UIVisualEffectView = UIVisualEffectView()
    var selectIndex: Int = 0
    
    var popModalView: ProfileModelView = ProfileModelView()
    var popConditionDetailView: ProfileConditionDetailModalView = ProfileConditionDetailModalView()
    var popAddConditionView: ProfileAddConditionModalView = ProfileAddConditionModalView()
    var popDoctorDetailView: ProfileDoctorDetailModalView = ProfileDoctorDetailModalView()
    var popPharmacyDetailView: ProfilePharmacyDetailModalView = ProfilePharmacyDetailModalView()
    var popCommunityDetailView: ProfileCommunityDetailModalView = ProfileCommunityDetailModalView()
    var popAddCommunityView: ProfileAddCommunityModalView = ProfileAddCommunityModalView()
    var popScheduleDetailView: ProfileScheduleDetailModalView = ProfileScheduleDetailModalView()
    var popAddAppView: ProfileAddAppModalView = ProfileAddAppModalView()
    var popPersonDetailView: ProfilePersonDetailModalView = ProfilePersonDetailModalView()
    var popVerifyCardView: ProfileAddCardModalView = ProfileAddCardModalView()
    var popSettingView: ProfileSettingModalView = ProfileSettingModalView()
    var popSettingTermView: SettingTermModalView = SettingTermModalView()
    var popSettingSnoozeView: SettingSnoozeModalView = SettingSnoozeModalView()
    var popSettingPasswordView: SettingPasswordModalView = SettingPasswordModalView()
    
    var manager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.getAllData()
        self.initMainView()
        self.getSelfData()

        profileView.setPopItemViewStyle(radius: 15.0, title: PShadowType.large)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = m_vwRadialLeft.bounds
        gradientLayer.colors = NPColorScheme(rawValue: 2)!.gradient
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.cornerRadius = m_vwRadialLeft.frame.height / 2
        m_vwRadialLeft.layer.addSublayer(gradientLayer)
        
        let gradientLayer1 = CAGradientLayer()
        gradientLayer1.frame = m_vwRadialRight.bounds
        gradientLayer1.colors = NPColorScheme(rawValue: 2)!.gradient
        gradientLayer1.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer1.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer1.cornerRadius = m_vwRadialRight.frame.height / 2
        m_vwRadialRight.layer.addSublayer(gradientLayer1)
        
//        imageView.setPopItemViewStyle(title: PShadowType.small)
//        imageView.layer.cornerRadius = 30.0
        imageView.setPopItemViewStyle(radius: 30.0, title: .large)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualEffectView.alpha = 0.0
        view.addSubview(visualEffectView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileViewTapped(tapGestureRecognizer:)))
        profileView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func profileViewTapped(tapGestureRecognizer gesture: UITapGestureRecognizer) {
        visualEffectView.alpha = 0.96
        
        mTabView.isHidden = true
        settingFAB.isHidden = true
        self.addPersonDetailPopView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        m_vwRadialLeft.layer.cornerRadius = m_vwRadialLeft.frame.width / 2
        m_vwRadialRight.layer.cornerRadius = m_vwRadialRight.frame.width / 2
        imgProfile.layer.cornerRadius = imgProfile.frame.width / 2
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    


    func initMainView() {
        imgProfile.layer.masksToBounds = true
        imgProfile.layer.cornerRadius = imgProfile.frame.width / 2

        lblMemberSince.font         = UIFont(name: "Montserrat", size: 19)!
        lblMemberSince.textColor    = UIColor.init(hex: "333333")
    }

    func  getSelfData() {
        let preference = PreferenceHelper()
        
        if preference.getUserImage()! == ""
        {
            let image = UIImage(named: "Intersection 1")
            imgProfile.image = image
            imgProfile.contentMode = .bottom
        }
        else
        {
            let url = URL(string: DataUtils.PROFILEURL + preference.getUserImage()!)
            imgProfile.kf.setImage(with: url)
        }
        
        let strCreatedAt = preference.getCreatedAt()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        //formatter.timeZone = TimeZone.autoupdatingCurrent
        
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "MMMM d, yyyy"
        //formatter1.timeZone = TimeZone.current
        let date = formatter.date(from: strCreatedAt!)
        let strDate = formatter1.string(from: date!)
        
        lblMemberSince.text = preference.getFirstName()! + " " + preference.getLastName()!
        lblDate.text = "Member Since: " + strDate
    }
    
    func addPersonDetailPopView() {
        popPersonDetailView = Bundle.main.loadNibNamed("ProfilePersonDetailModalView", owner: self, options: nil)?.first as! ProfilePersonDetailModalView
        popPersonDetailView.delegate = self
        popPersonDetailView.frame = self.view.frame
        
        self.view.addSubview(popPersonDetailView)
    }
    
    func addComonPopView(index value: Int) {
        popModalView = Bundle.main.loadNibNamed("ProfileModelView", owner: self, options: nil)?.first as! ProfileModelView
        popModalView.delegate = self
        popModalView.frame = self.view.frame
        popModalView.titleUL.text = menus[value]
//        popModalView.addUB.setTitle("Add " + menus[value], for: .normal)
        self.view.addSubview(popModalView)
    }
    
    func addConditionDetailPopView(index value: Int) {
        popConditionDetailView = Bundle.main.loadNibNamed("ProfileConditionDetailModalView", owner: self, options: nil)?.first as! ProfileConditionDetailModalView
        popConditionDetailView.delegate = self
        popConditionDetailView.frame = self.view.frame
        popConditionDetailView.titleUL.text = arrayCondition[value].value(forKey: "title") as? String

        self.view.addSubview(popConditionDetailView)
    }
    
    func addAddConditionPopView() {
        popAddConditionView = Bundle.main.loadNibNamed("ProfileAddConditionModalView", owner: self, options: nil)?.first as! ProfileAddConditionModalView
        popAddConditionView.delegate = self
        popAddConditionView.frame = self.view.frame
        if selectIndex == 4 {
            popAddConditionView.titleUL.text = "Pharmacy"
            popAddConditionView.searchUTF.placeholder = "Search Pharamcy"
//            popAddConditionView.addUB.titleLabel?.text = "Add Pharmacy"
        }
        
        self.view.addSubview(popAddConditionView)
    }
    
    func addDoctorDetailPopView(index value: Int) {
        popDoctorDetailView = Bundle.main.loadNibNamed("ProfileDoctorDetailModalView", owner: self, options: nil)?.first as! ProfileDoctorDetailModalView
        popDoctorDetailView.delegate = self
        popDoctorDetailView.frame = self.view.frame
        popDoctorDetailView.titleUL.text = arrayDoctor[value].value(forKey: "name") as? String
        popDoctorDetailView.nameTF.text = arrayDoctor[value].value(forKey: "name") as? String
        popDoctorDetailView.phoneTF.text = arrayDoctor[value].value(forKey: "phone") as? String
        popDoctorDetailView.avatarUIV.image = UIImage(named: (arrayDoctor[value].value(forKey: "image") as? String)!)
//        popDoctorDetailView.addressUL.text = arrayDoctor[value].value(forKey: "name") as? String
        
        self.view.addSubview(popDoctorDetailView)
    }
    
    func addPharmacyDetailPopView(index value: Int) {
        popPharmacyDetailView = Bundle.main.loadNibNamed("ProfilePharmacyDetailModalView", owner: self, options: nil)?.first as! ProfilePharmacyDetailModalView
        popPharmacyDetailView.delegate = self
        popPharmacyDetailView.frame = self.view.frame
        
        self.view.addSubview(popPharmacyDetailView)
    }
    
    func addCommunityDetailPopView(index value: Int) {
        popCommunityDetailView = Bundle.main.loadNibNamed("ProfileCommunityDetailModalView", owner: self, options: nil)?.first as! ProfileCommunityDetailModalView
        popCommunityDetailView.delegate = self
        popCommunityDetailView.frame = self.view.frame
        
        popCommunityDetailView.titleUL.text = arrayCommunity[value].value(forKey: "name") as? String
        popCommunityDetailView.avatarUIV.image = UIImage(named: (arrayCommunity[value].value(forKey: "image") as? String)!)
        
        self.view.addSubview(popCommunityDetailView)
    }
    
    func addAddCommunityPopView() {
        popAddCommunityView = Bundle.main.loadNibNamed("ProfileAddCommunityModalView", owner: self, options: nil)?.first as! ProfileAddCommunityModalView
        popAddCommunityView.delegate = self
        popAddCommunityView.frame = self.view.frame
        
        self.view.addSubview(popAddCommunityView)
    }
    
    func addScheduleDetailPopView(index value: Int) {
        popScheduleDetailView = Bundle.main.loadNibNamed("ProfileScheduleDetailModalView", owner: self, options: nil)?.first as! ProfileScheduleDetailModalView
        popScheduleDetailView.delegate = self
        popScheduleDetailView.frame = self.view.frame
        popScheduleDetailView.titleUL.text = arraySchedule[value].value(forKey: "title") as? String
        
        self.view.addSubview(popScheduleDetailView)
    }
    
    func addAddAppPopView() {
        popAddAppView = Bundle.main.loadNibNamed("ProfileAddAppModalView", owner: self, options: nil)?.first as! ProfileAddAppModalView
        popAddAppView.delegate = self
        popAddAppView.frame = self.view.frame
        
        self.view.addSubview(popAddAppView)
    }
    
    func addVerifyCardPopView() {
        popVerifyCardView = Bundle.main.loadNibNamed("ProfileAddCardModalView", owner: self, options: nil)?.first as! ProfileAddCardModalView
        popVerifyCardView.delegate = self
        popVerifyCardView.frame = self.view.frame
        
        self.view.addSubview(popVerifyCardView)
    }
    
    func addSettingPopView() {
        popSettingView = Bundle.main.loadNibNamed("ProfileSettingModalView", owner: self, options: nil)?.first as! ProfileSettingModalView
        popSettingView.delegate = self
        popSettingView.frame = self.view.frame
        
        self.view.addSubview(popSettingView)
    }
    
    func addSettingTermPopView() {
        popSettingTermView = Bundle.main.loadNibNamed("SettingTermModalView", owner: self, options: nil)?.first as! SettingTermModalView
        popSettingTermView.delegate = self
        popSettingTermView.frame = self.view.frame
        
        self.view.addSubview(popSettingTermView)
    }
    
    func addSettingSnoozePopView() {
        popSettingSnoozeView = Bundle.main.loadNibNamed("SettingSnoozeModalView", owner: self, options: nil)?.first as! SettingSnoozeModalView
        popSettingSnoozeView.delegate = self
        popSettingSnoozeView.frame = self.view.frame
        
        self.view.addSubview(popSettingSnoozeView)
    }
    
    func addSettingPasswordPopView() {
        popSettingPasswordView = Bundle.main.loadNibNamed("SettingPasswordModalView", owner: self, options: nil)?.first as! SettingPasswordModalView
        popSettingPasswordView.delegate = self
        popSettingPasswordView.frame = self.view.frame
        
        self.view.addSubview(popSettingPasswordView)
    }
    
    // table view datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileMenuTableViewCell", for: indexPath) as? ProfileMenuTableViewCell
        cell?.menuname.text = menus[indexPath.row]
        cell?.backgroundview.setPopItemViewStyle()

        if menus[indexPath.row] == ""
        {
            cell?.backgroundview.backgroundColor = UIColor.init(hex: "f7f7fa")
            cell?.backgroundview.isHidden = true
        }
        else {
            cell?.backgroundview.backgroundColor = UIColor.white
            cell?.backgroundview.isHidden = false
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        print(indexPath.row)
        
        visualEffectView.alpha = 0.96
        mTabView.isHidden = true
        settingFAB.isHidden = true
        
        self.addComonPopView(index: indexPath.row)
        popModalView.resetMedicationList(type: indexPath.row)
    }
    
    @IBAction func tapBtnSetting(_ sender: Any) {
//        let settingsViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
//        self.present(settingsViewController, animated: true, completion: nil)
        visualEffectView.alpha = 0.96
        mTabView.isHidden = true
        settingFAB.isHidden = true
        
        self.addSettingPopView()
    }
    
    // Mark: ProfileConditionDetailModalViewDelegate
    func popConditionDetailViewDismissal() {
        self.popConditionDetailView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }

    // Mark: PopModalViewDelegate
    func popViewDismissal() {
        self.popModalView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }
    
    func popViewAddBtnClick() {
        switch selectIndex {
        case 0:
            do {
                self.popModalView.removeFromSuperview()
                self.addVerifyCardPopView()
            }
        case 1:
            do {
                //
            }
            break
        case 2:
            do {
                self.popModalView.removeFromSuperview()
                self.addAddConditionPopView()
            }
            break
        case 3:
            do {
                self.popViewDismissal()
            }
            break
        case 4:
            do {
                self.popModalView.removeFromSuperview()
                self.addAddConditionPopView()
            }
            break
        case 5:
            do {
                self.popModalView.removeFromSuperview()
                self.addAddCommunityPopView()
            }
            break
        case 7:
            do {
                self.popModalView.removeFromSuperview()
                self.addAddAppPopView()
            }
            break
        default:
            break
        }
    }
    
    func onClickCardItemClick(id index: Int) {
        //
    }
    
    func onClickMedicationItemClick(id index: Int) {
        self.popViewDismissal()
    }
    
    func onClickConditionItemClick(id index: Int) {
        self.popModalView.removeFromSuperview()
        self.addConditionDetailPopView(index: index)
    }
    
    func onClickDoctorItemClick(id index: Int) {
        self.popModalView.removeFromSuperview()
        self.addDoctorDetailPopView(index: index)
    }
    
    func onClickPharmacyItemClick(id index: Int) {
        self.popModalView.removeFromSuperview()
        self.addPharmacyDetailPopView(index: index)
    }
    
    func onClickComunityItemClick(id index: Int) {
        self.popModalView.removeFromSuperview()
        self.addCommunityDetailPopView(index: index)
    }
    
    func onClickScheduleItemClick(id index: Int) {
        self.popModalView.removeFromSuperview()
        self.addScheduleDetailPopView(index: index)
    }
    
    func onClickAppItemClick(id index: Int) {
        self.popViewDismissal()
    }
    
    // Mark: ProfileAddConditionModalViewDelegate
    func popAddConditionViewDismissal() {
        self.popAddConditionView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }
    
    func popAddConditionViewAddBtnClick() {
        self.popAddConditionView.removeFromSuperview()
        self.addComonPopView(index: selectIndex)
        popModalView.resetMedicationList(type: selectIndex)
    }
    
    // Mark: ProfileDoctorDetailModalViewDelegate
    func popDoctorDetailViewDismissal() {
        self.popDoctorDetailView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }
    
    // Mark: ProfilePharmacyDetailModalViewDelegate
    func popPharmacyDetailViewDismissal() {
        self.popPharmacyDetailView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }
    
    // Mark: ProfileCommunityDetailModalViewDelegate
    func popCommunityDetailViewDismissal() {
        self.popCommunityDetailView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }
    
    // Mark: ProfileAddCommunityModalViewDelegate
    func popAddCommunityViewDismissal() {
        self.popAddCommunityView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }
    
    func popAddCommunityViewTextClick() {
        self.popAddCommunityView.removeFromSuperview()
        self.addComonPopView(index: selectIndex)
        popModalView.resetMedicationList(type: selectIndex)
    }
    
    func popAddCommunityViewEmailClick() {
        self.popAddCommunityView.removeFromSuperview()
        self.addComonPopView(index: selectIndex)
        popModalView.resetMedicationList(type: selectIndex)
    }
    
    // Mark: ProfileScheduleDetailModalViewDelegate
    func popScheduleDetailViewDismissal() {
        self.popScheduleDetailView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }
    
    func popScheduleDetailViewNextClick() {
        self.popScheduleDetailView.removeFromSuperview()
        self.addComonPopView(index: selectIndex)
        popModalView.resetMedicationList(type: selectIndex)
    }
    
    // Mark: ProfileAddAppModalViewDelegate
    func popAddAppViewDismissal() {
        self.popAddAppView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }
    
    func popAddAppViewAddClick() {
        self.popAddAppView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }
    
    // Mark: ProfilePersonDetailModalViewDelegate
    func popPersonDetailViewDismissal() {
        self.popPersonDetailView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }
    
    // Mark: ProfileAddCardModalViewDelegate
    func popAddCardViewDismissal() {
        self.popVerifyCardView.removeFromSuperview()
        self.addComonPopView(index: selectIndex)
        popModalView.resetMedicationList(type: selectIndex)
    }
    
    func popAddCardViewVerifyBtnClick() {
        self.popVerifyCardView.removeFromSuperview()
        self.addComonPopView(index: selectIndex)
        popModalView.resetMedicationList(type: selectIndex)
    }
    
    // Mark: ProfileSettingModalViewDelegate
    func popSettingViewDismissal() {
        self.popSettingView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }
    
    func popSettingViewSignBtnClick() {
        self.popSettingView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        
        mTabView.isHidden = false
        settingFAB.isHidden = false
        self.tabBarController?.dismiss(animated: true, completion: nil)
    }
    
    func popSettingViewBtnsClick(name: String) {
        switch name {
        case "Terms & Conditions":
            do {
                self.popSettingView.removeFromSuperview()
                self.addSettingTermPopView()
                //self.popSettingTermView.txtContent.backgroundColor = UIColor.clear
                self.popSettingTermView.contentUL.text = "Please read these terms of use carefully (“Terms”). These Terms provided by Nexpil, Inc. (“Nexpil”) govern and apply to your access and use of www.nexpil.com and Nexpil's services available via Nexpil's site and Nexpil's mobile apps (collectively, the “Service”). By accessing or using our Service, you agree to be bound to all of the terms and conditions described in these Terms. If you do not agree to all of these terms and conditions, do not use our Service. \n IMPORTANT!!! THE SERVICE IS INTENDED SOLELY AS A TOOL TO ASSIST YOU IN ORGANIZING, UNDERSTANDING AND MANAGING HEALTHCARE-RELATED INFORMATION. THE SERVICE IS NOT INTENDED TO PROVIDE HEALTH OR MEDICAL ADVICE. THE SERVICE IS NOT INTENDED TO (AND DOES NOT) CREATE ANY PATIENT RELATIONSHIP BETWEEN NEXPIL AND YOU, NOR SHOULD IT BE CONSIDERED A REPLACEMENT FOR CONSULTATION WITH A HEALTHCARE PROFESSIONAL. YOU SHOULD NEVER DISREGARD MEDICAL ADVICE OR DELAY SEEKING MEDICAL ADVICE BECAUSE OF SOMETHING YOU HAVE READ ON THE SERVICE OR THE RESULTS YOU RECEIVE THROUGH THE SERVICE. \n IN ADDITION, YOU UNDERSTAND AND AGREE THAT IN PROVIDING THE SERVICE WE RELY ON A NUMBER OF THIRD PARTY PROVIDERS, INCLUDING FOR PURPOSES OF SENDING PUSH NOTIFICATIONS, AND HEREBY DISCLAIM ANY LIABILITY WITH RESPECT TO THE SERVICES PROVIDED BY SUCH PROVIDERS. YOU SHOULD NOT RELY ON THE SERVICE FOR ANY LIFE-THREATENING CONDITION OR ANY OTHER SITUATION WHERE TIMELY ADMINISTRATION OF MEDICATIONS OR OTHER TREATMENT IS CRITICAL. \n USE OF THE SERVICE \n Nexpil allows you to access and use the Service through our mobile and web-based apps and our site (each an “App”). Via the Services, we offer, among other things, a convenient way to set reminders for prescription medications (“Medications”) and nutritional supplements (“Supplements”), to receive alerts about drug interactions, side effects and recalls based on the Medications you enter into the system, as well as the opportunity to participate in our Gift Program, as described below. You must be at least 18 years of age in order to download and/or use the App. \n As long as you comply with these Terms, you have the right to download and install a copy of the App to your mobile device, and to access and use the Service, for your own personal use. You may not: (i) copy, modify or distribute the App for any purpose; (ii) transfer, sublicense, lease, lend, rent or otherwise distribute the App or the Service to any third party; (iii) decompile, reverse-engineer, disassemble, or create derivative works of the App or the Service; (iv) make the functionality of the App or the Service available to multiple users through any means; or (v) use the Service in any unlawful manner, for any unlawful purpose, or in any manner inconsistent with these Terms. \n The following terms apply to any App accessed through or downloaded from any app store or distribution..."
                self.popSettingTermView.txtContent.text = "Please read these terms of use carefully (“Terms”). These Terms provided by Nexpil, Inc. (“Nexpil”) govern and apply to your access and use of www.nexpil.com and Nexpil's services available via Nexpil's site and Nexpil's mobile apps (collectively, the “Service”). By accessing or using our Service, you agree to be bound to all of the terms and conditions described in these Terms. If you do not agree to all of these terms and conditions, do not use our Service. \n IMPORTANT!!! THE SERVICE IS INTENDED SOLELY AS A TOOL TO ASSIST YOU IN ORGANIZING, UNDERSTANDING AND MANAGING HEALTHCARE-RELATED INFORMATION. THE SERVICE IS NOT INTENDED TO PROVIDE HEALTH OR MEDICAL ADVICE. THE SERVICE IS NOT INTENDED TO (AND DOES NOT) CREATE ANY PATIENT RELATIONSHIP BETWEEN NEXPIL AND YOU, NOR SHOULD IT BE CONSIDERED A REPLACEMENT FOR CONSULTATION WITH A HEALTHCARE PROFESSIONAL. YOU SHOULD NEVER DISREGARD MEDICAL ADVICE OR DELAY SEEKING MEDICAL ADVICE BECAUSE OF SOMETHING YOU HAVE READ ON THE SERVICE OR THE RESULTS YOU RECEIVE THROUGH THE SERVICE. \n IN ADDITION, YOU UNDERSTAND AND AGREE THAT IN PROVIDING THE SERVICE WE RELY ON A NUMBER OF THIRD PARTY PROVIDERS, INCLUDING FOR PURPOSES OF SENDING PUSH NOTIFICATIONS, AND HEREBY DISCLAIM ANY LIABILITY WITH RESPECT TO THE SERVICES PROVIDED BY SUCH PROVIDERS. YOU SHOULD NOT RELY ON THE SERVICE FOR ANY LIFE-THREATENING CONDITION OR ANY OTHER SITUATION WHERE TIMELY ADMINISTRATION OF MEDICATIONS OR OTHER TREATMENT IS CRITICAL. \n USE OF THE SERVICE \n Nexpil allows you to access and use the Service through our mobile and web-based apps and our site (each an “App”). Via the Services, we offer, among other things, a convenient way to set reminders for prescription medications (“Medications”) and nutritional supplements (“Supplements”), to receive alerts about drug interactions, side effects and recalls based on the Medications you enter into the system, as well as the opportunity to participate in our Gift Program, as described below. You must be at least 18 years of age in order to download and/or use the App. \n As long as you comply with these Terms, you have the right to download and install a copy of the App to your mobile device, and to access and use the Service, for your own personal use. You may not: (i) copy, modify or distribute the App for any purpose; (ii) transfer, sublicense, lease, lend, rent or otherwise distribute the App or the Service to any third party; (iii) decompile, reverse-engineer, disassemble, or create derivative works of the App or the Service; (iv) make the functionality of the App or the Service available to multiple users through any means; or (v) use the Service in any unlawful manner, for any unlawful purpose, or in any manner inconsistent with these Terms. \n The following terms apply to any App accessed through or downloaded from any app store or distribution..."            }
                self.popSettingTermView.txtContent.setContentOffset(.zero, animated: false)
                self.popSettingTermView.txtContent.scrollRangeToVisible(NSMakeRange(0, 0))
            break
        case "Disclaimer":
            do {
                self.popSettingView.removeFromSuperview()
                self.addSettingTermPopView()
                self.popSettingTermView.titleUL.text = "Disclaimer"
                self.popSettingTermView.contentUL.text = "The data contained in the Nexpil mobile application, including the text, images, and graphics, are for informational purposes only. Use of the mobile application is not intended to be a substitute for professional medical judgment and you should promptly contact your own health care provider regarding any medical conditions or medical questions that you have. THE MOBILE APPLICATION DOES NOT OFFER MEDICAL ADVICE, AND NOTHINGCONTAINED IN THE CONTENT IS INTENDED TO CONSTITUTE PROFESSIONAL ADVICE FOR MEDICAL DIAGNOSIS OR TREATMENT. The practice of medicine is a complex process that involves the synthesis of information from a multiplicity of sources. The information contained in the mobile application delivers similar information to that of a textbook or other health resource. Nexpil, Inc. d/b/a Nexpil (\"Company\") accepts no responsibility for the correctness of any diagnosis based in whole or in part upon the use of this mobile application. The data represent the current view of the individual author and do not necessarily represent the view of the Company or other contributing institutions, nor does inclusion on the site of advertisements for specific products or manufacturers indicate endorsement by the Company's contributing institutions or authors.\n\n Although great care has been taken in compiling and checking the information given to ensure accuracy, the Company, the authors, their employers, the sponsors, and their servants or agents shall not be responsible or in any way liable for any errors, omissions, or inaccuracies, whether arising from negligence or otherwise, or for any consequences arising therefrom. \n\n DISCLAIMER OF WARRANTIES. THIS MOBILE APPLICATION AND ITS CONTENT ARE PROVIDED \"AS IS.\" THE COMPANY MAKES NO REPRESENTATIONS OR ENDORSEMENT ABOUT THE SUITABILITY FOR ANY PURPOSE OF PRODUCTS AND SERVICES AVAILABLE THROUGH THIS MOBILE APPLICATION. WE DO NOT GUARANTEE THE TIMELINESS, VALIDITY, COMPLETENESS, OR ACCURACY OF THE CONTENT. WE DISCLAIM ALL WARRANTIES AND CONDITIONS, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND NON-INFRINGEMENT, WITH REGARD TO THE CONTENT, PRODUCTS, SERVICES, AND ALL OTHER INFORMATION CONTAINED ON AND/OR MADE AVAILABLE THROUGH THIS MOBILE APPLICATION, INCLUDING BUT NOT LIMITED TO THE AVAILABILITY OF THIS MOBILE APPLICATION. ALTHOUGH WE MAY UPDATE THE CONTENT ON THIS MOBILE APPLICATION FROM TIME TO TIME, PLEASE NOTE THAT MEDICAL INFORMATION CHANGESRAPIDLY. THEREFORE, SOME OF THE INFORMATION MAY BE OUT OF DATE AND/OR MAY CONTAIN ERRORS. BECAUSE SOME JURISDICTIONS DO NOT PERMIT THE EXCLUSION OF CERTAIN WARRANTIES, THESE EXCLUSIONS MAY NOT APPLY TO YOU. \n\n The Nexpil Mobile Application may contain graphic health- or medical-related materials. If you find these materials offensive, you may not want to use the Mobile Application."
                self.popSettingTermView.txtContent.text = "The data contained in the Nexpil mobile application, including the text, images, and graphics, are for informational purposes only. Use of the mobile application is not intended to be a substitute for professional medical judgment and you should promptly contact your own health care provider regarding any medical conditions or medical questions that you have. THE MOBILE APPLICATION DOES NOT OFFER MEDICAL ADVICE, AND NOTHINGCONTAINED IN THE CONTENT IS INTENDED TO CONSTITUTE PROFESSIONAL ADVICE FOR MEDICAL DIAGNOSIS OR TREATMENT. The practice of medicine is a complex process that involves the synthesis of information from a multiplicity of sources. The information contained in the mobile application delivers similar information to that of a textbook or other health resource. Nexpil, Inc. d/b/a Nexpil (\"Company\") accepts no responsibility for the correctness of any diagnosis based in whole or in part upon the use of this mobile application. The data represent the current view of the individual author and do not necessarily represent the view of the Company or other contributing institutions, nor does inclusion on the site of advertisements for specific products or manufacturers indicate endorsement by the Company's contributing institutions or authors.\n\n Although great care has been taken in compiling and checking the information given to ensure accuracy, the Company, the authors, their employers, the sponsors, and their servants or agents shall not be responsible or in any way liable for any errors, omissions, or inaccuracies, whether arising from negligence or otherwise, or for any consequences arising therefrom. \n\n DISCLAIMER OF WARRANTIES. THIS MOBILE APPLICATION AND ITS CONTENT ARE PROVIDED \"AS IS.\" THE COMPANY MAKES NO REPRESENTATIONS OR ENDORSEMENT ABOUT THE SUITABILITY FOR ANY PURPOSE OF PRODUCTS AND SERVICES AVAILABLE THROUGH THIS MOBILE APPLICATION. WE DO NOT GUARANTEE THE TIMELINESS, VALIDITY, COMPLETENESS, OR ACCURACY OF THE CONTENT. WE DISCLAIM ALL WARRANTIES AND CONDITIONS, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND NON-INFRINGEMENT, WITH REGARD TO THE CONTENT, PRODUCTS, SERVICES, AND ALL OTHER INFORMATION CONTAINED ON AND/OR MADE AVAILABLE THROUGH THIS MOBILE APPLICATION, INCLUDING BUT NOT LIMITED TO THE AVAILABILITY OF THIS MOBILE APPLICATION. ALTHOUGH WE MAY UPDATE THE CONTENT ON THIS MOBILE APPLICATION FROM TIME TO TIME, PLEASE NOTE THAT MEDICAL INFORMATION CHANGESRAPIDLY. THEREFORE, SOME OF THE INFORMATION MAY BE OUT OF DATE AND/OR MAY CONTAIN ERRORS. BECAUSE SOME JURISDICTIONS DO NOT PERMIT THE EXCLUSION OF CERTAIN WARRANTIES, THESE EXCLUSIONS MAY NOT APPLY TO YOU. \n\n The Nexpil Mobile Application may contain graphic health- or medical-related materials. If you find these materials offensive, you may not want to use the Mobile Application."
                self.popSettingTermView.txtContent.setContentOffset(.zero, animated: false)
                self.popSettingTermView.txtContent.scrollRangeToVisible(NSMakeRange(0, 0))
            }
            break
        case "   Snooze Time\n":
            do {
                self.popSettingView.removeFromSuperview()
                self.addSettingSnoozePopView()
            }
        case "Password":
            do {
                self.popSettingView.removeFromSuperview()
                self.addSettingPasswordPopView()
            }
            break
        default:
            break
        }
    }
    
    // Mark: SettingTermModalViewDelegate
    func popSettingTermModalViewDismissal() {
        self.popSettingTermView.removeFromSuperview()
        self.addSettingPopView()
    }
    
    // Mark: SettingSnoozeModalViewDelegate
    func popSettingSnoozeModalViewDismissal() {
        self.popSettingSnoozeView.removeFromSuperview()
        self.addSettingPopView()
    }
    
    func popSettingSnoozeAddView() {
        //
    }
    
    // Mark: SettingPasswordModalViewDelegate
    func popSettingPasswordModalViewDismissal() {
        self.popSettingPasswordView.removeFromSuperview()
        self.addSettingPopView()
    }
    
    func popSettingPasswordSaveView() {
        //
    }
    
    func getAllData(){
        let bloodGlucose = self.getBloodGlocose()
        let bloodPressure = self.getBloodPressure()
        let oxygenLevel = self.getOxygenlevel()
        let mood = self.getMood()
        let steps = self.getSteps()
        let weight = self.getWeight()
        let hemoglobin = self.getHemoglobinAlc()
        let lipid = self.getLipidPanel()
        let inr = self.getINR()
        
        var arrayList = NSMutableArray.init()
        
        let dic0 = NSDictionary.init(objects: ["Blood Glucose", "Blood Glucose", bloodGlucose, "mg/dl", "icon_blood_glucose", "#333333"], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString, "icon" as NSString, "unit_color" as NSString])
        let dic1 = NSDictionary.init(objects: ["Blood Pressure", "Blood Pressure", bloodPressure, "", "icon_blood_pressure", "#333333"], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString, "icon" as NSString, "unit_color" as NSString])
        let dic2 = NSDictionary.init(objects: ["Oxygen Level", "Oxygen Level", oxygenLevel, "%", "", "#333333"], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString, "icon" as NSString, "unit_color" as NSString])
        let dic3 = NSDictionary.init(objects: ["Mood", "Mood", mood, "", "", "#333333"], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString, "icon" as NSString, "unit_color" as NSString])
        let dic4 = NSDictionary.init(objects: ["Steps", "Steps", steps, "", "", "#8495ED"], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString, "icon" as NSString, "unit_color" as NSString])
        let dic5 = NSDictionary.init(objects: ["Weight", "Weight", weight, "lbs", "", "#877CEC"], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString, "icon" as NSString, "unit_color" as NSString])
        let dic6 = NSDictionary.init(objects: ["Hemoglobin A1c", "Hemoglobin A1c", hemoglobin, "%"], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString])
        let dic7 = NSDictionary.init(objects: ["Lipid Panel", "Lipid Panel", lipid, "mg/dl"], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString])
        let dic8 = NSDictionary.init(objects: ["INR", "INR", inr, ""], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString])
        
        arrayList = NSMutableArray.init(array: [dic0, dic1, dic2, dic3, dic4, dic5, dic6, dic7, dic8])
        arrayCondition = arrayList as! [NSDictionary]
    }
    
    func getBloodGlocose() -> String {
        let array = manager.fetchBloodGlucoseGetAllDaysData()
        if array.count > 0 {
            let data = ((array[0] as! NSDictionary)["data"] as! NSArray)[0] as! BloodGlucose
            let value = data.value
            
            return String(format: "%ld", value)
            
        } else {
            return ""
        }
    }
    
    func getBloodPressure() -> String {
        let array = manager.fetchBloodPressureGetAllDaysData()
        if array.count > 0 {
            let data = ((array[0] as! NSDictionary)["data"] as! NSArray)[0] as! BloodPressure
            let value1 = data.value1
            let value2 = data.value2
            
            return String(format: "%ld/%ld", value1, value2)
        } else {
            return ""
        }
    }
    
    func getOxygenlevel() -> String {
        let array = manager.fetchOxygenLevelGetAllDaysData()
        if array.count > 0 {
            let data = ((array[0] as! NSDictionary)["data"] as! NSArray)[0] as! OxygenLevel
            let value = data.value
            
            return String(format: "%ld", value)
        } else {
            return ""
        }
    }
    
    func getMood() -> String {
        let array = manager.fetchMood()
        if array.count > 0 {
            let data = array.firstObject as! Mood
            let value = Int(data.feeling)
            
            let arrayFeeling = [
                ["index": "0", "imageName": "feel_0", "title": "Very Sad"],
                ["index": "1", "imageName": "feel_1", "title": "Sad"],
                ["index": "2", "imageName": "feel_2", "title": "Neutral"],
                ["index": "3", "imageName": "feel_3", "title": "Happy"],
                ["index": "4", "imageName": "feel_4", "title": "Very Happy"],
                ]
            
            return String(format: "%@", ((arrayFeeling[value] as NSDictionary).value(forKey: "title") as! String))
        } else {
            return ""
        }
    }
    
    func getSteps() -> String {
        let array = manager.fetchStepsGetAllDaysData()
        if array.count > 0 {
            let dic = array[0] as! NSDictionary
            if dic.value(forKey: "data") != nil {
                let arrayDic = dic.value(forKey: "data") as! NSArray
                if arrayDic.count > 0 {
                    let data = arrayDic[0] as! Steps
                    let value = data.value
                    return String(format: "%0.0f", value)
                    
                } else {
                    return ""
                }
                
            } else {
                return ""
            }
            
        } else {
            return ""
        }
        
    }
    
    func getWeight() -> String {
        if UserDefaults.standard.value(forKey: "weight") != nil {
            let weight = UserDefaults.standard.value(forKey: "weight") as! Double
            
            return String(format: "%.0f", weight * 2.2)
        } else {
            return ""
        }
        
    }
    
    func getHemoglobinAlc() -> String {
        let array = manager.fetchHemoglobinAlc()
        if array.count > 0 {
            let data = array[0] as! HemoglobinAlc
            let value = data.value
            
            return String(format: "%0.1f", value)
        } else {
            return "0.0"
        }
    }
    
    func getLipidPanel() -> String {
        let array = manager.fetchLipidPanelGetAllYearData(index: "HDL")
        if array.count > 0 {
            let data = ((array[0] as! NSDictionary)["data"] as! NSArray)[0] as! NSDictionary
            let value = (data["average"] as! NSNumber).stringValue
            
            return String(format: "%@", value)
        } else {
            return "00"
        }
    }
    
    func getINR() -> String {
        let array = manager.fetchINR()
        if array.count > 0 {
            let data = array[0] as! INR
            let value = data.value
            
            return String(format: "%0.1f", value)
        } else {
            return "0.0"
        }
    }
    
}

