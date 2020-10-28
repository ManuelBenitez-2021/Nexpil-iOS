//
//  VitaminQuantityViewController.swift
//  Nexpil
//
//  Created by Admin on 5/7/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField


class VitaminQuantityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ShadowDelegate {
    
    
    
    

    
    @IBOutlet weak var qualitySelect: UITableView!
    var selectedindex = -1
    @IBOutlet weak var nameLabel: UILabel!
    
    var results = [DrugProductInfo]()
    @IBOutlet weak var backBtn: UIView!
    @IBOutlet weak var nextBtn: GradientView!
    var myItem = [String]()
    
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var quantity: UITextField!
    
    var visualEffectView:VisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        qualitySelect.separatorStyle = .none
        qualitySelect.alwaysBounceVertical = false
        //qualitySelect.allowsSelection = false
        qualitySelect.backgroundColor = nil
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.gotoNext1))
        nextBtn.addGestureRecognizer(gesture2)
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(self.gotoBack))
        backBtn.addGestureRecognizer(gesture1)
        
        myItem.append("60 Tablets")
        myItem.append("100 Tablets")
        myItem.append("200 Tablets")
        qualitySelect.reloadData()
        textView.viewShadow()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(VitaminQuantityViewController.dismissKeyboard1))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        visualEffectView = self.view.backgroundBlur(view: self.view)
    }
    
    @objc func dismissKeyboard1() {
        view.endEditing(true)
        if quantity.text! != ""
        {
            DataUtils.setStartTablet(name: quantity.text!)
            selectedindex = -1
            qualitySelect.reloadData()
        }
    }
    
    func removeShadow() {
        visualEffectView?.removeFromSuperview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        selectedindex = -1
        //goProductInfo()
    }
    
    func showDrugStrength()
    {
        myItem.removeAll()
        for data in results
        {
            let data1 = data.Strength.components(separatedBy: ";")
            for data2 in data1
            {
                myItem.append(data2)
            }
        }
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
    
    @objc func gotoBack(sender : UITapGestureRecognizer) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.vitaminPageViewController?.pageControl.currentPage = 1
        appDelegate.vitaminPageViewController?.gotoPage()
    }
    
    @objc func gotoNext1(sender : UITapGestureRecognizer) {
        
        if selectedindex == -1 && quantity.text == ""
        {
            DataUtils.messageShow(view: self, message: "Please select or input quantity", title: "")
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.vitaminPageViewController?.pageControl.currentPage = 3
        appDelegate.vitaminPageViewController?.gotoPage()
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
        self.view.addSubview(visualEffectView!)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CloseAddMedicationViewController") as! CloseAddMedicationViewController
        //viewController.delegate = self
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: false, completion: nil)
    }
    
    
    @IBAction func gotoBack(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.vitaminPageViewController?.pageControl.currentPage = 1
        appDelegate.vitaminPageViewController?.gotoPage()
        
    }
    @IBAction func gotoNext(_ sender: Any) {
        
        if selectedindex == -1
        {
            DataUtils.messageShow(view: self, message: "Please select quantity", title: "")
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.vitaminPageViewController?.pageControl.currentPage = 3
        appDelegate.vitaminPageViewController?.gotoPage()
        
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
        DataUtils.setStartTablet(name: myItem[indexPath.row].components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
        qualitySelect.reloadData()
        quantity.text = ""
    }
    
    /*
    func didSelectRowAt(indexPath: IndexPath) {
        selectedindex = indexPath.row
        print("item at index \(indexPath.row) selected")        
        DataUtils.setStartTablet(name: myItem[indexPath.row].title)
    }
    */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
