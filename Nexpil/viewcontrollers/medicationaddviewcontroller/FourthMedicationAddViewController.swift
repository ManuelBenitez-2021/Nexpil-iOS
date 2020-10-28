//
//  FourthMedicationAddViewController.swift
//  Nexpil
//
//  Created by Admin on 4/8/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class FourthMedicationAddViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ShadowDelegate {
    
    
    
    var selectedindex = -1
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var qualitySelect: UITableView!
    
    @IBOutlet weak var backBtn: GradientView!
    @IBOutlet weak var nextBtn: GradientView!
    
    var myItem = [String]()
    var results = [DrugProductInfo]()
    @IBOutlet weak var helpview: GradientView!
    
    var visualEffectView:VisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        qualitySelect.separatorStyle = .none
        qualitySelect.alwaysBounceVertical = false
        //qualitySelect.allowsSelection = false
        qualitySelect.backgroundColor = nil
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.showImage))
        helpview.layer.cornerRadius = 10.0
        helpview.layer.masksToBounds = true
        helpview.addGestureRecognizer(gesture)
        
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.gotoNext1))
        nextBtn.addGestureRecognizer(gesture2)
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(self.gotoBack))
        backBtn.addGestureRecognizer(gesture1)
        visualEffectView = self.view.backgroundBlur(view: self.view)
    }
    
    func removeShadow() {
        visualEffectView?.removeFromSuperview()
    }
    
    @objc func gotoBack(sender : UITapGestureRecognizer) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage - 1
        appDelegate.pageViewController?.gotoPage()
    }
    
    @objc func gotoNext1(sender : UITapGestureRecognizer) {
        if selectedindex == -1
        {
            DataUtils.messageShow(view: self, message: "Please select strength", title: "")
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage + 1//3
        appDelegate.pageViewController?.gotoPage()
    }

    override func viewDidAppear(_ animated: Bool) {
        let medicationname = DataUtils.getMedicationName() ?? ""
        nameLabel.text = "What's the strength of your " + medicationname + "?"
        
        
        selectedindex = -1
        goProductInfo()
    }
    
    func showDrugStrength()
    {
        myItem.removeAll()
        var myItems1 = [String]()
        for data in results
        {
            let data1 = data.Strength.components(separatedBy: ";")
            for data2 in data1
            {
                //myItem.append(data2)
                myItems1.append(data2)
            }
        }
        /*
        myItem = myItems1.sorted() {
            $0 < $1
            //Int($0.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())! < Int($1.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())!
        }
        */
        
        for index1 in 0 ..< myItems1.count - 1
        {
            for index2 in index1 + 1 ..< myItems1.count
            {
                var num1 = myItems1[index1].trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted)//myItems1[index1].components(separatedBy: CharacterSet.alphanumerics).joined()
                num1 = num1.replacingOccurrences(of: ",", with: "")
                var num2 = myItems1[index2].trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted)
                num2 = num2.replacingOccurrences(of: ",", with: "")
                if Float(num1)! > Float(num2)!
                {
                    let temp = myItems1[index1]
                    myItems1[index1] = myItems1[index2]
                    myItems1[index2] = temp
                }
            }
        }
        
        myItem = myItems1
        qualitySelect.reloadData()
    }
    
    func goProductInfo() {
        self.results.removeAll()
        let urlString = DataUtils.APIURL + DataUtils.PRODUCT_URL + "?name=\(DataUtils.getMedicationName()!)&choice=1"
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: { [unowned self] (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            let decoder = JSONDecoder()
            self.results = try! decoder.decode([DrugProductInfo].self, from: data)
            
            DispatchQueue.main.async { [unowned self] in
                self.showDrugStrength()
            }
        })
        task.resume()
    }  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        self.view.addSubview(visualEffectView!)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CloseAddMedicationViewController") as! CloseAddMedicationViewController
        //viewController.delegate = self
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: false, completion: nil)
    }
    
    @objc func showImage(sender : UITapGestureRecognizer) {
        self.view.addSubview(visualEffectView!)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HelpImageViewController") as! HelpImageViewController
        viewController.imageName = "board_2_strength_prescript.png"//"glipizidehelpimage.png"
        viewController.delegate = self
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: false, completion: nil)
    }
    @IBAction func gotoBack(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage - 1
        appDelegate.pageViewController?.gotoPage()
        
    }
    @IBAction func gotoNext(_ sender: Any) {
        
        if selectedindex == -1
        {
            DataUtils.messageShow(view: self, message: "Please select strength", title: "")
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage + 1//3
        appDelegate.pageViewController?.gotoPage()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrugQualityCell", for: indexPath) as! DrugQualityCell
        cell.quality.text = myItem[indexPath.row]
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.init(hex: "f7f7fa")
        if indexPath.row == selectedindex
        {
            
            cell.background.viewUnShadow()
            cell.quality.textColor = UIColor.white
            cell.background.backgroundColor = UIColor.init(hex: "39d3e3")
            cell.checkImage.isHidden = true
        }
        else {
            cell.background.backgroundColor = UIColor.white
            cell.background.viewShadow()
            cell.quality.textColor = UIColor.init(hex: "333333")
            
            cell.checkImage.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedindex = indexPath.row
        DataUtils.setMedicationStrength(name: myItem[indexPath.row])
        qualitySelect.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
