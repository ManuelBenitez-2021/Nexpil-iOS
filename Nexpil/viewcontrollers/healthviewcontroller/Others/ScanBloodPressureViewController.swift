//
//  ScanBloodPressureViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/31.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import AVFoundation

protocol ScanBloodPressureViewControllerDelegate: class {
    func didTapButtonAddScanBloodPressureViewController(date: Date, time: String, timeIndex: String, value1: NSInteger, value2: NSInteger);
}


class ScanBloodPressureViewController: UIViewController, PopupBloodPressureViewControllerDelegate, AddManuallyBloodPressureViewControllerDelegate, SHDCameraUtilityDelegate {

    weak var delegate:ScanBloodPressureViewControllerDelegate?
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imgTake: UIImageView!
    
    var popupBloodPressureViewController = PopupBloodPressureViewController()
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
    
    @IBAction func tapbtnAddManually(_ sender: Any) {
        sleep(UInt32(0.5))
        
        let addManuallyBloodPressureViewController = (self.storyboard?.instantiateViewController(withIdentifier: "AddManuallyBloodPressureViewController") as? AddManuallyBloodPressureViewController)!
        addManuallyBloodPressureViewController.delegate = self
        
        self.present(addManuallyBloodPressureViewController, animated: true, completion: nil)

    }
    
    // MARK - PopupBloodPressureViewControllerDelegate
    func didTapButtonClosePopupBloodPressureViewController() {
        popupBloodPressureViewController.view.removeFromSuperview()
    }
    
    func didTapButtonDonePopupBloodPressureViewController(date: Date,
                                                          time: String,
                                                          timeIndex: String,
                                                          pressure1: String,
                                                          pressure2: String) {
        popupBloodPressureViewController.view.removeFromSuperview()
        self.dismiss(animated: false, completion: nil)
        
        if pressure1.count == 0 || pressure2.count == 0 {
            self.loadAlertController(message: "Please input the value")
            
        } else {
            self.delegate?.didTapButtonAddScanBloodPressureViewController(date: date,
                                                                          time: time,
                                                                          timeIndex: timeIndex,
                                                                          value1: NSInteger(pressure1)!,
                                                                          value2: NSInteger(pressure2)!)
        }
    }
    
    // MARK - AddMnuallyBloodpressureViewController Delegate
    func didTapButtonAddManuallyBloodPressureViewController(date: Date, time: String, timeIndex: String, pressure1: String, pressure2: String) {
        
        if pressure1.count == 0 || pressure2.count == 0 {
            self.loadAlertController(message: "Please input the value")
            
        } else {
            self.delegate?.didTapButtonAddScanBloodPressureViewController(date: date,
                                                                          time: time,
                                                                          timeIndex: timeIndex,
                                                                          value1: NSInteger(pressure1)!,
                                                                          value2: NSInteger(pressure2)!)
            
            DispatchQueue.main.async {
                self.dismiss(animated: false, completion: nil)
            }

        }
    }
    
    @IBAction func tapBtnShot(_ sender: Any) {
        AudioServicesPlaySystemSound(1108)
        cameraUtility.touchUp()
    }
    
    // MARK - CameraUtility Delegate
    func cameraUtilityDidTakePhoto(_ photo: UIImage!) {
//        imgTake.image = photo
        
        self.loadVerifyInformationBloodPressureViewController()
    }
    
    func loadVerifyInformationBloodPressureViewController() {
        let verifyInformationBloodPressureViewController = (self.storyboard?.instantiateViewController(withIdentifier: "VerifyInformationBloodPressureViewController") as? VerifyInformationBloodPressureViewController)!
        //        verifyInformationBloodGlucoseViewController.delegate = self
        self.present(verifyInformationBloodPressureViewController, animated: true, completion: nil)
    }
    
    func loadAlertController(message: String) {
        let alert = UIAlertController(title: message,
                                      message: nil,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
