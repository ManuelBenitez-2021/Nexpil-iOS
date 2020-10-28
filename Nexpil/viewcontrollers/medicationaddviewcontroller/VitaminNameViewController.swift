//
//  VitaminNameViewController.swift
//  Nexpil
//
//  Created by Admin on 5/7/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class VitaminNameViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ShadowDelegate {
    
    

    @IBOutlet weak var medicationName: UITextField!
    
    @IBOutlet weak var txtView: UIView!
    
    @IBOutlet weak var searchTable: UITableView!
    
    let cellReuseIdentifier = "cell"
    var results = [DrugName]()
    
    var visualEffectView:VisualEffectView?
    
    @IBOutlet weak var backBtn: GradientView!
    @IBOutlet weak var nextBtn: GradientView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //medicationName.titleFormatter = { $0 }
        //self.hideKeyboardWhenTappedAround1()
        
        txtView.viewShadow()
        
        self.searchTable.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        medicationName.addTarget(self, action: #selector(updateText), for: UIControlEvents.editingChanged)
        medicationName.spellCheckingType = .no
        
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.gotoNext1))
        nextBtn.addGestureRecognizer(gesture2)
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(self.gotoBack))
        backBtn.addGestureRecognizer(gesture1)
        visualEffectView = self.view.backgroundBlur(view: self.view)
    }
    
    func removeShadow() {
        visualEffectView!.removeFromSuperview()
    }
    
    @objc func gotoBack(sender : UITapGestureRecognizer) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.vitaminPageViewController?.pageControl.currentPage = 0
        appDelegate.vitaminPageViewController?.gotoPage()
    }
    
    @objc func gotoNext1(sender : UITapGestureRecognizer) {
        if medicationName.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input name", title: "")
            return
        }
        for drug in results
        {
            if drug.DrugName.lowercased() == medicationName.text?.lowercased()
            {
                DataUtils.setMedicationName(name: medicationName.text!)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.vitaminPageViewController?.pageControl.currentPage = 2
                appDelegate.vitaminPageViewController?.gotoPage()
            }
        }
        DataUtils.messageShow(view: self, message: "Please select correct name", title: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        searchTable.isHidden = true
    }

    @IBAction func closeWindow(_ sender: Any) {
        self.view.addSubview(visualEffectView!)
        /*
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         appDelegate.pageViewController?.closePageViewController()
         */
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CloseAddMedicationViewController") as! CloseAddMedicationViewController
        viewController.modalPresentationStyle = .overCurrentContext
        //viewController.delegate = self
        present(viewController, animated: false, completion: nil)
    }
    @IBAction func gotoBack(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.vitaminPageViewController?.pageControl.currentPage = 0
        appDelegate.vitaminPageViewController?.gotoPage()
        
    }
    @IBAction func gotoNext(_ sender: Any) {
        
        if medicationName.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input name", title: "")
            return
        }
        DataUtils.setMedicationName(name: medicationName.text!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.vitaminPageViewController?.pageControl.currentPage = 2
        appDelegate.vitaminPageViewController?.gotoPage()
        
    }
    
    @IBAction func keyboardHide(_ sender: Any) {
        medicationName.resignFirstResponder()
        searchTable.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = results[indexPath.row].DrugName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let str = results[indexPath.row].DrugName.lowercased()
        medicationName.text = str.prefix(1).uppercased() + str.dropFirst()        
        self.searchTable.isHidden = true
        DataUtils.setDrugId(drugid: results[indexPath.row].uid)
    }
    
    @objc func updateText() {
        let text = medicationName.text ?? ""
        if text != ""
        {
            self.results.removeAll()
            searchTable.reloadData()
            searchTable.isHidden = false
            getSuggestions(term: text)
        }
    }
    
    func getSuggestions(term: String) {
        //let urlString = "http://ec2-54-162-72-84.compute-1.amazonaws.com/complete.php?Name=\(term)"
        //let urlString = DataUtils.DRUGNAME_URL + "?Name=\(term)"
        self.results.removeAll()
        let urlString = DataUtils.APIURL + DataUtils.PRODUCT_URL + "?Name=\(term)&choice=0"
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: { [unowned self] (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            let decoder = JSONDecoder()
            self.results = try! decoder.decode([DrugName].self, from: data)
            
            DispatchQueue.main.async { [unowned self] in
                self.searchTable.reloadData()
            }
        })
        task.resume()
    }
    func hideKeyboardWhenTappedAround1() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ThirdMedicationAddViewController.dismissKeyboard1))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard1() {
        view.endEditing(true)
        searchTable.isHidden = true
    }
}
