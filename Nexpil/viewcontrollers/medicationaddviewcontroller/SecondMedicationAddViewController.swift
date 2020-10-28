//
//  SecondMedicationAddViewController.swift
//  Nexpil
//
//  Created by Admin on 4/8/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import SkyFloatingLabelTextField

class SecondMedicationAddViewController: UIViewController,ReceiveMedicalDelegate,UITableViewDataSource,UITableViewDelegate {
    func getMedicalData(_: [[String : Any]]) {
        //display Medical Data
        
    }
    

    @IBOutlet weak var pharmacy: SkyFloatingLabelTextField!
    @IBOutlet weak var txtView: UIView!
    @IBOutlet weak var searchTable: UITableView!
    
    let cellReuseIdentifier = "cell"
    var results1 = ["Costco","CVS Pharmacy","Pharmacy of Dupage","Rite-aid","Sams Club","Walgreens","Walmart"]
    var results = [String]()    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pharmacy.titleFormatter = { $0 }
        //self.hideKeyboardWhenTappedAround1()
        
        txtView.viewShadow()
        
        self.searchTable.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        pharmacy.addTarget(self, action: #selector(updateText), for: UIControlEvents.editingChanged)
        pharmacy.spellCheckingType = .no
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchTable.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        /*
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.closePageViewController()
        */
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CloseAddMedicationViewController") as! CloseAddMedicationViewController
        present(viewController, animated: false, completion: nil)
    }
    
    @IBAction func gotoBack(_ sender: Any) {
        /*
        let preference: PreferenceHelper = PreferenceHelper()
        if preference.getUserType() != nil
        {
            if preference.getUserType()! == "" || preference.getUserType()! == "caregiver"
            {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.pageViewController?.pageControl.currentPage = 1
                appDelegate.pageViewController?.gotoPage()
            }
            else {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.pageViewController?.pageControl.currentPage = 0
                appDelegate.pageViewController?.gotoPage()
            }
        }
        else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.pageViewController?.pageControl.currentPage = 1
            appDelegate.pageViewController?.gotoPage()
        }
        */
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = 5
        appDelegate.pageViewController?.gotoPage()
    }
    @IBAction func gotoNext(_ sender: Any) {
        /*
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThirdMedicationAddViewController") as! ThirdMedicationAddViewController
        present(viewController, animated: false, completion: nil)
        */
        
        if pharmacy.text!.isEmpty {
            DataUtils.messageShow(view: self, message: "Please input pharmacy", title: "")
            return
        }
        DataUtils.setPharmacyName(pharmacy: pharmacy.text!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = 7
        appDelegate.pageViewController?.gotoPage()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = results[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pharmacy.text = results[indexPath.row]
        self.searchTable.isHidden = true
    }
    
    @IBAction func keyboardHidden(_ sender: Any) {
        pharmacy.resignFirstResponder()
        searchTable.isHidden = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func updateText() {
        let text = pharmacy.text ?? ""
        if text != ""
        {
            searchTable.isHidden = false
            getSuggestions(term: text)
        }
    }
    
    func getSuggestions(term: String) {
        results.removeAll()
        for obj in results1
        {
            if obj.lowercased().range(of:term.lowercased()) != nil {
                results.append(obj)
            }
        }
        searchTable.reloadData()
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
