//
//  MoodTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/31.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit

protocol MoodTableViewCell2Delegate: class {
    func didTapButtonEditMoodDetailsCell(index: NSInteger)
}

class MoodTableViewCell2: UITableViewCell {

    weak var delegate:MoodTableViewCell2Delegate?
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblFeeling: UILabel!
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet weak var imgFeeling: UIImageView!
    @IBOutlet weak var btnTapDetails: UIButton!
    
    var index: NSInteger!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true;
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setInfo(dic: Mood) {
        let date = dic.date
        let feeling = Int(dic.feeling)
        let notes = dic.notes
        var strImage = ""
        var strTitle = ""
        let arrayFeeling = [
            ["index": "0", "imageName": "feel_0", "title": "Very Sad"],
            ["index": "1", "imageName": "feel_1", "title": "Sad"],
            ["index": "2", "imageName": "feel_2", "title": "Neutral"],
            ["index": "3", "imageName": "feel_3", "title": "Happy"],
            ["index": "4", "imageName": "feel_4", "title": "Very Happy"],
            ]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let strDate = dateFormatter.string(from: date! as Date)
        lblDate.text = strDate
        
        strImage = arrayFeeling[feeling]["imageName"]!
        strTitle = arrayFeeling[feeling]["title"]!
        
        imgFeeling.image = UIImage.init(named: strImage)
        lblFeeling.text = strTitle
        
        if (notes?.count)! > 0 {
            lblNotes.text = notes
            lblNotes.isHidden = false
            btnTapDetails.isHidden = true
        } else {
            lblNotes.isHidden = true
            btnTapDetails.isHidden = false
        }
        
        lblDate.font = UIFont.init(name: "Montserrat", size: 38)
        lblFeeling.font = UIFont.init(name: "Montserrat", size: 20)
        lblNotes.font = UIFont.init(name: "Montserrat", size: 15)
    }
    
    @IBAction func tapBtnEditDetails(_ sender: Any) {
        self.delegate?.didTapButtonEditMoodDetailsCell(index: index)
    }
    
    
}
