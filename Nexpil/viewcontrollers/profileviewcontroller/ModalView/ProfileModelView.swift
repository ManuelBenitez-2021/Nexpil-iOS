//
//  ProfileModelView.swift
//  Nexpil
//
//  Created by JinYingZhe on 1/23/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

protocol ProfileModelViewDelegate {
    func popViewDismissal()
    func popViewAddBtnClick()
    func onClickCardItemClick(id index: Int)
    func onClickMedicationItemClick(id index: Int)
    func onClickConditionItemClick(id index: Int)
    func onClickDoctorItemClick(id index: Int)
    func onClickPharmacyItemClick(id index: Int)
    func onClickComunityItemClick(id index: Int)
    func onClickScheduleItemClick(id index: Int)
    func onClickAppItemClick(id index: Int)
}

class ProfileModelView: UIView {
    @IBOutlet weak var backUV: UIView!
    @IBOutlet weak var wholeUV: UIView!
    @IBOutlet weak var addUB: NPButton!
    @IBOutlet weak var closeUB: UIButton!
    @IBOutlet weak var titleUL: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var itemList_CH: NSLayoutConstraint!
    @IBOutlet weak var scrollView_CH: NSLayoutConstraint!
    
    var delegate: ProfileModelViewDelegate?
    let vSpace: Int = 10

    var selectIndex: Int = 0
    let screenSize = UIScreen.main.bounds
    
    let delta = 580 - 405
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //  Initialation code
        self.backUV.setPopItemViewStyle(radius: 30.0, title: .large)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(wholeTapped(tapGestureRecognizer:)))
        self.wholeUV.addGestureRecognizer(tapGestureRecognizer)
        self.closeUB.setPopItemViewStyle(radius: 22.5)
    }
    
    func resetMedicationList(type value: Int){
        selectIndex = value
        
        switch value {
        case 0:
//            do {
//                if arrayCard.count == 0 {
//                    return
//                }
//
//                let itemHeight = 400
//                itemList_CH.constant = CGFloat(itemHeight)
//                itemListSCV.layoutIfNeeded()
//
//                let itemWidth: Int = Int(itemListSCV.bounds.width)
//                let itemCount = arrayCard.count
//
//                itemListSCV.contentSize.width = CGFloat(itemWidth * itemCount)
//
//                for i in 0...arrayCard.count - 1 {
//                    let posY = margin;
//                    let posX = itemWidth * i + margin;
//                    let rect = CGRect(x: posX, y: posY, width: itemWidth - margin * 2, height: itemHeight - margin * 2)
//
//                    let itemBtn = Bundle.main.loadNibNamed("CardsItemView", owner: self, options: nil)?.first as! CardsItemView
//                    itemBtn.frame = rect
//                    itemBtn.setDataContent(withData: arrayCard[i])
//                    itemBtn.tag = i
//                    itemBtn.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cardItemTapped(tapGestureRecognizer:)))
//                    itemBtn.addGestureRecognizer(tapGestureRecognizer)
//
//                    self.itemListSCV.addSubview(itemBtn)
//                }
//            }
            break
        case 1:
            do {
                if arrayMedication.count == 0 {
                    return
                }

                let iHeight = 54
                let iCount = arrayMedication.count

                let rect = contentView.frame
                let height = (iHeight + vSpace) * iCount - vSpace
                
                contentView.frame = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: CGFloat(height))
                itemList_CH.constant = CGFloat(height)
                
                if height + delta < 580 {
                    scrollView_CH.constant = CGFloat(height + delta)
                }

                for i in 0...arrayMedication.count - 1 {
                    let iWidth = rect.size.width
                    let iPosY = (iHeight + vSpace) * i;
                    
                    let iRect = CGRect(x: 0, y: iPosY, width: Int(iWidth), height: Int(iHeight))

                    let iBtn = UIButton(frame: iRect)
                    
                    iBtn.setTitle(arrayMedication[i].value(forKey: "name") as? String, for: .normal)
                    iBtn.setTitleColor(.black, for: .normal)
                    iBtn.titleLabel?.font =  UIFont(name: "Montserrat-Regular", size: 20)
                    iBtn.backgroundColor = UIColor.white
                    iBtn.clipsToBounds = false
                    iBtn.setPopItemViewStyle()

                    iBtn.tag = i
                    iBtn.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    iBtn.addTarget(self, action: #selector(handleMedicationItem), for: .touchUpInside)

                    self.contentView.addSubview(iBtn)
                }
                self.addUB.setTitle("Add Medication", for: .normal)
            }
            break
        case 2:
            do {
                if arrayCondition.count == 0 {
                    return
                }
                
                let iHeight = 54
                let iCount = arrayCondition.count
                
                let rect = contentView.frame
                let height = (iHeight + vSpace) * iCount - vSpace
                
                contentView.frame = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: CGFloat(height))
                itemList_CH.constant = CGFloat(height)
                
                if height + delta < 580 {
                    scrollView_CH.constant = CGFloat(height + delta)
                }
                
                for i in 0...arrayCondition.count - 1 {
                    let iWidth = rect.size.width
                    let iPosY = (iHeight + vSpace) * i;
                    
                    let iRect = CGRect(x: 0, y: iPosY, width: Int(iWidth), height: Int(iHeight))
                    
                    let iBtn = UIButton(frame: iRect)
                    
                    iBtn.setTitle(arrayCondition[i].value(forKey: "title") as? String, for: .normal)
                    iBtn.setTitleColor(.black, for: .normal)
                    iBtn.titleLabel?.font =  UIFont(name: "Montserrat-Regular", size: 20)
                    iBtn.backgroundColor = UIColor.white
                    iBtn.clipsToBounds = false
                    iBtn.setPopItemViewStyle()
                    
                    iBtn.tag = i
                    iBtn.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    iBtn.addTarget(self, action: #selector(handleConditionItem), for: .touchUpInside)
                    
                    self.contentView.addSubview(iBtn)
                }
                self.addUB.setTitle("Add Condition", for: .normal)
            }
            break
        case 3:
            do {
                if arrayDoctor.count == 0 {
                    return
                }
                
                let iHeight = 73
                let iCount = arrayDoctor.count
                
                let rect = contentView.frame
                let height = (iHeight + vSpace) * iCount - vSpace
                
                contentView.frame = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: CGFloat(height))
                itemList_CH.constant = CGFloat(height)
                
                if height + delta < 580 {
                    scrollView_CH.constant = CGFloat(height + delta)
                }
                
                for i in 0...arrayDoctor.count - 1 {
                    let iWidth = rect.size.width
                    let iPosY = (iHeight + vSpace) * i;
                    
                    let iRect = CGRect(x: 0, y: iPosY, width: Int(iWidth), height: Int(iHeight))
                    
                    let iView = Bundle.main.loadNibNamed("DoctorItemView", owner: self, options: nil)?.first as! DoctorItemView
                    iView.frame = iRect
                    iView.setDectorContent(withData: arrayDoctor[i])
                    iView.tag = i
                    iView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    iView.clipsToBounds = false
                    iView.setPopItemViewStyle()
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doctorItemTapped(tapGestureRecognizer:)))
                    iView.addGestureRecognizer(tapGestureRecognizer)
                    self.contentView.addSubview(iView)
                }
                self.addUB.setTitle("Add Doctor", for: .normal)
            }
            break
        case 4:
            do {
                if arrayPharmacy.count == 0 {
                    return
                }
                
                let iHeight = 73
                let iCount = arrayPharmacy.count
                
                let rect = contentView.frame
                let height = (iHeight + vSpace) * iCount - vSpace
                
                contentView.frame = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: CGFloat(height))
                itemList_CH.constant = CGFloat(height)
                
                if height + delta < 580 {
                    scrollView_CH.constant = CGFloat(height + delta)
                }
                
                for i in 0...arrayPharmacy.count - 1 {
                    let iWidth = rect.size.width
                    let iPosY = (iHeight + vSpace) * i;
                    
                    let iRect = CGRect(x: 0, y: iPosY, width: Int(iWidth), height: Int(iHeight))
                    
                    let iView = Bundle.main.loadNibNamed("DoctorItemView", owner: self, options: nil)?.first as! DoctorItemView
                    iView.frame = iRect
                    iView.setDectorContent(withData: arrayPharmacy[i])
                    iView.tag = i
                    iView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    iView.clipsToBounds = false
                    iView.setPopItemViewStyle()
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pharmacyItemTapped(tapGestureRecognizer:)))
                    iView.addGestureRecognizer(tapGestureRecognizer)
                    self.contentView.addSubview(iView)
                }
                self.addUB.setTitle("Add Pharmacy", for: .normal)
            }
            break
        case 5:
            do {
                if arrayCommunity.count == 0 {
                    return
                }
                
                let iHeight = 73
                let iCount = arrayCommunity.count
                
                let rect = contentView.frame
                let height = (iHeight + vSpace) * iCount - vSpace
                
                contentView.frame = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: CGFloat(height))
                itemList_CH.constant = CGFloat(height)
                
                if height + delta < 580 {
                    scrollView_CH.constant = CGFloat(height + delta)
                }
                
                for i in 0...arrayCommunity.count - 1 {
                    let iWidth = rect.size.width
                    let iPosY = (iHeight + vSpace) * i;
                    
                    let iRect = CGRect(x: 0, y: iPosY, width: Int(iWidth), height: Int(iHeight))
                    
                    let iView = Bundle.main.loadNibNamed("CommunityItemView", owner: self, options: nil)?.first as! CommunityItemView
                    iView.frame = iRect
                    iView.setDectorContent(withData: arrayCommunity[i])
                    iView.tag = i
                    iView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    iView.clipsToBounds = false
                    iView.setPopItemViewStyle()
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(communityItemTapped(tapGestureRecognizer:)))
                    iView.addGestureRecognizer(tapGestureRecognizer)
                    self.contentView.addSubview(iView)
                }
                self.addUB.setTitle("Add Member", for: .normal)
            }
            break
        case 6:
            do {
                if arraySchedule.count == 0 {
                    return
                }
                
                let iHeight = 73
                let iCount = arraySchedule.count
                
                let rect = contentView.frame
                let height = (iHeight + vSpace) * iCount - vSpace
                
                contentView.frame = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: CGFloat(height))
                itemList_CH.constant = CGFloat(height)
                
                if height + delta < 580 {
                    scrollView_CH.constant = CGFloat(height + delta)
                }
                
                for i in 0...arraySchedule.count - 1 {
                    let iWidth = rect.size.width
                    let iPosY = (iHeight + vSpace) * i;
                    
                    let iRect = CGRect(x: 0, y: iPosY, width: Int(iWidth), height: Int(iHeight))
                    
                    let iView = Bundle.main.loadNibNamed("ScheduleItemView", owner: self, options: nil)?.first as! ScheduleItemView
                    iView.frame = iRect
                    iView.setDectorContent(withData: arraySchedule[i])
                    iView.tag = i
                    iView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    iView.clipsToBounds = false
                    iView.setPopItemViewStyle()
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(scheduleItemTapped(tapGestureRecognizer:)))
                    iView.addGestureRecognizer(tapGestureRecognizer)
                    self.contentView.addSubview(iView)
                }
                self.addUB.isHidden = true
            }
            break
        case 7:
            do {
                if arrayApp.count == 0 {
                    return
                }
                
                let iHeight = 100
                let iCount = (arrayApp.count + 1) / 2
                
                let rect = contentView.frame
                let height = (iHeight + vSpace) * iCount - vSpace
                
                contentView.frame = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: CGFloat(height))
                itemList_CH.constant = CGFloat(height)
                
                if height + delta < 580 {
                    scrollView_CH.constant = CGFloat(height + delta)
                }
                
                for i in 0...arrayApp.count - 1 {
                    let iWidth = (rect.size.width - 11) / 2
                    let lengI: Int = i / 2
                    let iPosY = (iHeight + vSpace) * lengI;
                    var iPosX: Int = 0
                    if (i % 2) == 0 {
                        iPosX = 0
                    } else {
                        iPosX = Int(iWidth + 11)
                    }
                    
                    let iRect = CGRect(x: iPosX, y: iPosY, width: Int(iWidth), height: Int(iHeight))
                    
                    let iView = Bundle.main.loadNibNamed("AppItemView", owner: self, options: nil)?.first as! AppItemView
                    iView.frame = iRect
                    iView.setDectorContent(withData: arrayApp[i])
                    iView.tag = i
                    iView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    iView.clipsToBounds = false
                    iView.setPopItemViewStyle()
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(appItemTapped(tapGestureRecognizer:)))
                    iView.addGestureRecognizer(tapGestureRecognizer)
                    self.contentView.addSubview(iView)
                }
                self.addUB.setTitle("Add App", for: .normal)
            }
            break
        default:
            break
        }
    }
    
    // Mark: Medication Item Handle
    @objc func handleMedicationItem(_ sender: AnyObject?) {
        self.delegate?.onClickMedicationItemClick(id: (sender?.tag)!)
    }
    
    // Mark: Condition Item Handle
    @objc func handleConditionItem(_ sender: AnyObject?) {
        self.delegate?.onClickConditionItemClick(id: (sender?.tag)!)
    }
    
    @IBAction func onClickAddBtnUB(_ sender: Any) {
        self.delegate?.popViewAddBtnClick()
    }
    
    @IBAction func onClickCloseUB(_ sender: Any) {
        self.delegate?.popViewDismissal()
    }
    
    @objc func wholeTapped(tapGestureRecognizer gesture: UITapGestureRecognizer) {
        self.delegate?.popViewDismissal()
    }
    
    @objc func cardItemTapped(tapGestureRecognizer gesture: UITapGestureRecognizer) {
        let v = gesture.view
        self.delegate?.onClickCardItemClick(id: (v?.tag)!)
    }
    
    @objc func doctorItemTapped(tapGestureRecognizer gesture: UITapGestureRecognizer) {
        let v = gesture.view
        self.delegate?.onClickDoctorItemClick(id: (v?.tag)!)
    }
    
    @objc func pharmacyItemTapped(tapGestureRecognizer gesture: UITapGestureRecognizer) {
        let v = gesture.view
        self.delegate?.onClickPharmacyItemClick(id: (v?.tag)!)
    }
    
    @objc func communityItemTapped(tapGestureRecognizer gesture: UITapGestureRecognizer) {
        let v = gesture.view
        self.delegate?.onClickComunityItemClick(id: (v?.tag)!)
    }
    
    @objc func scheduleItemTapped(tapGestureRecognizer gesture: UITapGestureRecognizer) {
        let v = gesture.view
        self.delegate?.onClickScheduleItemClick(id: (v?.tag)!)
    }
    
    @objc func appItemTapped(tapGestureRecognizer gesture: UITapGestureRecognizer) {
        let v = gesture.view
        self.delegate?.onClickAppItemClick(id: (v?.tag)!)
    }
    
}
