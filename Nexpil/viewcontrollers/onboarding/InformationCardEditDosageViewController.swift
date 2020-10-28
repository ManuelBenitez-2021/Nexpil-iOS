//
//  InformationCardEditDosageViewController.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/28/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class InformationCardEditDosageViewController: InformationCardEditViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doselabel: UILabel!
    
    var results = [DrugProductInfo]()
    var myItem = [String]()
    var selectedIndexPath:IndexPath?
    @IBAction func doneButtonTapped(_ sender: Any) {
        if dosage.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please select strength", title: "")
            return
        }
        DispatchQueue.main.async { [unowned self] in
            /*
            self.summaryPage?.prescription?.dose = self.dosage
            self.summaryPage?.strengthCard.valueText = self.dosage
            self.summaryPage?.strengthCard.view.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6.0)
            */
//            self.navigationController?.popViewController(animated: true)
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let medicationController = storyBoard.instantiateViewController(withIdentifier: "SiriMedicationViewController") as! SiriMedicationViewController
            self.navigationController?.pushViewController(medicationController, animated: true)
            
        }
    }
    
    //let a = ["10mg","20mg","30mg","40mg"]
    var dosage: String = ""
    //var summaryPage: SummaryScreenViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backImage = UIImage(named: "Back")
        let closeImage = UIImage(named:"Closebutton")?.withRenderingMode(.alwaysOriginal)
        let logoImage = UIImage(named: "Progress Bar2")
        self.navigationItem.titleView = UIImageView(image: logoImage)
        /*
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: navigationController, action: #selector(UINavigationController.popViewController(animated:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: closeImage, style: .plain, target: navigationController, action: #selector(UINavigationController.popViewController(animated:)))
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        */
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.clipsToBounds = true
        //collectionView.layer.masksToBounds = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let name = DataUtils.getMedicationName()! + "?"
        doselabel.text = "What's the strength of your " + name
        goProductInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillDisappear(animated)
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
        
        for index1 in 0 ..< myItems1.count
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
        collectionView.reloadData()
        if selectedIndexPath != nil
        {
            collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredVertically)
        }
    }
}

extension InformationCardEditDosageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dosageCell", for: indexPath) as! NPPlainCollectionViewCell
        cell.textLabel.text = myItem[indexPath.row]
        
        cell.roundCorners(.allCorners, radius: 20)
        cell.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6)
        cell.clipsToBounds = false
        /*
        cell.layer.masksToBounds = false
        cell.clipsToBounds = false
        cell.backgroundColor = UIColor.clear
        */
        return cell
    }
}

extension InformationCardEditDosageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width-11)/2
        return CGSize(width: width, height: width/2)
    }
}

extension InformationCardEditDosageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! NPPlainCollectionViewCell
        dosage = cell.textLabel.text!
        DataUtils.setMedicationStrength(name: dosage)
        self.selectedIndexPath = indexPath
    }
}
