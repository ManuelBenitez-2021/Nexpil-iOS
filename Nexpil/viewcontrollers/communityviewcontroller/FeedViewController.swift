//
//  FeedViewController.swift
//  Nexpil
//
//  Created by Admin on 4/9/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import XLPagerTabStrip

import Alamofire
import AVFoundation
import AVKit
import OnlyPictures
class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    enum FeedCellType: Int {
        case calluser = 0
        case postmessage
        case image
        case video
        case message
        case question
    }
    
    let names = ["You","James W.","Dr. Smith","Jess W","Hust Wilson","Lau Keith"]
    
    var content:[FeedCellType] = [.postmessage,.image,.message,.question,.video]
    var content1:[FeedCellType] = [.calluser,.image,.message,.question,.video]
    
    var delegate: CommunitySubMenuDelegate?
    var selectedUser:Int = 0   
    var selectedUserid:Int = 0
    var posts:[PostEntity] = []
    var communityUsers:[CommunityUser] = []
    @IBOutlet weak var feedtableView: UITableView!
    
    let imageCache = NSCache<NSString, UIImage>()
    var userPictureIndex = 0
    var userimages:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        feedtableView.rowHeight = UITableViewAutomaticDimension
        feedtableView.estimatedRowHeight = 400
        //feedtableView.separatorStyle = UITableViewCellSeparatorStyle.none
        feedtableView.allowsSelection = false
        feedtableView.alwaysBounceVertical = false
        feedtableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        (selectedUser,selectedUserid) = (delegate?.selectDay(value: 0))!
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "profilechange")
        {
            showData()
            defaults.set(false,forKey:"profilechange")
        }else {
            showData()
        }
    }

    func showData()
    {
        let params = [
            "currentUserId" : PreferenceHelper().getId(),
            "userid" : selectedUserid,
            "choice" : "0"
            ] as [String : Any]
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        Alamofire.request(DataUtils.APIURL + DataUtils.COMMUNITYPOST_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                if response == nil
                {
                    return;
                }
                
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                //let user = PreferenceHelper()
                
                debugPrint(response);
                
                if let data = response.result.value {
                    self.posts.removeAll()
                    print("JSON: \(data)")
                    let json : [String:Any] = data as! [String : Any]
                    
                    let result = json["status"] as? String
                    if result == "true"
                    {
                        if self.selectedUser != 0
                        {
                            let user = json["user"] as! [String : Any]
                            let firstname = (user["firstname"] as! NSString) as String
                            let lastname = (user["lastname"] as! NSString) as String
                            let username = firstname + " " + lastname.prefix(1).uppercased() + "."
                            let userimage = (user["userimage"] as! NSString) as String
                            let phonenumber = (user["phonenumber"] as! NSString) as String
                            self.posts.append(PostEntity.init(userid: self.selectedUserid, posttype: "calluser", title: "", content: "", filename: "", mediaurl: "", createat: "", username: username, userimage: userimage, phonenumber: phonenumber))
                        }
                        else {
                            
                            self.posts.append(PostEntity.init(userid: self.selectedUserid, posttype: "postmessage", title: "", content: "", filename: "", mediaurl: "", createat: "", username: "", userimage: "", phonenumber: ""))
                           
                        }
                        let users = json["data"] as? [[String:Any]]
                        for user in users!
                        {
                            let post = PostEntity.init(json: user)
                            self.posts.append(post)
                        }
                        
                    }
                    else {
                        return
                    }
                    //self.getCommunityUsers()
                    self.feedtableView.reloadData()
                }
                    
            })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedUser == 0
        {
            if posts[indexPath.row].posttype == "calluser"//FeedCellType.calluser
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CallTableViewCell", for: indexPath) as? CallTableViewCell
                cell?.callbtn.layer.cornerRadius = 10
                cell?.callbtn.layer.masksToBounds = true
                cell?.callbtn.setTitle(posts[0].username,for: .normal)
                return cell!
            }
            else if posts[indexPath.row].posttype == "message"//FeedCellType.message
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as? MessageTableViewCell
                cell?.photo.image = UIImage(named: "you")
                cell?.photo.layer.cornerRadius =  (cell?.photo.frame.size.width)!/2
                cell?.photo.clipsToBounds = true
                cell?.name.text = "Olivia Wilson"
                cell?.time.text = "2:30 pm"
                cell?.message.text = "I'm feeling great after my \nafternoon walk!"
                cell?.likecounts.text = "5"
                cell?.commentcounts.text = "5"
                cell?.commentphoto.image = UIImage(named: "you")
                cell?.commentphoto.layer.cornerRadius =  (cell?.commentphoto.frame.size.width)!/2
                cell?.commentphoto.clipsToBounds = true
                return cell!
            }
            else if posts[indexPath.row].posttype == "postmessage"//FeedCellType.postmessage
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell
                
                if PreferenceHelper().getUserImage() != ""
                {
                    let url = URL(string: DataUtils.PROFILEURL + PreferenceHelper().getUserImage()!)
                    cell?.userphoto.kf.setImage(with: url)
                }
                else
                {
                    cell?.userphoto.image = UIImage(named: "Intersection 2")
                    cell?.userphoto.contentMode = .center
                }
                let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.postData))
                cell?.whatsonyourmind.addGestureRecognizer(gesture)
                
                cell?.photobtn.tag = 1
                cell?.photobtn.addTarget(self, action: #selector(self.addPost(_:)), for: .touchUpInside)
                cell?.videobtn.tag = 2
                cell?.videobtn.addTarget(self, action: #selector(self.addPost(_:)), for: .touchUpInside)
                cell?.moodbtn.tag = 3
                cell?.moodbtn.addTarget(self, action: #selector(self.addPost(_:)), for: .touchUpInside)
                cell?.userLabelView.topColor = UIColor.init(hex: DataUtils.getStartColor()!)
                cell?.userLabelView.bottomColor = UIColor.init(hex: DataUtils.getEndColor()!)
                //cell?.userphoto.image = UIImage(named: "you")
                cell?.userphoto.layer.cornerRadius =  cell!.userphoto.frame.size.width/2
                cell?.userphoto.clipsToBounds = true
                
                
                
                return cell!
            }
            else if posts[indexPath.row].posttype == "question"//FeedCellType.question
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as? QuestionTableViewCell
                return cell!
            }
            else if posts[indexPath.row].posttype == "photo" || posts[indexPath.row].posttype == "video" //FeedCellType.image
            {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as? ImageTableViewCell
                cell?.imageHeight.constant = 250
                if posts[indexPath.row].posttype == "photo"
                {
                    if posts[indexPath.row].filename != ""
                    {
                        let url = URL(string: DataUtils.PHOTOURL + posts[indexPath.row].filename)
                        
                        
                        cell?.mediaimage.kf.setImage(with: url)
                    }
                    else {
                        cell?.imageHeight.constant = 0
                    }
                    cell?.playbtn.isHidden = true
                }
                else {
                    
                    if let cachedImage = imageCache.object(forKey: (DataUtils.VIDEOURL + self.posts[indexPath.row].filename) as NSString) {
                        
                        cell?.mediaimage.image = cachedImage//self.createThumbnailOfVideoFromRemoteUrl(url:DataUtils.VIDEOURL + self.posts[indexPath.row].filename)
                    }
                    else {
                        cell?.mediaimage.image = self.createThumbnailOfVideoFromRemoteUrl(url:DataUtils.VIDEOURL + self.posts[indexPath.row].filename)
                    }
                    cell?.playbtn.isHidden = false
                    cell?.playbtn.tag = indexPath.row
                    cell?.playbtn.addTarget(self, action: #selector(self.playVideo(_:)), for: .touchUpInside)
                }
                
                if posts[indexPath.row].userimage == ""
                {
                    let image = UIImage(named: "Intersection 1")
                    cell?.userImage.image = image
                    //cell?.userImage.contentMode = .bottom
                    cell?.commentImage.image = image
                    //cell?.commentImage.contentMode = .scaleAspectFit
                }
                else
                {
                    let url = URL(string: DataUtils.PROFILEURL + posts[indexPath.row].userimage)
                    cell?.userImage.kf.setImage(with: url)
                    cell?.commentImage.kf.setImage(with: url)
                }
                cell?.userImage.layer.masksToBounds = false
                cell?.userImage.layer.borderWidth = 0.0
                cell?.userImage.layer.cornerRadius =  cell!.userImage.frame.size.height/2
                cell?.userImage.clipsToBounds = true
                
                cell?.commentImage.layer.masksToBounds = false
                cell?.commentImage.layer.borderWidth = 0.0
                //photoProfile.photoImage.layer.borderColor = endColor?.cgColor
                cell?.commentImage.layer.cornerRadius =  cell!.commentImage.frame.size.width/2
                cell?.commentImage.clipsToBounds = true
                
                cell?.content.text = posts[indexPath.row].content
                cell?.userName.text = posts[indexPath.row].firstname + " " + posts[indexPath.row].lastname
                
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                let time = formatter.date(from: posts[indexPath.row].createat)
                formatter.dateFormat = "h:mm a "
                formatter.amSymbol = "am"
                formatter.pmSymbol = "pm"
                let stringTime = formatter.string(from: time!)
                
                cell?.createTime.text = stringTime
                cell?.commentText.text = posts[indexPath.row].comment
                cell?.commentText.delegate = self
                cell?.commentText.tag = indexPath.row
                cell?.commentcnt.text = "\(posts[indexPath.row].commentcounts)"
                cell?.likecnt.text = "\(posts[indexPath.row].likecounts)"
                cell?.likebtn.tag = indexPath.row
                cell?.likebtn.addTarget(self, action: #selector(self.postLike(_:)), for: .touchUpInside)
                
                cell?.commentbtn.tag = indexPath.row
                cell?.commentbtn.addTarget(self, action: #selector(self.viewComment(_:)), for: .touchUpInside)
                
                /*
                if posts[indexPath.row].commentcounts == 0
                {
                    cell?.likebtn.isHidden = true
                    cell?.likecnt.isHidden = true
                }
                else {
                    cell?.likebtn.isHidden = false
                    cell?.likecnt.isHidden = false
                }
                */
                cell?.onlypictures.dataSource = self
                //cell?.onlypictures.delegate = self
                cell?.onlypictures.gap = 28
                cell?.onlypictures.layer.cornerRadius = 18
                cell?.onlypictures.spacingColor = .white
                cell?.onlypictures.alignment = .left
                if posts[indexPath.row].pictures.count == 0
                {
                    cell?.onlypictures.isHidden = true
                }
                else {
                    self.getUserPictures(postIndex: indexPath.row, onlyPictures: cell!.onlypictures)
                }
                
                
                
                return cell!
              
            }
            
            else if posts[indexPath.row].posttype == "mood"
            {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "MoodTableViewCell", for: indexPath) as? MoodTableViewCell
       
                if posts[indexPath.row].userimage == ""
                {
                    let image = UIImage(named: "Intersection 1")
                    cell?.userImage.image = image
                    //cell?.userImage.contentMode = .bottom
                    cell?.commentImage.image = image
                    //cell?.commentImage.contentMode = .scaleAspectFit
                }
                else
                {
                    let url = URL(string: DataUtils.PROFILEURL + posts[indexPath.row].userimage)
                    cell?.userImage.kf.setImage(with: url)
                    cell?.commentImage.kf.setImage(with: url)
                }
                cell?.userImage.layer.masksToBounds = false
                cell?.userImage.layer.borderWidth = 0.0
                cell?.userImage.layer.cornerRadius =  cell!.userImage.frame.size.height/2
                cell?.userImage.clipsToBounds = true
                
                cell?.commentImage.layer.masksToBounds = false
                cell?.commentImage.layer.borderWidth = 0.0
                //photoProfile.photoImage.layer.borderColor = endColor?.cgColor
                cell?.commentImage.layer.cornerRadius =  cell!.commentImage.frame.size.width/2
                cell?.commentImage.clipsToBounds = true
                
                cell?.content.text = posts[indexPath.row].content
                cell?.userName.text = posts[indexPath.row].firstname + " " + posts[indexPath.row].lastname
                
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                let time = formatter.date(from: posts[indexPath.row].createat)
                formatter.dateFormat = "h:mm a "
                formatter.amSymbol = "am"
                formatter.pmSymbol = "pm"
                let stringTime = formatter.string(from: time!)
                
                cell?.createTime.text = stringTime
                cell?.commentText.text = posts[indexPath.row].comment
                cell?.commentText.delegate = self
                cell?.commentText.tag = indexPath.row
                cell?.commentcnt.text = "\(posts[indexPath.row].commentcounts)"
                cell?.likecnt.text = "\(posts[indexPath.row].likecounts)"
                cell?.likebtn.tag = indexPath.row
                cell?.likebtn.addTarget(self, action: #selector(self.postLike(_:)), for: .touchUpInside)
                cell?.content.text = "Is feeling - "
                cell?.commentbtn.tag = indexPath.row
                cell?.commentbtn.addTarget(self, action: #selector(self.viewCommentMood(_:)), for: .touchUpInside)
                cell?.moodText.textColor = UIColor.init(hex: DataUtils.getEndColor()!)
                switch(posts[indexPath.row].moodstate)
                {
                case "1":
                    cell?.moodText.text = "Very Sad"
                    cell?.moodImage.image = UIImage.init(named: "Group 1069")
                case "2":
                    cell?.moodText.text = "Sad"
                    cell?.moodImage.image = UIImage.init(named: "Group 1070")
                case "3":
                    cell?.moodText.text = "Neutral"
                    cell?.moodImage.image = UIImage.init(named: "Group 1071")
                case "4":
                    cell?.moodText.text = "Happy"
                    cell?.moodImage.image = UIImage.init(named: "Group 1072")
                case "5":
                    cell?.moodText.text = "Very Happy"
                    cell?.moodImage.image = UIImage.init(named: "Group 1073")
                default:
                    break
                }
                
                cell?.onlypictures.dataSource = self
                //cell?.onlypictures.delegate = self
                cell?.onlypictures.gap = 28
                cell?.onlypictures.layer.cornerRadius = 18
                cell?.onlypictures.spacingColor = .white
                cell?.onlypictures.alignment = .left
                if posts[indexPath.row].pictures.count == 0
                {
                    cell?.onlypictures.isHidden = true
                }
                else {
                    self.getUserPictures(postIndex: indexPath.row, onlyPictures: cell!.onlypictures)
                }
                return cell!
                
            }
            
        }else {
            if posts[indexPath.row].posttype == "calluser"//FeedCellType.calluser
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CallTableViewCell", for: indexPath) as? CallTableViewCell
                cell?.callbtn.layer.cornerRadius = 10
                cell?.callbtn.layer.masksToBounds = true
                cell?.callbtn.setTitle(posts[0].username,for: .normal)
                return cell!
            }
            else if posts[indexPath.row].posttype == "message"//FeedCellType.message
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as? MessageTableViewCell
                cell?.photo.image = UIImage(named: "you")
                cell?.photo.layer.cornerRadius =  (cell?.photo.frame.size.width)!/2
                cell?.name.text = "Olivia Wilson"
                cell?.time.text = "2:30 pm"
                cell?.message.text = "I'm feeling great after my \nafternoon walk!"
                cell?.likecounts.text = "5"
                cell?.commentcounts.text = "5"
                return cell!
            }
            else if posts[indexPath.row].posttype == "postmessage"//FeedCellType.postmessage
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell
                
                cell?.userphoto.image = UIImage(named: "you")
                cell?.userphoto.layer.cornerRadius =  cell!.userphoto.frame.size.width/2
                return cell!
            }
            else if posts[indexPath.row].posttype == "question"//FeedCellType.question
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as? QuestionTableViewCell
                return cell!
            }
            else if posts[indexPath.row].posttype == "photo" || posts[indexPath.row].posttype == "video" //FeedCellType.image
            {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as? ImageTableViewCell
                cell?.imageHeight.constant = 250
                if posts[indexPath.row].posttype == "photo"
                {
                    if posts[indexPath.row].filename != ""
                    {
                        let url = URL(string: DataUtils.PHOTOURL + posts[indexPath.row].filename)
                        
                        
                        cell?.mediaimage.kf.setImage(with: url)
                    }
                    else {
                        cell?.imageHeight.constant = 0
                    }
                    cell?.playbtn.isHidden = true
                }
                else {
                    
                    if let cachedImage = imageCache.object(forKey: (DataUtils.VIDEOURL + self.posts[indexPath.row].filename) as NSString) {
                        
                        cell?.mediaimage.image = cachedImage//self.createThumbnailOfVideoFromRemoteUrl(url:DataUtils.VIDEOURL + self.posts[indexPath.row].filename)
                    }
                    else {
                        cell?.mediaimage.image = self.createThumbnailOfVideoFromRemoteUrl(url:DataUtils.VIDEOURL + self.posts[indexPath.row].filename)
                    }
                    cell?.playbtn.isHidden = false
                    cell?.playbtn.tag = indexPath.row
                    cell?.playbtn.addTarget(self, action: #selector(self.playVideo(_:)), for: .touchUpInside)
                }
                
                if posts[indexPath.row].userimage == ""
                {
                    let image = UIImage(named: "Intersection 1")
                    cell?.userImage.image = image
                    //cell?.userImage.contentMode = .bottom
                    cell?.commentImage.image = image
                    //cell?.commentImage.contentMode = .scaleAspectFit
                }
                else
                {
                    let url = URL(string: DataUtils.PROFILEURL + posts[indexPath.row].userimage)
                    cell?.userImage.kf.setImage(with: url)
                    cell?.commentImage.kf.setImage(with: url)
                }
                cell?.userImage.layer.masksToBounds = false
                cell?.userImage.layer.borderWidth = 0.0
                cell?.userImage.layer.cornerRadius =  cell!.userImage.frame.size.height/2
                cell?.userImage.clipsToBounds = true
                
                cell?.commentImage.layer.masksToBounds = false
                cell?.commentImage.layer.borderWidth = 0.0
                //photoProfile.photoImage.layer.borderColor = endColor?.cgColor
                cell?.commentImage.layer.cornerRadius =  cell!.commentImage.frame.size.width/2
                cell?.commentImage.clipsToBounds = true
                
                cell?.content.text = posts[indexPath.row].content
                cell?.userName.text = posts[indexPath.row].firstname + " " + posts[indexPath.row].lastname
                
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                let time = formatter.date(from: posts[indexPath.row].createat)
                formatter.dateFormat = "h:mm a "
                formatter.amSymbol = "am"
                formatter.pmSymbol = "pm"
                let stringTime = formatter.string(from: time!)
                
                cell?.createTime.text = stringTime
                cell?.commentText.text = posts[indexPath.row].comment
                cell?.commentText.delegate = self
                cell?.commentText.tag = indexPath.row
                cell?.commentcnt.text = "\(posts[indexPath.row].commentcounts)"
                cell?.likecnt.text = "\(posts[indexPath.row].likecounts)"
                cell?.likebtn.tag = indexPath.row
                cell?.likebtn.addTarget(self, action: #selector(self.postLike(_:)), for: .touchUpInside)
                
                cell?.commentbtn.tag = indexPath.row
                cell?.commentbtn.addTarget(self, action: #selector(self.viewComment(_:)), for: .touchUpInside)
                /*
                if posts[indexPath.row].commentcounts == 0
                {
                    cell?.likebtn.isHidden = true
                    cell?.likecnt.isHidden = true
                }
                else {
                    cell?.likebtn.isHidden = false
                    cell?.likecnt.isHidden = false
                }
                */
                cell?.onlypictures.dataSource = self
                //cell?.onlypictures.delegate = self
                cell?.onlypictures.gap = 28
                cell?.onlypictures.layer.cornerRadius = 18
                cell?.onlypictures.spacingColor = .white
                cell?.onlypictures.alignment = .left
                if posts[indexPath.row].pictures.count == 0
                {
                    cell?.onlypictures.isHidden = true
                }
                else {
                    self.getUserPictures(postIndex: indexPath.row, onlyPictures: cell!.onlypictures)
                }
                return cell!
                
            }
            else if posts[indexPath.row].posttype == "mood"
            {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "MoodTableViewCell", for: indexPath) as? MoodTableViewCell
                
                if posts[indexPath.row].userimage == ""
                {
                    let image = UIImage(named: "Intersection 1")
                    cell?.userImage.image = image
                    //cell?.userImage.contentMode = .bottom
                    cell?.commentImage.image = image
                    //cell?.commentImage.contentMode = .scaleAspectFit
                }
                else
                {
                    let url = URL(string: DataUtils.PROFILEURL + posts[indexPath.row].userimage)
                    cell?.userImage.kf.setImage(with: url)
                    cell?.commentImage.kf.setImage(with: url)
                }
                cell?.userImage.layer.masksToBounds = false
                cell?.userImage.layer.borderWidth = 0.0
                cell?.userImage.layer.cornerRadius =  cell!.userImage.frame.size.height/2
                cell?.userImage.clipsToBounds = true
                
                cell?.commentImage.layer.masksToBounds = false
                cell?.commentImage.layer.borderWidth = 0.0
                //photoProfile.photoImage.layer.borderColor = endColor?.cgColor
                cell?.commentImage.layer.cornerRadius =  cell!.commentImage.frame.size.width/2
                cell?.commentImage.clipsToBounds = true
                
                cell?.content.text = posts[indexPath.row].content
                cell?.userName.text = posts[indexPath.row].firstname + " " + posts[indexPath.row].lastname
                
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                let time = formatter.date(from: posts[indexPath.row].createat)
                formatter.dateFormat = "h:mm a "
                formatter.amSymbol = "am"
                formatter.pmSymbol = "pm"
                let stringTime = formatter.string(from: time!)
                
                cell?.createTime.text = stringTime
                cell?.commentText.text = posts[indexPath.row].comment
                cell?.commentText.delegate = self
                cell?.commentText.tag = indexPath.row
                cell?.commentcnt.text = "\(posts[indexPath.row].commentcounts)"
                cell?.likecnt.text = "\(posts[indexPath.row].likecounts)"
                cell?.likebtn.tag = indexPath.row
                cell?.likebtn.addTarget(self, action: #selector(self.postLike(_:)), for: .touchUpInside)
                cell?.content.text = "Is feeling - "
                cell?.commentbtn.tag = indexPath.row
                cell?.commentbtn.addTarget(self, action: #selector(self.viewCommentMood(_:)), for: .touchUpInside)
                cell?.moodText.textColor = UIColor.init(hex: DataUtils.getEndColor()!)
                switch(posts[indexPath.row].moodstate)
                {
                case "1":
                    cell?.moodText.text = "Very Sad"
                    cell?.moodImage.image = UIImage.init(named: "Group 1069")
                case "2":
                    cell?.moodText.text = "Sad"
                    cell?.moodImage.image = UIImage.init(named: "Group 1070")
                case "3":
                    cell?.moodText.text = "Neutral"
                    cell?.moodImage.image = UIImage.init(named: "Group 1071")
                case "4":
                    cell?.moodText.text = "Happy"
                    cell?.moodImage.image = UIImage.init(named: "Group 1072")
                case "5":
                    cell?.moodText.text = "Very Happy"
                    cell?.moodImage.image = UIImage.init(named: "Group 1073")
                default:
                    break
                }
                
                cell?.onlypictures.dataSource = self
                //cell?.onlypictures.delegate = self
                cell?.onlypictures.gap = 28
                cell?.onlypictures.layer.cornerRadius = 18
                cell?.onlypictures.spacingColor = .white
                cell?.onlypictures.alignment = .left
                if posts[indexPath.row].pictures.count == 0
                {
                    cell?.onlypictures.isHidden = true
                }
                else {
                    self.getUserPictures(postIndex: indexPath.row, onlyPictures: cell!.onlypictures)
                }
                return cell!
                
            }
        }
        return tableView.dequeueReusableCell(withIdentifier: "CallTableViewCell", for: indexPath) as! CallTableViewCell
    }
    
    func getUserPictures(postIndex:Int, onlyPictures:OnlyHorizontalPictures) {
        self.userPictureIndex = postIndex
        
        userimages = []
        
        for i in 0 ..< posts[postIndex].pictures.count
        {
            var j = 0
            while(j < userimages.count)
            //for j in 0 ..< userimages.count
            {
                if userimages[j] == posts[postIndex].pictures[i]
                {
                    break
                }
                else {
                    j += 1
                    continue
                }
            }
            if j == userimages.count
            {
                userimages.append(posts[postIndex].pictures[i])
            }
        }
        onlyPictures.reloadData()
        onlyPictures.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let tag = textField.tag
        posts[tag].comment = textField.text!
        feedtableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let tag = textField.tag
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone.current
        let currentDate = formatter.string(from: currentDateTime)
        let params = [
            "userid" : PreferenceHelper().getId(),
            "postid" : posts[tag].postid,
            "content" : textField.text!,
            "choice" : "2",
            "createat" : currentDate
            ] as [String : Any]        
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        Alamofire.request(DataUtils.APIURL + DataUtils.COMMUNITYPOST_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                
                debugPrint(response);
                
                if let data = response.result.value {
                    print("JSON: \(data)")
                    let json : [String:Any] = data as! [String : Any]
                    //let statusMsg: String = json["status_msg"] as! String
                    //self.showResultMessage(statusMsg)
                    //self.showGraph(json)
                    let result = json["status"] as? String
                    if result == "true"
                    {
                        self.posts[tag].commentcounts += 1
                        self.posts[tag].comment = ""
                        self.posts[tag].pictures.append(PreferenceHelper().getUserImage()!)
                        self.feedtableView.reloadData()
                    }
                    else
                    {
                        let message = json["message"] as! String
                        DataUtils.messageShow(view: self, message: message, title: "")
                    }
                }
            })
        return true
        
    }
    
    @objc func postData(gesture: UIGestureRecognizer) {
        let viewcontroller = (UIStoryboard(name: "Community", bundle: nil).instantiateViewController(withIdentifier: "PostMessageViewController") as! PostMessageViewController)
        viewcontroller.viewIndex = 4
        viewcontroller.communityUsers = self.communityUsers
        present(viewcontroller, animated: false, completion: nil)
    }
    @objc private func addPost(_ sender:UIButton) {
        // your code goes here
        let tag = sender.tag
        
        let viewcontroller = (UIStoryboard(name: "Community", bundle: nil).instantiateViewController(withIdentifier: "PostMessageViewController") as! PostMessageViewController)
        viewcontroller.viewIndex = tag
        viewcontroller.communityUsers = self.communityUsers
        present(viewcontroller, animated: false, completion: nil)
        
    }
    
    @objc private func playVideo(_ sender:UIButton) {
        let tag = sender.tag
        let url = URL(string: DataUtils.VIDEOURL + posts[tag].filename)!
        let playerVC = AVPlayerViewController()
        let player = AVPlayer(playerItem: AVPlayerItem(url:url))
        playerVC.player = player
        self.present(playerVC, animated: true, completion: nil)
    }
    
    @objc private func viewComment(_ sender:UIButton) {
        let tag = sender.tag
        if posts[tag].commentcounts == 0
        {
            return
        }
        let viewcontroller = (UIStoryboard(name: "Community", bundle: nil).instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController)
        viewcontroller.postId = posts[tag].postid
        viewcontroller.getCommentData()
        present(viewcontroller, animated: false, completion: nil)
    }
    
    @objc private func viewCommentMood(_ sender:UIButton) {
        let tag = sender.tag
        if posts[tag].commentcounts == 0
        {
            return
        }
        let viewcontroller = (UIStoryboard(name: "Community", bundle: nil).instantiateViewController(withIdentifier: "CommentMoodViewController") as! CommentMoodViewController)
        viewcontroller.postId = posts[tag].postid
        viewcontroller.getCommentData()
        present(viewcontroller, animated: false, completion: nil)
    }
    
    @objc private func postLike(_ sender:UIButton) {
        let tag = sender.tag
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone.current
        let currentDate = formatter.string(from: currentDateTime)
        let params = [
            "userid" : PreferenceHelper().getId(),
            "postid" : posts[tag].postid,
            "choice" : "3",
            "createat" : currentDate
            ] as [String : Any]
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        Alamofire.request(DataUtils.APIURL + DataUtils.COMMUNITYPOST_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                
                debugPrint(response);
                
                if let data = response.result.value {
                    print("JSON: \(data)")
                    let json : [String:Any] = data as! [String : Any]
                    //let statusMsg: String = json["status_msg"] as! String
                    //self.showResultMessage(statusMsg)
                    //self.showGraph(json)
                    let result = json["status"] as? String
                    if result == "true"
                    {
                        self.posts[tag].likecounts += 1
                        self.feedtableView.reloadData()
                    }
                    else
                    {
                        let message = json["message"] as! String
                        DataUtils.messageShow(view: self, message: message, title: "")
                    }
                }
            })
    }
    
    func createThumbnailOfVideoFromRemoteUrl(url: String) -> UIImage? {
        let asset = AVAsset(url: URL(string: url)!)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        //Can set this to improve performance if target size is known before hand
        //assetImgGenerate.maximumSize = CGSize(width,height)
        //let time = CMTimeMakeWithSeconds(1.0, 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            imageCache.setObject(thumbnail, forKey: url as NSString)
            return thumbnail
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if selectedUser == 0
        {
            if posts[indexPath.row].posttype == "calluser"//.calluser
            {
                return 70
            }
            else if posts[indexPath.row].posttype == "message"//.message
            {
                return 210
            }
            else if posts[indexPath.row].posttype == "question"//.question
            {
                return 180
            }
            else if posts[indexPath.row].posttype == "postmessage"//.postmessage
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell
                
            }
            else if posts[indexPath.row].posttype == "photo1"//.image
            {
                return 300
            }
            
        }
        else{
            if posts[indexPath.row].posttype == "calluser"//.calluser
            {
                return 70
            }
            else if posts[indexPath.row].posttype == "message"//.message
            {
                return 210
            }
            else if posts[indexPath.row].posttype == "question"//.question
            {
                return 180
            }
            else if posts[indexPath.row].posttype == "postmessage"//.postmessage
            {
                return 210
            }
            else if posts[indexPath.row].posttype == "image"//.image
            {
                return 300
            }
            else
            {
                return 210
            }
        }
        
        
        if posts[indexPath.row].posttype == "postmessage"//.postmessage
        {
            return 210
            
        }
        else
        {
            return 400//posts[indexPath.row].height//UITableViewAutomaticDimension
        }
    }
 
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 400
    }
    */
    
 
    
}

extension FeedViewController : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Feed")
    }
}

extension FeedViewController: OnlyPicturesDataSource {
    
    // ---------------------------------------------------
    // returns the total no of pictures
    
    func numberOfPictures() -> Int {
        return userimages.count//posts[userPictureIndex].pictures.count//pictures.count
    }
    
    // ---------------------------------------------------
    // returns the no of pictures should be visible in screen.
    // In above preview, Left & Right formats are example of visible pictures, if you want pictures to be shown without count, remove this function, it's optional.
    
    func visiblePictures() -> Int {
        return 5
    }
    
    
    // ---------------------------------------------------
    // return the images you want to show. If you have URL's for images, use next function instead of this.
    // use .defaultPicture property to set placeholder image. This only work with local images. for URL's images we provided imageView instance, it's your responsibility to assign placeholder image in it. Check next function.
    // onlyPictures.defaultPicture = #imageLiteral(resourceName: "defaultProfilePicture")
    /*
    func pictureViews(index: Int) -> UIImage {
        return UIImage(named: posts[userPictureIndex].pictures[index])!//pictures[index]
    }
    */
    
    // ---------------------------------------------------
    // If you do have URLs of images. Use below function to have UIImageView instance and index insted of 'pictureViews(index: Int) -> UIImage'
    // NOTE: It's your resposibility to assign any placeholder image till download & assignment completes.
    // I've used AlamofireImage here for image async downloading, assigning & caching, Use any library to allocate your image from url to imageView.
    
    func pictureViews(_ imageView: UIImageView, index: Int) {
        
        
        
        // Use 'index' to receive specific url from your collection. It's similar to indexPath.row in UITableView.
        if userimages[index] != "" //posts[userPictureIndex].pictures[index] != ""
        {
            let url = URL(string: DataUtils.PROFILEURL + userimages[index])
            //imageView.image = #imageLiteral(resourceName: "defaultProfilePicture")   // placeholder image
            //imageView.af_setImage(withURL: url!)
            imageView.kf.setImage(with: url)
        }
        else {
            let image = UIImage(named: "Intersection 1")
            imageView.image = image
            //imageView.contentMode = .center
        }
        
    }
}
