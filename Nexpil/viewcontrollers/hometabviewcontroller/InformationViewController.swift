//
//  InformationViewController.swift
//  Nexpil
//
//  Created by Admin on 4/27/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class InformationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var medicationName = ""
    var titleString:[String] = []
    var contentString:[String] = []
    let cellReuseIdentifier = "InformationTableViewCell"
    @IBOutlet weak var infoTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        titleString.append("What is \(medicationName)?")
        titleString.append("Missed Dose")
        titleString.append("Side Effects")
        // Do any additional setup after loading the view.
        self.infoTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.infoTableView.allowsSelection = false
        self.infoTableView.alwaysBounceVertical = false
        self.infoTableView.estimatedRowHeight = 70
        self.infoTableView.rowHeight = UITableViewAutomaticDimension
        
        contentString.append("")
        contentString.append("")
        contentString.append("")
        
        getMedicationInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getMedicationInfo()
    {
        let path = "https://api.fda.gov/drug/label.json?search=brand_name:\(medicationName)"
        let url = URL(string: path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { [unowned self] (data, response, error) in
            guard error == nil else { return }
            guard data != nil else { return }
            
            
             let decoder = JSONDecoder()
             let results = try! decoder.decode(Results.self, from: data!)
             
             if let result = results.results {
             print(result)
             DispatchQueue.main.async {
                //self.textView.text = result[0].indications_and_usage?.joined(separator: "\n")
                var what = result[0].description?[0] ?? ""
                if what == ""
                {
                    what = result[0].purpose?[0] ?? ""
                }
                self.contentString.removeAll()
                self.contentString.append(what)
                self.contentString.append(result[0].dosage_and_administration?[0] ?? "")
                self.contentString.append(result[0].indications_and_usage?[0] ?? "")
                self.infoTableView.reloadData()
             }
             }
            
        }
        task.resume()
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
        return titleString.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? InformationTableViewCell
        cell?.title.text = titleString[indexPath.row]
        cell?.content.text = contentString[indexPath.row]
        cell?.backview.viewShadow()
        return cell!
    }
    
}
extension InformationViewController : IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Information")
    }
}
