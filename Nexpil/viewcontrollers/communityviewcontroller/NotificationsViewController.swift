//
//  NotificationsViewController.swift
//  Nexpil
//
//  Created by Admin on 4/9/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import XLPagerTabStrip
import Alamofire

class NotificationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var notificationtableView: UITableView!
    var delegate: CommunitySubMenuDelegate?
    var selectedUser: Int = 0
    var startColor:String?
    var endColor:String?
    var selectedUserid: Int = 0
    var notifications:[NotificationEntity] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        notificationtableView.backgroundColor = nil
        notificationtableView.rowHeight = UITableViewAutomaticDimension
        notificationtableView.estimatedRowHeight = 150
        notificationtableView.separatorStyle = UITableViewCellSeparatorStyle.none
        notificationtableView.allowsSelection = false
        notificationtableView.alwaysBounceVertical = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        (selectedUser,selectedUserid) = (delegate?.selectDay(value: 1))!
        showData()
    }

    func showData()
    {
        //notificationtableView.reloadData()
        //if selectedUser is 0 then they are notifications I sent
        //if selectedUser is not 0 then notification received from them.
        var send = "send"
        var receiverid = 0
        if selectedUser == 0
        {
            send = "receive"
        }
        else {
            send = "send"
            receiverid = selectedUserid
        }
        
        let params = [
            "userid" : PreferenceHelper().getId(),
            "send" :send,
            "receiverid":receiverid,
            "choice" : "0"
            
            ] as [String : Any]
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        Alamofire.request(DataUtils.APIURL + DataUtils.COMMUNITYNOTIFICATION_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                self.notifications.removeAll()
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
                        let users = json["data"] as? [[String:Any]]
                        for user in users!
                        {
                            let post = NotificationEntity.init(json: user)
                            self.notifications.append(post)
                        }
                    }
                    else
                    {
                        let message = json["message"] as! String
                        DataUtils.messageShow(view: self, message: message, title: "")
                    }
                    self.notificationtableView.reloadData()
                }
            })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as? NotificationTableViewCell
        //cell?.userphoto.image = UIImage(named: "james")
        cell?.userName.text = notifications[indexPath.row].firstname + " " + notifications[indexPath.row].lastname
        let url = URL(string: DataUtils.PROFILEURL + notifications[indexPath.row].userimage)
        cell?.userphoto.kf.setImage(with: url)
        cell?.content.text = notifications[indexPath.row].notification
        cell?.time.text = notifications[indexPath.row].createat
        cell?.userphoto.layer.masksToBounds = false
        cell?.userphoto.layer.borderWidth = 0.0
        cell?.userphoto.layer.cornerRadius =  (cell?.userphoto.frame.size.height)!/2        
        cell?.userphoto.clipsToBounds = true
        return cell!
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

extension NotificationsViewController : IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Notifications")
    }
}
