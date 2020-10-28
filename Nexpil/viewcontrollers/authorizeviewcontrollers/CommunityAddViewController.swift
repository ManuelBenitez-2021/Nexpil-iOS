//
//  CommunityAddViewController.swift
//  Nexpil
//
//  Created by Admin on 5/7/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import ALCameraViewController

class CommunityAddViewController: UIViewController {

    
    @IBOutlet weak var cropView: UIImageView!
    
    var userImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Get the back-facing camera for capturing videos
        let gesture3 = UITapGestureRecognizer(target: self, action:  #selector(self.imageSelect))
        
        cropView.addGestureRecognizer(gesture3)
    }   
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        cropView.layer.cornerRadius = cropView.frame.size.width/2.0
        cropView.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func imageSelect(sender : UITapGestureRecognizer) {
        
        var libraryEnabled: Bool = true
        var allowsLibraryAccess: Bool = true
        var croppingEnabled: Bool = true
        var allowResizing: Bool = false
        var allowMoving: Bool = true
        var minimumSize: CGSize = CGSize(width: 400, height: 400)
        
        var croppingParameters: CroppingParameters {
            return CroppingParameters(isEnabled: croppingEnabled, allowResizing: allowResizing, allowMoving: allowMoving, minimumSize: minimumSize)
        }
        
        
        let cameraViewController = CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: libraryEnabled) { [weak self] image, asset in
            // Do something with your image here.
            self?.cropView.image = image
            self?.userImage = image?.resizeImageWith(newSize: CGSize(width: 400, height: 400))
            
            
            self?.dismiss(animated: true, completion: nil)
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }
    
    @IBAction func gotoCancel(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func gotoNext(_ sender: Any) {
        guard let _ = userImage else {
            DataUtils.messageShow(view: self, message: "You have to have a photo", title: "")
            return
        }
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommunitySignupViewController") as! CommunitySignupViewController
        viewController.userImage = userImage
        present(viewController, animated: false, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
