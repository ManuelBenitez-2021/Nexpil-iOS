//
//  SelectPrivacyViewController.swift
//  Nexpil
//
//  Created by Admin on 25/06/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import ASHorizontalScrollView

class SelectPrivacyViewController: UIViewController {
    

    var communityUsers:[CommunityUser] = []
    var usersCheck:[Bool] = []
    @IBOutlet weak var donebtn: GradientView!
    
    @IBOutlet weak var specificView: GradientView!
    @IBOutlet weak var specific: UILabel!
    @IBOutlet weak var specificdesc: UILabel!
    @IBOutlet weak var specificImage: UIImageView!
    @IBOutlet weak var everyoneView: GradientView!
    @IBOutlet weak var everyone: UILabel!
    @IBOutlet weak var everyoneImage: UIImageView!
    @IBOutlet weak var everyonedesc: UILabel!
    
    var delegate: ShadowDelegate?
    var delegate1: UserSelectDelegate?
    
    var selectedIndex = 1
    
    @IBOutlet weak var userPhotosView: ASHorizontalScrollView!
    @IBOutlet weak var userlistHeight: NSLayoutConstraint!
    var photoProfiles:[SmallProfilePhoto] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(self.gotoDone))
        donebtn.addGestureRecognizer(gesture1)
        
        donebtn.topColor = UIColor.init(hex: "877cec")
        donebtn.bottomColor = UIColor.init(hex: "4939e3")
        
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.selectMenu))
        everyoneView.tag = 1
        everyoneView.addGestureRecognizer(gesture2)
        let gesture3 = UITapGestureRecognizer(target: self, action:  #selector(self.selectMenu))
        specificView.tag = 2
        specificView.addGestureRecognizer(gesture3)
        selectPrivacy()
        showUserPhotos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showUserPhotos()
    {
        userPhotosView.setItemsMarginOnce()
        userPhotosView.removeAllItems()
        
        for i in 1 ..< communityUsers.count
        {
            //if let photoProfile = Bundle.main.loadNibNamed("PhotoProfile", owner: self, options: nil)?.first as? PhotoProfile {
            let photoProfile = SmallProfilePhoto.init(frame: CGRect(x: 0 , y: 0, width: 50, height: 70))
            //photoProfile.frame = CGRect.init(x: 0, y: 0, width: 110, height: 110)
            usersCheck.append(false)
            if i == 0
            {
                photoProfile.userName.text = "You"
            }
            else
            {
                photoProfile.userName.text = communityUsers[i].firstname + " " + communityUsers[i].lastname.prefix(1).uppercased() + "." //names[i]
            }
            
            var image: UIImage?
            if communityUsers[i].userimage == ""
            {
                image = UIImage(named: "Intersection 1")
                photoProfile.photoImage.image = image
                photoProfile.photoImage.contentMode = .bottom
            }
            else
            {
                let url = URL(string: DataUtils.PROFILEURL + communityUsers[i].userimage)
                photoProfile.photoImage.kf.setImage(with: url)
            }
            
            photoProfile.photoImage.layer.masksToBounds = false
            photoProfile.photoImage.layer.borderWidth = 0.0
            photoProfile.photoImage.layer.borderColor = UIColor.init(hex: "000000").withAlphaComponent(0.16).cgColor
            //photoProfile.photoImage.contentMode = .scaleToFill
            
            photoProfile.photoImage.layer.cornerRadius =  photoProfile.photoImage.frame.size.height/2
            
            photoProfile.photoImage.clipsToBounds = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(gesture:)))
            photoProfile.photoImage.tag = i
            
            photoProfile.photoImage.addGestureRecognizer(tapGesture)
            photoProfile.photoImage.isUserInteractionEnabled = true
            userPhotosView.addItem(photoProfile)
            photoProfiles.append(photoProfile)
        }
        
    }
    
    @objc func tapGesture(gesture: UIGestureRecognizer) {
        let tag = gesture.view!.tag
        if (usersCheck[tag - 1] == true)
        {
            if communityUsers[tag].userimage == ""
            {
                let image = UIImage(named: "Intersection 1")
                photoProfiles[tag - 1].photoImage.image = image
                photoProfiles[tag - 1].photoImage.contentMode = .bottom
            }
            else {
                let url = URL(string: DataUtils.PROFILEURL + communityUsers[tag].userimage)
                photoProfiles[tag - 1].photoImage.kf.setImage(with: url)
            }
            
        }
        else {
            photoProfiles[tag - 1].photoImage.image = UIImage(named: "checked-n")
        }
        usersCheck[tag - 1] = !usersCheck[tag - 1]
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func selectPrivacy()
    {
        everyone.textColor = UIColor.init(hex: "333333")
        everyonedesc.textColor = UIColor.init(hex: "333333").withAlphaComponent(0.5)
        everyoneImage.isHidden = false
        everyoneView.topColor = UIColor.white
        everyoneView.bottomColor = UIColor.white
        userPhotosView.isHidden = true
        userlistHeight.constant = 0
        
        specific.textColor = UIColor.init(hex: "333333")
        specificdesc.textColor = UIColor.init(hex: "333333").withAlphaComponent(0.5)
        specificImage.isHidden = false
        specificView.topColor = UIColor.white
        specificView.bottomColor = UIColor.white
        
        switch selectedIndex {
        case 1:
            everyone.textColor = UIColor.init(hex: "ffffff")
            everyonedesc.textColor = UIColor.init(hex: "ffffff").withAlphaComponent(0.5)
            everyoneImage.isHidden = true
            everyoneView.topColor = UIColor.init(hex: "877cec")
            everyoneView.bottomColor = UIColor.init(hex: "4939e3")
        case 2:
            specific.textColor = UIColor.init(hex: "ffffff")
            specificdesc.textColor = UIColor.init(hex: "ffffff").withAlphaComponent(0.5)
            specificImage.isHidden = true
            userlistHeight.constant = 70
            userPhotosView.isHidden = false
            specificView.topColor = UIColor.init(hex: "877cec")
            specificView.bottomColor = UIColor.init(hex: "4939e3")
        default:
            break
        }
    }
    
    @objc func selectMenu(sender : UITapGestureRecognizer) {
        selectedIndex =  sender.view!.tag
        selectPrivacy()
    }
    
    @objc func gotoDone(sender : UITapGestureRecognizer) {
        if selectedIndex == 1
        {
            usersCheck.removeAll()
            
        }
        else {
            var counts = false
            for i in 0 ..< usersCheck.count
            {
                if usersCheck[i] == true
                {
                    counts = true
                    break
                }
            }
            if counts == false
            {
                DataUtils.messageShow(view: self, message: "Please select users.", title: "")
                return
            }
        }
        self.delegate?.removeShadow()
        self.delegate1?.getSelectedUser(checks: usersCheck)
        dismiss(animated: false, completion: nil)
    }
}
