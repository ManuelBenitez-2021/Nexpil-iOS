//
//  ScanHemoglobinAlcViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/06/01.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import AVFoundation

protocol ScanHemoglobinAlcViewControllerDelegate: class {
    func didTapButtonAddScanHemoglobinAlcViewController(date: Date, value: Float);
    
}

class ScanHemoglobinAlcViewController: UIViewController, AddManuallyHemoglobinA1cViewControllerDelegate, SHDCameraUtilityDelegate {

    weak var delegate:ScanHemoglobinAlcViewControllerDelegate?
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imgTake: UIImageView!
    
    var addManuallyHemoglobinA1cViewController = AddManuallyHemoglobinA1cViewController()
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
    
    @IBAction func tapBtnAddManully(_ sender: Any) {
        sleep(UInt32(0.5))
        
        addManuallyHemoglobinA1cViewController = (self.storyboard?.instantiateViewController(withIdentifier: "AddManuallyHemoglobinA1cViewController") as? AddManuallyHemoglobinA1cViewController)!
        addManuallyHemoglobinA1cViewController.delegate = self
        self.present(addManuallyHemoglobinA1cViewController, animated: true, completion: nil)
    }
    
    // MARK - AddManuallyHemoglobinA1cViewController delegate
    func didTapButtonAddManuallyHemoglobinA1cViewController(date: Date, time: String, timeIndex: String, value: String) {
        if value.count > 0 {
            self.delegate?.didTapButtonAddScanHemoglobinAlcViewController(date: date, value: Float(value)!)
            
            DispatchQueue.main.async {
                self.dismiss(animated: false, completion: nil)
            }

        } else {
            self.loadAlertController(message: "Input value error")
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
        let verifyInformationHemoglobinA1cViewController = (self.storyboard?.instantiateViewController(withIdentifier: "VerifyInformationHemoglobinA1cViewController") as? VerifyInformationHemoglobinA1cViewController)!
        self.present(verifyInformationHemoglobinA1cViewController, animated: true, completion: nil)
    }
    
}
