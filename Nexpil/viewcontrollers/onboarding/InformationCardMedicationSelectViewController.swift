//
//  InformationCardMedicationSelectViewController.swift
//  Nexpil
//
//  Created by Admin on 21/11/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import UIKit
import IQKeyboardManagerSwift

class InformationCardMedicationSelectViewController: UIViewController,ShadowDelegate1,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var medicationNameCard: InformationCardEditable!
    @IBOutlet weak var doneButton: NPButton!
    @IBOutlet weak var imageHelp: UIImageView!
    @IBOutlet weak var doneButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var labelTopHeight: NSLayoutConstraint!
    
    let center = NotificationCenter.default
    var keyboardHeight: CGFloat?
    var originalHeight: CGFloat?
    var originalTopHeight: CGFloat?
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var searchTable: UITableView!
    let cellReuseIdentifier = "cell"
    
    @IBOutlet weak var shadowView: UIView!
    var results = [DrugName]()
    
    var visualEffectView:VisualEffectView?
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        if self.medicationNameCard.textView.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input medication name", title: "")
            return
        }
        DispatchQueue.main.async { [unowned self] in
            //self.summaryPage?.prescription?.drug.name = self.medicationName
            //self.summaryPage?.medicationCard.valueText = self.medicationName
            //self.summaryPage?.medicationCard.view.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6.0)
            //self.navigationController?.popViewController(animated: true)
            DataUtils.setMedicationName(name: self.medicationNameCard.textView.text!)
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let medicationController = storyBoard.instantiateViewController(withIdentifier: "InformationCardEditDosageViewController") as! InformationCardEditDosageViewController
            self.navigationController?.pushViewController(medicationController, animated: true)
        }
    }
    /*
    var medicationName: String {
        get {
            let medicationName = self.medicationNameCard.textView.text ?? ""
            return medicationName.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    */
    
    override func viewDidLoad() {        
        //self.doneButtonConstraint = doneButtonBottomConstraint
        super.viewDidLoad()
        
        let backImage = UIImage(named: "Back")
        let closeImage = UIImage(named:"Closebutton")?.withRenderingMode(.alwaysOriginal)
        let logoImage = UIImage(named: "Progress Bar1")
        self.navigationItem.titleView = UIImageView(image: logoImage)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: navigationController, action: #selector(UINavigationController.popViewController(animated:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: closeImage, style: .done, target: self, action: #selector(self.showCloseAddMedicationCardViewController))
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        
        originalHeight = doneButtonBottomConstraint.constant
        visualEffectView = self.view.backgroundBlur(view: self.view)
        originalTopHeight = labelTopHeight.constant
        
        //self.medicationNameCard.textView.placeholder = "Glipizide"
        self.searchTable.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        medicationNameCard.textView.addTarget(self, action: #selector(updateText), for: UIControlEvents.editingChanged)
        self.searchTable.tableFooterView = UIView()
        self.searchTable.alwaysBounceVertical = false
        shadowView.clipsToBounds = false
        shadowView.layer.cornerRadius = 20
        shadowView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        shadowView.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6)
        searchTable.layer.cornerRadius = 20
        searchTable.layer.masksToBounds = true
        visualEffectView = self.view.backgroundBlur(view: self.view)
        medicationNameCard.textView.autocorrectionType = .no
        medicationNameCard.textView.placeholder = "Glipizide doesn’t need to be printed there …"
        medicationNameCard.textView.font = UIFont(name:"Montserrat Medium",size:12)
        medicationNameCard.textView.text = ""
    }
    override func viewDidAppear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enable = false
        center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.medicationNameCard.valueText = DataUtils.getMedicationName()!
        self.searchTable.isHidden = true
        shadowView.isHidden = true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.font = UIFont(name:"Montserrat Medium",size:16)
        cell.textLabel?.text = results[indexPath.row].DrugName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let str = results[indexPath.row].DrugName.lowercased()
        medicationNameCard.textView.text = str.prefix(1).uppercased() + str.dropFirst()
        self.searchTable.isHidden = true
        shadowView.isHidden = true
    }
    /*
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //or
        //self.view.endEditing(true)
        imageHeight.constant = 272
        searchTable.isHidden = true
        return true
    }
    */
    /*
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        imageHeight.constant = 0
        return true
    }
    */
    @objc func updateText() {
        let text = medicationNameCard.textView.text ?? ""
        if text != ""
        {
            self.results.removeAll()
            searchTable.reloadData()
            searchTable.isHidden = false
            shadowView.isHidden = false
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
    override func viewDidDisappear(_ animated: Bool) {
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        IQKeyboardManager.sharedManager().enable = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillDisappear(animated)
        
        medicationNameCard.textView.resignFirstResponder()
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification)
    {
        
        keyboardHeight = (notification.userInfo?["UIKeyboardBoundsUserInfoKey"] as! CGRect).height
        doneButtonBottomConstraint.constant = self.originalHeight! + self.keyboardHeight!
        imageHeight.constant = 10
        imageHelp.isHidden = true
        labelTopHeight.constant = 30
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        doneButtonBottomConstraint.constant = self.originalHeight!
        imageHeight.constant = 272
        searchTable.isHidden = true
        shadowView.isHidden = true
        imageHelp.isHidden = false
        labelTopHeight.constant = originalTopHeight!
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    @objc func showCloseAddMedicationCardViewController()
    {
        self.view.addSubview(visualEffectView!)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CloseAddMedicationViewController") as! CloseAddMedicationViewController
        //viewController.tabBar.roundCorners([.topLeft, .topRight], radius: 10)
        viewController.delegate = self
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: false, completion: nil)
    }
    func removeShadow(root: Bool) {
        visualEffectView?.removeFromSuperview()
        if root == true
        {
            navigationController?.popToRootViewController(animated: false)
        }
    }
}
