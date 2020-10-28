//
//  DataUtils.swift
//  Stockstally
//
//  Created by Admin on 10/19/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit

public class DataUtils {
    
    static let APIURL = "http://52.14.153.176/webservice/";
    static let PROFILEURL = "http://52.14.153.176/webservice/upload/profile/";
    static let PHOTOURL = "http://52.14.153.176/webservice/upload/post/photo/";
    static let VIDEOURL = "http://52.14.153.176/webservice/upload/post/video/";
    static let AUTH_URL = "patient_authorize.php";
    static let PRODUCT_URL = "drug_product.php";
    
    static let COMMUNITYUSERS_URL = "communityusers_information.php"
    static let COMMUNITYPOST_URL = "community_post.php"
    static let COMMUNITYNOTIFICATION_URL = "community_notifications.php"
    
    static let MYDRUG_URL = "mydrug_information.php";
    static let PATIENT_MEDICATION_URL = "mypatient_medication.php";
    
    static let UMLS_AUTH = "https://utslogin.nlm.nih.gov/cas/v1/api-key"
    static let API_KEY = "b542a764-08a3-4b1d-84ca-f00287b016cf"
    static let TICKET_URL = "https://utslogin.nlm.nih.gov/cas/v1/tickets/"
    static let UMLS_SERVICE = "http://umlsks.nlm.nih.gov"
    
    static let DRUGNAME_URL = "http://ec2-54-162-72-84.compute-1.amazonaws.com/complete.php"
    
    static let heightTitle = 70
    static let heightAdd = 80
    static let heightCard = 452
    static let heightMedication = 70
    static let heightCondition = 70
    static let heightDoctor = 80
    static let heightPharmacy = 80
    static let heightCommunity = 70
    static let heightSchedule = 80
    static let heightApp = 80
    static let heightSecurity = 90

    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    class func messageShow(view: UIViewController, message:String, title:String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
    
    class func customActivityIndicatory(_ viewContainer: UIView, startAnimate:Bool? = true) {
        let mainContainer: UIView = UIView(frame: viewContainer.frame)
        mainContainer.center = viewContainer.center
        mainContainer.backgroundColor = UIColor.white //UIColor.init(coder: 0xFFFFFF)
        mainContainer.alpha = 0.5
        mainContainer.tag = 789456123
        mainContainer.isUserInteractionEnabled = false
        
        let viewBackgroundLoading: UIView = UIView(frame: CGRect(x:0,y: 0,width: 80,height: 80))
        viewBackgroundLoading.center = viewContainer.center
        viewBackgroundLoading.backgroundColor = UIColor(red: 68/255.0, green: 68/255.0, blue: 68/255.0, alpha: 1.0) //UIColor.init(coder: 0x444444)
        viewBackgroundLoading.alpha = 0.5
        viewBackgroundLoading.clipsToBounds = true
        viewBackgroundLoading.layer.cornerRadius = 15
        
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
        activityIndicatorView.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        activityIndicatorView.center = CGPoint(x: viewBackgroundLoading.frame.size.width / 2, y: viewBackgroundLoading.frame.size.height / 2)
        if startAnimate!{
            viewBackgroundLoading.addSubview(activityIndicatorView)
            mainContainer.addSubview(viewBackgroundLoading)
            viewContainer.addSubview(mainContainer)
            activityIndicatorView.startAnimating()
        }else{
            for subview in viewContainer.subviews{
                if subview.tag == 789456123{
                    subview.removeFromSuperview()
                }
            }
        }
        //return activityIndicatorView
    }
    
    class func setUserId(userId:String) {
        let defaults = UserDefaults.standard
        
        defaults.set(userId, forKey: "userid")
    }
    
    class func setPurchaseState(id:Int) {
        let defaults = UserDefaults.standard
        defaults.set(id,forKey:"purchase")
    }
    
    class func getPurchaseState() -> Int? {
        let defaults = UserDefaults.standard
        return defaults.integer(forKey: "purchase")
    }
    
    class func getUserId() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "userid")
    }
    
    class func setEmail(email:String) {
        let defaults = UserDefaults.standard
        
        defaults.set(email, forKey: "email")
        
    }
    
    class func getEmail() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "email")
    }
    
    class func getDrugId() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "drugid")
    }
    class func setDrugId(drugid:String) {
        let defaults = UserDefaults.standard
        
        defaults.set(drugid, forKey: "drugid")
        
    }
    
    
    class func setPassword(password:String) {
        let defaults = UserDefaults.standard
        
        defaults.set(password, forKey: "password")
        
    }
    
    class func getPassword() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "password")
    }
    
    class func setUsername(username:String) {
        let defaults = UserDefaults.standard
        defaults.set(username, forKey: "username")
    }
    
    class  func getUsername() -> String? {
        let defaults = UserDefaults.standard
        
        return defaults.string(forKey: "username")
    }  
    
    //preference for UMLS
    class func setTGT(st: String) {
        let defaults = UserDefaults.standard
        defaults.set(st, forKey: "tgt")
    }
    class func getTGT() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "tgt")
    }
    
    class func setTGTTime(time: String) {
        let defaults = UserDefaults.standard
        defaults.set(time, forKey: "tgttime")
    }
    
    class func getTGTTime() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "tgttime")
    }
    
    class func setST(st: String) {
        let defaults = UserDefaults.standard
        defaults.set(st, forKey: "st")
    }
    class func getST() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "st")
    }
    
    class func setSTTime(time: String) {
        let defaults = UserDefaults.standard
        defaults.set(time, forKey: "sttime")
    }
    
    class func getSTTime() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "sttime")
    }
    
    class func setPatient(time: String) {
        let defaults = UserDefaults.standard
        defaults.set(time, forKey: "patient")
    }
    
    class func getPatient() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "patient")
    }
    
    class func setSkipButton(time: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(time, forKey: "skip")
    }
    
    class func getSkipButton() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: "skip")
    }
    
    class func setPatientFullName(patientfullname: String) {
        let defaults = UserDefaults.standard
        defaults.set(patientfullname, forKey: "patientfullname")
    }
    
    class func getPatientFullName() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "patientfullname")
    }
    
    class func setPharmacyName(pharmacy: String) {
        let defaults = UserDefaults.standard
        defaults.set(pharmacy, forKey: "pharmacy")
    }
    
    class func getPharmacyName() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "pharmacy")
    }
    
    class func setMedicationName(name: String) {
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: "medicationname")
    }
    
    class func getMedicationName() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "medicationname")
    }
    
    class func setMedicationStrength(name: String) {
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: "medicationstrength")
    }
    
    class func getMedicationStrength() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "medicationstrength")
    }
    
    class func setMedicationDate(name: String) {
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: "medicationdate")
    }
    
    class func getMedicationDate() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "medicationdate")
    }
    
    class func setMedicationDose(name: String) {
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: "medicationdose")
    }
    
    class func getMedicationDose() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "medicationdose")
    }
    
    class func setMedicationFrequency(name: String) {
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: "medicationfrequency")
    }
    
    class func getMedicationFrequency() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "medicationfrequency")
    }
    
    class func setStartTablet(name: String) {
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: "starttablet")
    }
    
    class func getStartTablet() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "starttablet")
    }
    
    class func setLeftTablet(name: String) {
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: "lefttablet")
    }
    
    class func getLeftTablet() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "lefttablet")
    }
    
    class func setPrescribed(name: String) {
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: "prescribe")
    }
    
    class func getPrescribed() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "prescribe")
    }
    
    class func setMedicationWhen(name: String) {
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: "medicationwhen")
    }
    
    class func getMedicationWhen() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "medicationwhen")
    }
    
    class func setMPrescription(name: Int) {
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: "prescription")
    }
    
    class func getPrescription() -> Int {
        let defaults = UserDefaults.standard
        return defaults.integer(forKey: "prescription")
    }
    
    class func getStartColor() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "startcolor")
    }
    class func setStartColor(name: String) {
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: "startcolor")
    }
    
    class func getEndColor() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "endcolor")
    }
    class func setEndColor(name: String) {
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: "endcolor")
    }
    
    class func getCameraStatus() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: "camerastatus")
    }
    class func setCameraStatus(name: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: "camerastatus")
    }
    
    class func setTimeRange(index: Int,time:String) {
        let defaults = UserDefaults.standard
        switch index {
        case 0:
            defaults.set(time,forKey:"morning")
        case 1:
            defaults.set(time,forKey:"midday")
        case 2:
            defaults.set(time,forKey:"evening")
        case 3:
            defaults.set(time,forKey:"night")
        default:
            break
        }
    }
    
    class func getTimeRange(index:Int) -> String? {
        let defaults = UserDefaults.standard
        switch index {
        case 0:
            return defaults.string(forKey: "morning")
        case 1:
            return defaults.string(forKey: "midday")
        case 2:
            return defaults.string(forKey: "evening")
        case 3:
            return defaults.string(forKey: "night")
        default:
            break
        }
        return ""
    }
    
    class func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    class func showDownloadDialog(controller:UIViewController)
    {
        
    }
    
    class func purchaseDialog(controller:UIViewController, opt:Int)
    {
        /*
        let download = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "purchasedialog") as! PurchaseDialog
        controller.addChildViewController(download)
        download.option = opt
        if opt == 0 //StocksCalculatorViewController
        {
            download.delegate = controller as! StocksCalculatorViewController
        }
        else if opt == 1 //CalculatorHistoryViewController
        {
            download.delegate = controller as! CalculatorHistoryViewController
        }
        else if opt == 2 //SimpleCalculatorViewController
        {
            download.delegate = controller as! SimpleCalculatorViewController
        }
        download.view.frame = controller.view.frame        
        controller.view.addSubview(download.view)
        download.didMove(toParentViewController: controller)
        */
    }
    
    class func inviteFriendsDialog(controller:UIViewController)
    {
        /*
         let show = DownloadDialog(nibName: "DownloadDialog", bundle: nil)
         
         show.view.frame = UIScreen.main.bounds
         //[self.window addSubview:show.view];
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         appDelegate.window?.rootViewController = show
         */
        
        /*
        let download = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inviteDialog") as! InviteDialog
        controller.addChildViewController(download)
        download.view.frame = controller.view.frame
        controller.view.addSubview(download.view)
        download.didMove(toParentViewController: controller)
        */
    }
    
    class func shareData(viewcontroller:UIViewController)
    {
        /*
        let activityViewController = UIActivityViewController(
            activityItems: ["Check out this really cool stock risk management calculator.", "https://itunes.apple.com/us/app/stocks-tally/id1308069415?mt=8"],
            applicationActivities: nil)
        */
        /*
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.barButtonItem = (sender as! UIBarButtonItem)
        }
 
        viewcontroller.present(activityViewController, animated: true, completion: nil)
        */
    }
    
    class func appReview()
    {
        let url = NSURL(string: "https://itunes.apple.com/us/app/stocks-tally/id1308069415?mt=8")!
        UIApplication.shared.openURL(url as URL)
    }
    
    class func showSettings(viewcontroller:UIViewController)
    {
        /*
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let viewController = storyboard.instantiateViewController(withIdentifier :"pageview") as! KYDrawerController
        let viewController = storyboard.instantiateViewController(withIdentifier :"settings") as! SettingsViewController
        viewcontroller.present(viewController, animated: true)
        */
    }  
    
    class func getProfitTargetMargin(buyin:Double, profittarget:Double) -> Double
    {
        return (profittarget - buyin)
    }
    
    class func getProfitTargetPercent(buyin:Double,profittarget:Double) -> Double
    {
        //return ((profittarget - buyin)/buyin) * 100;
        return getProfitTargetMargin(buyin: buyin,profittarget: profittarget)/buyin;
    }
    
    class func getPotentialProfit(buyin:Double,profittarget:Double,shares:Double) ->Double
    {
        //return (profittarget - buyin) * shares;
        return getProfitTargetMargin(buyin: buyin,profittarget: profittarget) * shares;
    }
    
    class func getStopLossTarget(buyin:Double,stoploss:Double,option:Int) ->Double
    {
        if(option == 0) //Amount
        {
    
            return (buyin - stoploss)
        }
        else //percent
        {
            return (buyin - stoploss * buyin/100)
        }
    }
    
    class func getStopLossPercent(buyin:Double,stoploss:Double,option:Int) -> Double
    {
        if(option == 0)
        {
            //return stoploss/getStopLossTarget(buyin,stoploss,option);
            return stoploss/buyin
        }
        else
        {
            //return (stoploss * buyin/100)/ getStopLossTarget(buyin,stoploss,option);
            return stoploss/100
        }
    }
    
    class func getPotentialLoss(buyin:Double,stoploss:Double,option:Int,shares:Double) -> Double
    {
        return (buyin - getStopLossTarget(buyin: buyin,stoploss: stoploss,option: option)) * shares
    }
    
    class func getProfitLossRatio(buyin:Double,profittarget:Double,stoploss:Double,option:Int,shares:Double) -> Double
    {
        return getPotentialProfit(buyin: buyin,profittarget: profittarget,shares: shares)/getPotentialLoss(buyin: buyin,stoploss: stoploss,option: option,shares: shares);
    }
}
