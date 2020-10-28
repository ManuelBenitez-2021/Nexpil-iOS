//
//  ThirdMedicationAddViewController.swift
//  Nexpil
//
//  Created by Admin on 4/8/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import SkyFloatingLabelTextField

class ThirdMedicationAddViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ShadowDelegate {
    
    

    @IBOutlet weak var medicationName: UITextField!
    
    @IBOutlet weak var txtView: UIView!
    @IBOutlet weak var helpview: GradientView!
    @IBOutlet weak var searchTable: UITableView!
    
    @IBOutlet weak var backBtn: GradientView!
    
    @IBOutlet weak var nextBtn: GradientView!
    let cellReuseIdentifier = "cell"
    var results = [DrugName]()
    
    
    var visualEffectView:VisualEffectView?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //medicationName.titleFormatter = { $0 }
        //self.hideKeyboardWhenTappedAround1()
        
        txtView.viewShadow()
        
        self.searchTable.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        medicationName.addTarget(self, action: #selector(updateText), for: UIControlEvents.editingChanged)
        medicationName.spellCheckingType = .no
        
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
        if medicationName.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input medication name", title: "")
            return
        }
        
        for drug in results
        {
            if drug.DrugName.lowercased() == medicationName.text?.lowercased()
            {
                DataUtils.setMedicationName(name: medicationName.text!)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage + 1 //2
                appDelegate.pageViewController?.gotoPage()
            }
        }
        DataUtils.messageShow(view: self, message: "Please select corrrect name", title: "")
        
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
        self.view.addSubview(visualEffectView!)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CloseAddMedicationViewController") as! CloseAddMedicationViewController
        //viewController.delegate = self
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: false, completion: nil)
    }
    @IBAction func gotoBack(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage - 1
        appDelegate.pageViewController?.gotoPage()
        
    }
    @IBAction func gotoNext(_ sender: Any) {
        
        if medicationName.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input medication name", title: "")
            return
        }
        DataUtils.setMedicationName(name: medicationName.text!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage + 1 //2
        appDelegate.pageViewController?.gotoPage()
        
    }
    
    @IBAction func keyboardHide(_ sender: Any) {
        medicationName.resignFirstResponder()
        searchTable.isHidden = true
    }
    @objc func showImage(sender : UITapGestureRecognizer) {
        self.view.addSubview(visualEffectView!)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HelpImageViewController") as! HelpImageViewController
        viewController.imageName = "board_1_prescript.png"//"medicationnamehelp.png"
        viewController.delegate = self
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: false, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
