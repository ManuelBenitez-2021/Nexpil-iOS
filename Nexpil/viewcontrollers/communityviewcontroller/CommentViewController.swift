//
//  CommentViewController.swift
//  Nexpil
//
//  Created by Admin on 02/07/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import OnlyPictures
import Alamofire

import AVFoundation
import AVKit

class CommentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var playbtn: UIButton!
    @IBOutlet weak var commentCnt: UILabel!
    @IBOutlet weak var commentUsers: OnlyHorizontalPictures!
    @IBOutlet weak var commentTableView: UITableView!
    
    @IBOutlet weak var content: UILabel!
    var postId = 0
    var comments:[CommentData] = []
    let imageCache = NSCache<NSString, UIImage>()
    var filename = ""
    var userimages:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        playbtn.isHidden = true
        
        commentUsers.dataSource = self
        //cell?.onlypictures.delegate = self
        commentUsers.gap = 28
        commentUsers.layer.cornerRadius = 18
        commentUsers.spacingColor = .white
        commentUsers.alignment = .left
        
        userImage.layer.masksToBounds = false
        userImage.layer.borderWidth = 0.0
        userImage.layer.cornerRadius =  userImage.frame.size.height/2
        userImage.clipsToBounds = true
        
        commentTableView.rowHeight = UITableViewAutomaticDimension
        commentTableView.estimatedRowHeight = 400
        //commentTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        commentTableView.allowsSelection = false
        commentTableView.alwaysBounceVertical = false
        commentTableView.backgroundColor = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func closeWindow(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func videoPlay(_ sender: Any) {
        
    }
    
    func getCommentData()
    {
        let params = [
            "postid" : postId,
            "choice" : "5"
            
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
                        let data:[String:Any] = json["post"] as! [String:Any]
                        let userimage = (data["userimage"] as! NSString) as String
                        if userimage == ""
                        {
                            let image = UIImage(named: "Intersection 1")
                            self.userImage.contentMode = .bottom
                            self.userImage.image = image
                            self.userImage.contentMode = .scaleAspectFit
                        }
                        else
                        {
                            let url = URL(string: DataUtils.PROFILEURL + userimage)
                            self.userImage.kf.setImage(with: url)
                            
                        }
                        self.userName.text = ((data["firstname"] as! NSString) as String) + " " + ((data["lastname"] as! NSString) as String)
                        let formatter = DateFormatter()
                        formatter.locale = Locale(identifier: "en_US_POSIX")
                        formatter.dateFormat = "yyyy-MM-dd HH:mm"
                        let time = formatter.date(from: ((data["createat"] as! NSString) as String))
                        formatter.dateFormat = "h:mm a "
                        formatter.amSymbol = "am"
                        formatter.pmSymbol = "pm"
                        let stringTime = formatter.string(from: time!)
                        self.time.text = stringTime
                        
                        let posttype = (data["posttype"] as! NSString) as String
                        if posttype == "photo"
                        {
                            let filename = (data["filename"] as! NSString) as String
                            if filename != ""
                            {
                                let url = URL(string: DataUtils.PHOTOURL + filename)
                                
                                
                                self.photo.kf.setImage(with: url)
                            }
                            else {
                                self.imageHeight.constant = 0
                            }
                            self.playbtn.isHidden = true
                        }
                       else if posttype == "video" {
                            self.filename = (data["filename"] as! NSString) as String
                            if let cachedImage = self.imageCache.object(forKey: (DataUtils.VIDEOURL + self.filename) as NSString) {
                                
                                self.photo.image = cachedImage//self.createThumbnailOfVideoFromRemoteUrl(url:DataUtils.VIDEOURL + self.posts[indexPath.row].filename)
                            }
                            else {
                                self.photo.image = self.createThumbnailOfVideoFromRemoteUrl(url:DataUtils.VIDEOURL + self.filename)
                            }
                            self.playbtn.isHidden = false
                            self.playbtn.tag = self.postId
                            self.playbtn.addTarget(self, action: #selector(self.playVideo(_:)), for: .touchUpInside)
                        }
                        self.content.text = (data["content"] as! NSString) as String
                        let datas:[[String:Any]] = json["comments"] as! [[String:Any]]
                        for obj in datas {
                            self.comments.append(CommentData.init(json: obj))
                        }
                        self.commentCnt.text = "\(self.comments.count)"
                        self.sortCommentUserImage()
                        self.commentTableView.reloadData()
                        self.commentUsers.reloadData()
                    }
                    else
                    {
                        let message = json["message"] as! String
                        DataUtils.messageShow(view: self, message: message, title: "")
                    }
                }
            })
    }
    
    func sortCommentUserImage()
    {
        userimages = []
        for i in 0 ..< comments.count
        {
            var j = 0
            while(j < userimages.count)
                //for j in 0 ..< userimages.count
            {
                if userimages[j] == comments[i].userimage
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
                userimages.append(comments[i].userimage)
            }
        }
        //self.commentUsers.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell
        cell?.userimage.layer.masksToBounds = false
        cell?.userimage.layer.cornerRadius = cell!.userimage.frame.size.width/2
        cell?.userimage.clipsToBounds = true
        if comments[indexPath.row].userimage == ""
        {
            let image = UIImage(named: "Intersection 1")
            cell?.userimage.contentMode = .bottom
            cell?.userimage.image = image
            cell?.userimage.contentMode = .scaleAspectFit
        }
        else
        {
            let url = URL(string: DataUtils.PROFILEURL + comments[indexPath.row].userimage)
            cell?.userimage.kf.setImage(with: url)
        }
        cell?.username.text = comments[indexPath.row].firstname + " " + comments[indexPath.row].lastname
        cell?.comment.text = comments[indexPath.row].comment
        
        cell?.preservesSuperviewLayoutMargins = false
        cell?.separatorInset = UIEdgeInsets.zero
        cell?.layoutMargins = UIEdgeInsets.zero
        
        return cell!
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
    
    @objc private func playVideo(_ sender:UIButton) {
        let url = URL(string: DataUtils.VIDEOURL + filename)!
        let playerVC = AVPlayerViewController()
        let player = AVPlayer(playerItem: AVPlayerItem(url:url))
        playerVC.player = player
        self.present(playerVC, animated: true, completion: nil)
    }
}

extension CommentViewController: OnlyPicturesDataSource {
    
    // ---------------------------------------------------
    // returns the total no of pictures
    
    func numberOfPictures() -> Int {
        return userimages.count//comments.count//pictures.count
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
        if userimages[index] != ""
        {
            let url = URL(string: DataUtils.PROFILEURL + userimages[index])
            //imageView.image = #imageLiteral(resourceName: "defaultProfilePicture")   // placeholder image
            //imageView.af_setImage(withURL: url!)
            imageView.kf.setImage(with: url)
        }
        else {
            let image = UIImage(named: "Intersection 1")
            imageView.image = image
            imageView.contentMode = .center
        }
        
    }
}
