//
//  ScanLipidPanelViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/06/01.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import AVFoundation

protocol ScanLipidPanelViewControllerDelegate: class {
    func didTapButtonDonePopupScanLipidPanelViewController(date: Date, value: NSInteger, index: String)
}

class ScanLipidPanelViewController: UIViewController, PopupLipidPanelViewControllerDelegate, SHDCameraUtilityDelegate {

    weak var delegate:ScanLipidPanelViewControllerDelegate?
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imgTake: UIImageView!
    
    var popupLipidPanelViewController = PopupLipidPanelViewController()
    var Index = String()
    var cameraUtility = SHDCameraUtility()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initMainView()
        self.initCameraView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        cameraUtility.finalizeLoad(with: contentView)
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
        btnAdd.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
    }
    
    func initCameraView() {
        cameraUtility = SHDCameraUtility.init(view: contentView, andDelegate: self)
    }
    
    @IBAction func tapBtnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapBtnAddManually(_ sender: Any) {
        sleep(UInt32(0.5))
        
        popupLipidPanelViewController = (self.storyboard?.instantiateViewController(withIdentifier: "PopupLipidPanelViewController") as? PopupLipidPanelViewController)!
        popupLipidPanelViewController.Index = Index
        popupLipidPanelViewController.delegate = self
        
        UIApplication.shared.keyWindow?.addSubview((popupLipidPanelViewController.view)!)
    }
    
    // MARK - PopupLipidPanelViewController delegate
    func didTapButtonClosePopupLipidPanelViewController() {
        popupLipidPanelViewController.view.removeFromSuperview()
    }
    
    func didTapButtonDonePopupLipidPanelViewController(date: Date, value: NSInteger, index: String) {
        popupLipidPanelViewController.view.removeFromSuperview()
        self.dismiss(animated: false, completion: nil)
        
        self.delegate?.didTapButtonDonePopupScanLipidPanelViewController(date: date, value: value, index: index)
        
        print(">>> date:", date)
        print(">>> value:", value)
        print(">>> index:", index)
        
    }
    
    @IBAction func tapBtnShot(_ sender: Any) {
        AudioServicesPlaySystemSound(1108)
        cameraUtility.touchUp()
    }
    
    // MARK - CameraUtility Delegate
    func cameraUtilityDidTakePhoto(_ photo: UIImage!) {
        imgTake.image = photo
    }
    
}
