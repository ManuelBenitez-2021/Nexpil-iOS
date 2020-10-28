//
//  ScanOxygenLevelsViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/06/01.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import AVFoundation

protocol ScanOxygenLevelsViewControllerDelegate: class {
    func didTapButtonAddOxygenLevelViewController(date: Date, time: String, timeIndex: String, value: NSInteger);
    
}

class ScanOxygenLevelsViewController: UIViewController, AddManuallyOxygenLevelViewControllerDelegate, SHDCameraUtilityDelegate {

    weak var delegate:ScanOxygenLevelsViewControllerDelegate?
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imgTake: UIImageView!
    
    var popupOxygenLevelsViewController = PopupOxygenLevelsViewController()
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
        
        let addManuallyOxygenLevelViewController = (self.storyboard?.instantiateViewController(withIdentifier: "AddManuallyOxygenLevelViewController") as? AddManuallyOxygenLevelViewController)!
        addManuallyOxygenLevelViewController.delegate = self
        
        self.present(addManuallyOxygenLevelViewController, animated: true, completion: nil)
    }
    
    // MARK - AddManuallyOxygenLevelViewController delegate
    func didTapButtonAddManuallyOxygenLevelViewController(date: Date, time: String, timeIndex: String, value: String) {
        self.delegate?.didTapButtonAddOxygenLevelViewController(date: date, time: time, timeIndex: timeIndex, value: Int(value)!)
        
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: nil)
        }

    }
    
    func loadAlertController(message: String) {
        let alert = UIAlertController(title: message,
                                      message: nil,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tapBtnShot(_ sender: Any) {
        AudioServicesPlaySystemSound(1108)
        cameraUtility.touchUp()
    }
    
    // MARK - CameraUtility Delegate
    func cameraUtilityDidTakePhoto(_ photo: UIImage!) {
//        imgTake.image = photo
        let verifyInformationOxyenLevelViewController = (self.storyboard?.instantiateViewController(withIdentifier: "VerifyInformationOxyenLevelViewController") as? VerifyInformationOxyenLevelViewController)!
        self.present(verifyInformationOxyenLevelViewController, animated: true, completion: nil)
    }
    
}
