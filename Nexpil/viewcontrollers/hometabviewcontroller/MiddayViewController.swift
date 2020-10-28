//
//  MiddayViewController.swift
//  Nexpil
//
//  Created by Admin on 4/6/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
class MiddayViewController: UITableViewController {

    var delegate: HomeSubMenuDelegate?
    
    var patientmedications : [MyMedication] = []
    //medication history about morning
    var medicationTimes : [MedicationTime] = []
    var cellTypes : [ItemType] = []
    var patientindexies:[Int] = []
    
    var currentDate : String = ""
    let taketime = "Midday"
    
    var m_DicAllItemTakenCollapsed: [String: Bool] = [String: Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.allowsSelection = false
        self.tableView.alwaysBounceVertical = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currentDate = self.delegate!.selectDay(value: 1)
        
        if DataUtils.isConnectedToNetwork() == false
        {
            DataUtils.messageShow(view: self, message: "Please check your internet connection.", title: "")
            return
        }
        getPatientMedications()
        self.delegate?.navColorChange(value: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    /*
     override func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 0
     }
     */
    
    func selectDateChange()
    {
        showPatientMedication()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellTypes.removeAll()
        patientindexies.removeAll()
        
        var itemCnt = 0
        
        for (i,obj) in medicationTimes.enumerated()
        {
            var rowCount = 1
            var cellTypesUntaken : [ItemType] = []
            var cellTypesTaken : [ItemType] = []
            
            if (!m_DicAllItemTakenCollapsed.keys.contains(obj.time)) {
                m_DicAllItemTakenCollapsed[obj.time] = false
            }
            
            var itemtype:ItemType = ItemType.init(celltype: CellType.time, medicationtimeIndex: 0, patientMedicationIndex: 0,labelName:obj.time)
            cellTypes.append(itemtype)
            //get medications with day,time,date,prescription = 0
            let obj1 = DBManager.shared.getMedicationInfos(daytime: taketime, date: currentDate, takeTime: obj.time, prescription: 0)
            var taken = 0
            for obj2 in obj1
            {
                if obj2.eatenTime == ""
                {
                    itemtype = ItemType.init(celltype: CellType.untaken, medicationtimeIndex: i, patientMedicationIndex: obj2.id,labelName: obj.time)
                    cellTypesUntaken.append(itemtype)
                }
            }
            
            for obj2 in obj1
            {
                if obj2.eatenTime != ""
                {
                    taken += 1
                    itemtype = ItemType.init(celltype: CellType.taken, medicationtimeIndex: i, patientMedicationIndex: obj2.id,labelName: obj.time)
                    cellTypesTaken.append(itemtype)
                }
            }
            
            if taken != obj1.count {
                
                cellTypes.append(contentsOf: cellTypesUntaken)
                cellTypes.append(contentsOf: cellTypesTaken)
                rowCount += obj.count
                
                itemtype = ItemType.init(celltype: CellType.takeall, medicationtimeIndex: i, patientMedicationIndex: obj1[0].id,labelName: obj.time)
                cellTypes.append(itemtype)
                rowCount += 1
                
            } else {
                
                let bCollapsed = m_DicAllItemTakenCollapsed[obj.time] as! Bool
                
                if (bCollapsed) {
                    itemtype = ItemType.init(celltype: CellType.alltakencollapse, medicationtimeIndex: i, patientMedicationIndex: obj1[0].id,labelName: obj.time)
                    
                } else {
                    
                    cellTypes.append(contentsOf: cellTypesTaken)
                    rowCount += obj.count
                    
                    itemtype = ItemType.init(celltype: CellType.alltakenexpand, medicationtimeIndex: i, patientMedicationIndex: obj1[0].id,labelName: obj.time)
                }
                
                cellTypes.insert(itemtype, at: 1 + itemCnt)
                rowCount += 1
            }
            
            itemCnt += rowCount
            
        }
        
        
        var counts = getAsNeededCounts()
        var itemtype:ItemType?
        if counts > 0
        {
            counts += 1
            itemtype = ItemType.init(celltype: CellType.asneeded, medicationtimeIndex: 0, patientMedicationIndex: 0,labelName: "")
            cellTypes.append(itemtype!)
            for i in 0 ..< counts - 1
            {
                itemtype = ItemType.init(celltype: CellType.item, medicationtimeIndex: 0, patientMedicationIndex: patientindexies[i],labelName: "")
                cellTypes.append(itemtype!)
            }
        }
        return cellTypes.count
    }
    
    func getPatientMedications() {
        let preference = PreferenceHelper()
        let params = [
            "userid" : preference.getId(),
            "choice" : "5",
            "taketime" : taketime
            ] as [String : Any]
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        Alamofire.request(DataUtils.APIURL + DataUtils.MYDRUG_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                
                debugPrint(response);
                
                if let data = response.result.value {
                    print("JSON: \(data)")
                    let json : [String:Any] = data as! [String : Any]
                    let result = json["status"] as? String
                    if result == "true"
                    {
                        self.patientmedications.removeAll()
                        let datas:[[String:Any]] = json["data"] as! [[String:Any]]
                        for obj in datas {
                            let patientMedication = MyMedication.init(json: obj)
                            let time = patientMedication.createat.components(separatedBy: " ")[1]
                            let hour = Int(time.components(separatedBy: ":")[0])!
                            let min = Int(time.components(separatedBy: ":")[1])!
                            let starttime = DataUtils.getTimeRange(index: 1)!.components(separatedBy: "-")[0]
                            let endtime = DataUtils.getTimeRange(index: 1)!.components(separatedBy: "-")[1]
                            let startH = Int(starttime.components(separatedBy: ":")[0])!
                            let startM = Int(starttime.components(separatedBy: ":")[1])!
                            let endH = Int(endtime.components(separatedBy: ":")[0])!
                            let endM = Int(endtime.components(separatedBy: ":")[1])!
                            if startH * 60 + startM <= hour * 60 + min && endH * 60 + endM > hour * 60 + min {
                                self.patientmedications.append(patientMedication)
                            }
                            
                        }
                        self.showPatientMedication()
                    }
                    else
                    {
                        let message = json["message"] as! String
                        DataUtils.messageShow(view: self, message: message, title: "")
                    }
                }
            })
    }
    
    func showPatientMedication()
    {
        //get medication history about morning
        for obj in patientmedications
        {
            if obj.prescription == 0
            {
                let time = obj.createat.components(separatedBy: " ")[1]
                let medicationHistory = MedicationHistory.init(id: 0, medicationId: obj.id, date: currentDate, takeTime: time, eatenTime: "", eatText: "", medicationName: obj.medicationname, dayTime: taketime,prescription:obj.prescription)
                DBManager.shared.insetMedicationHistoryData(datas: [medicationHistory])
            }
        }
        
        let medicationHistory = MedicationHistory.init(id: 0, medicationId: 0, date: currentDate, takeTime: "", eatenTime: "", eatText: "", medicationName: "", dayTime: taketime,prescription:0)
        medicationTimes = DBManager.shared.getTimesOfDay(data: medicationHistory)
        
        self.tableView.reloadData()
    }
    
    func getAsNeededCounts() -> Int {
        var asneededcounts = 0
        for (index, obj) in patientmedications.enumerated()
        {
            if obj.prescription != 0
            {
                asneededcounts += 1
                patientindexies.append(index)
            }
        }
        return asneededcounts
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cellTypes[indexPath.row].celltype == CellType.asneeded //label for adding medication time
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationTimeCell", for: indexPath) as? MedicationTimeCell
            cell?.time.font = UIFont(name: "Montserrat-Medium", size: 30)!
            cell?.time.textColor = UIColor.init(hex: "333333")
            cell?.time.text = "As Needed"
            self.tableView.rowHeight = (cell?.frame.height)!
            return cell!
        }
        else if cellTypes[indexPath.row].celltype == CellType.time //time label for take medication
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationTimeCell", for: indexPath) as? MedicationTimeCell
            let hour = cellTypes[indexPath.row].labelName.components(separatedBy: ":")[0]
            var updateTime = ""
            if Int(hour)! > 12
            {
                updateTime = String(Int(hour)! - 12) + ":" + cellTypes[indexPath.row].labelName.components(separatedBy: ":")[1] + " pm"
            }
            else {
                updateTime = cellTypes[indexPath.row].labelName + " am"
            }
            cell?.time.text = updateTime
            cell?.time.font = UIFont(name: "Montserrat-Medium", size: 30)!
            cell?.time.textColor = UIColor.init(hex: "333333")
            self.tableView.rowHeight = (cell?.frame.height)!
            return cell!
        }
        else if cellTypes[indexPath.row].celltype == CellType.addcell //button for adding medication
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationAddCell", for: indexPath) as! MedicationAddCell
            let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.addNewMedication))
            
            cell.addbtn.layer.cornerRadius = 10.0
            cell.addbtn.layer.masksToBounds = true
            
            cell.addbtn.addGestureRecognizer(gesture)
            return cell
        }
        else if cellTypes[indexPath.row].celltype == CellType.takeall //take all button
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MadicationTakeAllCell", for: indexPath) as? MadicationTakeAllCell
            let id = cellTypes[indexPath.row].patientMedicationIndex
            cell?.takeall.tag = id
            let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.takeAllEatPress))
            cell?.takeall.addGestureRecognizer(gesture)
            
            return cell!
        }
        else if cellTypes[indexPath.row].celltype == CellType.untaken //table view cells for medication times(prescription)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationUntakenCell", for: indexPath) as? MedicationUntakenCell
            let index = cellTypes[indexPath.row].patientMedicationIndex
            let historys = DBManager.shared.getMedicationInfosById(id:index)
            cell?.medicationname.text = historys[0].medicationName
            cell?.medicationname.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action:  #selector(getPrescriptionMedication(sender:)))
            cell?.medicationname.tag = index
            cell?.medicationname.addGestureRecognizer(gesture)
            
            
            cell?.checkbtn.removeTarget(nil, action: nil, for: .allEvents)
            
            cell?.content.text = "Take 1 tablet"
            cell?.checkbtn.tag = historys[0].id
            cell?.checkbtn.addTarget(self, action: #selector(takeEatPress(_:)), for: .touchUpInside)
            
            cell?.backgroundview.viewShadow_drug()
            
            return cell!
        }
        else if cellTypes[indexPath.row].celltype == CellType.taken //table view cells for medication times(prescription)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationTakenCell", for: indexPath) as? MedicationTakenCell
            let index = cellTypes[indexPath.row].patientMedicationIndex
            let historys = DBManager.shared.getMedicationInfosById(id:index)
            cell?.medicationname.text = historys[0].medicationName
            cell?.medicationname.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action:  #selector(getPrescriptionMedication(sender:)))
            cell?.medicationname.tag = index
            cell?.medicationname.addGestureRecognizer(gesture)
            
            
            cell?.checkbtn.removeTarget(nil, action: nil, for: .allEvents)
            
            cell?.content.text = historys[0].eatText
            cell?.checkbtn.tag = historys[0].id
            cell?.checkbtn.addTarget(self, action: #selector(unTakeEatPress(_:)), for: .touchUpInside)
            
            
//            cell?.backgroundview.viewShadow()
            
            return cell!
        }
            
        else if cellTypes[indexPath.row].celltype == CellType.alltakenexpand //table view cells for medication times(prescription)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationAllItemTakenExpandCell", for: indexPath) as? MedicationAllItemTakenExpandCell
            let medicationIndex = cellTypes[indexPath.row].medicationtimeIndex
            let patientIndex = cellTypes[indexPath.row].patientMedicationIndex
            let historys = DBManager.shared.getMedicationInfosById(id: patientIndex)
            
            cell?.vwArrowDown.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action:  #selector(collapseItems(sender:)))
            cell?.vwArrowDown.tag = medicationIndex
            cell?.vwArrowDown.addGestureRecognizer(gesture)
            
            var strEatText: String = historys[0].eatText
            if let range = strEatText.range(of: "Taken ") {
                let strTakenTime = strEatText[range.upperBound...] // or str[str.startIndex..<range.lowerBound]
                print(strTakenTime)  // Prints ab
                cell?.content.text = "Taken at " + strTakenTime
            }
            return cell!
        }
        else if cellTypes[indexPath.row].celltype == CellType.alltakencollapse //table view cells for medication times(prescription)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationAllItemTakenCollapseCell", for: indexPath) as? MedicationAllItemTakenCollapseCell
            let medicationIndex = cellTypes[indexPath.row].medicationtimeIndex
            let patientIndex = cellTypes[indexPath.row].patientMedicationIndex
            let historys = DBManager.shared.getMedicationInfosById(id: patientIndex)
            
            
            cell?.vwArrowRight.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action:  #selector(expandItems(sender:)))
            cell?.vwArrowRight.tag = medicationIndex
            cell?.vwArrowRight.addGestureRecognizer(gesture)
            
            var strEatText: String = historys[0].eatText
            if let range = strEatText.range(of: "Taken ") {
                let strTakenTime = strEatText[range.upperBound...] // or str[str.startIndex..<range.lowerBound]
                print(strTakenTime)  // Prints ab
                cell?.content.text = "Taken at " + strTakenTime
            }
            
            return cell!
        }
            
        else if cellTypes[indexPath.row].celltype == CellType.item //medications for add medication times(as needed)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationItemCell", for: indexPath) as? MedicationItemCell
            cell?.title.text = patientmedications[cellTypes[indexPath.row].patientMedicationIndex].medicationname
            cell?.content.text = "Take 1 or 2 tablets"
            cell?.backgroundview.viewShadow()
            
            let medicationHistories = DBManager.shared.getMedicationInfoArray(daytime: taketime, date: currentDate, medicationId: patientmedications[cellTypes[indexPath.row].patientMedicationIndex].id)
            
            if medicationHistories.count == 0
            {
                let gesture = UITapGestureRecognizer(target: self, action:  #selector(addNeededSelect(sender:)))
                cell?.backgroundview.tag = cellTypes[indexPath.row].patientMedicationIndex
                cell?.backgroundview.addGestureRecognizer(gesture)
                
                cell?.backgroundheight.constant = 60
                cell?.lasttakenView.isHidden = true
                
                cell?.title.isUserInteractionEnabled = true
                let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(getPrescriptionMedication1(sender:)))
                cell?.title.tag = cellTypes[indexPath.row].patientMedicationIndex
                cell?.title.addGestureRecognizer(gesture1)
            }
            else
            {
                cell?.backgroundview.gestureRecognizers?.removeAll()
                cell?.lasttakenView.isHidden = false
                cell?.lasttakenTime.text = medicationHistories[0].eatText
                cell?.backgroundheight.constant = 155
            }
            return cell!
        } else {
            return UITableViewCell()
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellTypes[indexPath.row].celltype == CellType.asneeded //label for adding medication time
        {
            return 60
        }
        else if cellTypes[indexPath.row].celltype == CellType.time //time label for take medication
        {
            return 40
        }
        else if cellTypes[indexPath.row].celltype == CellType.addcell //button for adding medication
        {
            return 120
        }
        else if cellTypes[indexPath.row].celltype == CellType.takeall //take all button
        {
            
            return 60
        }
        else if cellTypes[indexPath.row].celltype == CellType.untaken //table view cells for medication times
        {
            
            return 83
        }
        else if cellTypes[indexPath.row].celltype == CellType.taken //table view cells for medication times
        {
            
            return 83
        }
        else if cellTypes[indexPath.row].celltype == CellType.alltakenexpand //table view cells for medication times
        {
            
            return 83
        }
        else if cellTypes[indexPath.row].celltype == CellType.alltakencollapse //table view cells for medication times
        {
            
            return 100
        }
        else if cellTypes[indexPath.row].celltype == CellType.item //table view cells for medication times
        {
            let medicationHistories = DBManager.shared.getMedicationInfoArray(daytime: taketime, date: currentDate, medicationId: patientmedications[cellTypes[indexPath.row].patientMedicationIndex].id)
            if medicationHistories.count > 0
            {
                return 160
            }
            else {
                return 70
            }
        }
        else
        {
            return 70
        }
    }
    
    @objc func getPrescriptionMedication1(sender : UITapGestureRecognizer) {
        let index = sender.view!.tag
        let history = patientmedications[index]
        let mymedication = MedicationHistory(id: 0, medicationId: history.id, date: currentDate, takeTime: "", eatenTime: "", eatText: "", medicationName: history.medicationname, dayTime: taketime, prescription: 1)
        
        
        let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "MedicationInfoMainViewController") as! MedicationInfoMainViewController
        viewController.myMedication = mymedication
        self.navigationController?.pushViewController(viewController, animated: false)
        
    }
    
    @objc func getPrescriptionMedication(sender : UITapGestureRecognizer) {
        let index = sender.view!.tag
        let historys = DBManager.shared.getMedicationInfosById(id:index)
        
        let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "MedicationInfoMainViewController") as! MedicationInfoMainViewController
        viewController.myMedication = historys[0]
        self.navigationController?.pushViewController(viewController, animated: false)
        
//        if historys[0].eatenTime == ""
//        {
//            let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "MedicationInfoMainViewController") as! MedicationInfoMainViewController
//            viewController.myMedication = historys[0]
//            self.navigationController?.pushViewController(viewController, animated: false)
//        }
    }
    
    
    @objc func takeAllEatPress(sender : UITapGestureRecognizer) {
        let id = sender.view!.tag
        let medications = DBManager.shared.getMedicationInfosById(id: id)
        let obj1 = DBManager.shared.getMedicationInfos(daytime: taketime, date: currentDate, takeTime: medications[0].takeTime, prescription: 0)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm a "
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        let currentDateTime = Date()
        let time = formatter.string(from: currentDateTime)
        
        for obj in obj1
        {
            if obj.eatenTime == ""
            {
                DBManager.shared.saveMedicationInfo(id: obj.id, eatTime: time, eatText: "1 tablet - Taken " + time)
            }
        }
        //self.showPatientMedication()
        self.tableView.reloadData()
    }
    
    
    
    @objc private func takeEatPress(_ sender: UIButton?) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm a "
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        let currentDateTime = Date()
        let time = formatter.string(from: currentDateTime)
        DBManager.shared.saveMedicationInfo(id: sender!.tag, eatTime: time, eatText: "1 tablet - Taken " + time)
        //self.showPatientMedication()
        self.tableView.reloadData()
    }
    
    @objc private func unTakeEatPress(_ sender: UIButton?) {
        
        let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "UnTakenViewController") as! UnTakenViewController
        viewController.medicationId = sender!.tag
        present(viewController, animated: false, completion: nil)
        
    }
    
    @objc func collapseItems( sender: UITapGestureRecognizer?) {
        
        let index = sender?.view?.tag as! Int
        if (index < 0 || index >= medicationTimes.count) {
            return
        }
        let medicationTime = medicationTimes[index]
        m_DicAllItemTakenCollapsed[medicationTime.time] = true
        
        self.tableView.reloadData()
    }
    
    @objc func expandItems( sender: UITapGestureRecognizer?) {
        
        let index = sender?.view?.tag as! Int
        if (index < 0 || index >= medicationTimes.count) {
            return
        }
        let medicationTime = medicationTimes[index]
        m_DicAllItemTakenCollapsed[medicationTime.time] = false
        
        self.tableView.reloadData()
    }
    
    @objc func addNeededSelect(sender : UITapGestureRecognizer) {
        let index = sender.view!.tag
        var mymedication = patientmedications[index]
        let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "TabletSelectDialogViewController") as! TabletSelectDialogViewController
        mymedication.taketime = taketime
        viewController.mymedication = mymedication
        present(viewController, animated: false, completion: nil)
    }
    
    @objc func addNewMedication(sender : UITapGestureRecognizer) {
        // Do what you want
        //apicall()
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddMedicationDialogViewController") as! AddMedicationDialogViewController
        present(viewController, animated: false, completion: nil)
    }
    
}

extension MiddayViewController : IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: taketime)
    }
}
