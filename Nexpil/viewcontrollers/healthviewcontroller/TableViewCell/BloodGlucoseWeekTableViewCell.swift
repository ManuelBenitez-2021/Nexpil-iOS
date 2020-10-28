//
//  BloodGlucoseWeekTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/31.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import Charts

class BloodGlucoseWeekTableViewCell: UITableViewCell {

    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgValues: UIView!
    
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblOutofRang: UILabel!
    @IBOutlet weak var lblSubTitle1: UILabel!
    @IBOutlet weak var lblSubTitle2: UILabel!
    @IBOutlet weak var lblSubTitle3: UILabel!
    @IBOutlet weak var lblSubTitle4: UILabel!
    @IBOutlet weak var lblSubTitle5: UILabel!
    @IBOutlet weak var lblSubTitle6: UILabel!
    @IBOutlet weak var lblSubTitle7: UILabel!

    @IBOutlet weak var lblDate01: UILabel!
    @IBOutlet weak var lblDate02: UILabel!
    @IBOutlet weak var lblDate03: UILabel!
    @IBOutlet weak var lblDate04: UILabel!
    @IBOutlet weak var lblDate05: UILabel!
    @IBOutlet weak var lblDate06: UILabel!
    @IBOutlet weak var lblDate07: UILabel!
    
    @IBOutlet weak var lblBefore01: UILabel!
    @IBOutlet weak var lblBefore02: UILabel!
    @IBOutlet weak var lblBefore03: UILabel!
    @IBOutlet weak var lblBefore04: UILabel!
    @IBOutlet weak var lblBefore05: UILabel!
    @IBOutlet weak var lblBefore06: UILabel!
    @IBOutlet weak var lblBefore07: UILabel!

    @IBOutlet weak var lblAfter01: UILabel!
    @IBOutlet weak var lblAfter02: UILabel!
    @IBOutlet weak var lblAfter03: UILabel!
    @IBOutlet weak var lblAfter04: UILabel!
    @IBOutlet weak var lblAfter05: UILabel!
    @IBOutlet weak var lblAfter06: UILabel!
    @IBOutlet weak var lblAfter07: UILabel!

    var dateFormatterGet = DateFormatter()
    var dateFormatterGet2 = DateFormatter()
    var dateFormatterPrint1 = DateFormatter()
    var dateFormatterPrint2 = DateFormatter()
    var dateFormatterPrint3 = DateFormatter()
    var dateFormatterPrint4 = DateFormatter()
    var countOutofRange = NSInteger()
    
    var valBefore01 = String()
    var valBefore02 = String()
    var valBefore03 = String()
    var valBefore04 = String()
    var valBefore05 = String()
    var valBefore06 = String()
    var valBefore07 = String()

    var valAfter01 = String()
    var valAfter02 = String()
    var valAfter03 = String()
    var valAfter04 = String()
    var valAfter05 = String()
    var valAfter06 = String()
    var valAfter07 = String()

    var valbefore01 = Double()
    var valbefore02 = Double()
    var valbefore03 = Double()
    var valbefore04 = Double()
    var valbefore05 = Double()
    var valbefore06 = Double()
    var valbefore07 = Double()

    var valafter01 = Double()
    var valafter02 = Double()
    var valafter03 = Double()
    var valafter04 = Double()
    var valafter05 = Double()
    var valafter06 = Double()
    var valafter07 = Double()

    var xVal = NSArray()
    var yVal1 = NSArray()
    var yVal2 = NSArray()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.initMainView()
        self.initChartView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    func initMainView() {
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true;
        bgValues.layer.cornerRadius = 10
        bgValues.layer.masksToBounds = true;
        
        dateFormatterGet.dateFormat = "yyyy-MM"
        dateFormatterGet2.dateFormat = "yyyy-MM-dd"
        dateFormatterPrint1.dateFormat = "yyyy"
        dateFormatterPrint2.dateFormat = "MMM"
        dateFormatterPrint3.dateFormat = "MMM d"
        dateFormatterPrint4.dateFormat = "MMMM"
        
        lblYear.font = UIFont.init(name: "Montserrat", size: 30)
        lblOutofRang.font = UIFont.init(name: "Montserrat", size: 20)
        lblSubTitle1.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle2.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle3.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle4.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle5.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle6.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle7.font = UIFont.init(name: "Montserrat", size: 15)
        lblDate01.font = UIFont.init(name: "Montserrat", size: 15)
        lblDate02.font = UIFont.init(name: "Montserrat", size: 15)
        lblDate03.font = UIFont.init(name: "Montserrat", size: 15)
        lblDate04.font = UIFont.init(name: "Montserrat", size: 15)
        lblDate05.font = UIFont.init(name: "Montserrat", size: 15)
        lblDate06.font = UIFont.init(name: "Montserrat", size: 15)
        lblDate07.font = UIFont.init(name: "Montserrat", size: 15)
        
        lblBefore01.font = UIFont.init(name: "Montserrat", size: 15)
        lblBefore02.font = UIFont.init(name: "Montserrat", size: 15)
        lblBefore03.font = UIFont.init(name: "Montserrat", size: 15)
        lblBefore04.font = UIFont.init(name: "Montserrat", size: 15)
        lblBefore05.font = UIFont.init(name: "Montserrat", size: 15)
        lblBefore06.font = UIFont.init(name: "Montserrat", size: 15)
        lblBefore07.font = UIFont.init(name: "Montserrat", size: 15)

        lblAfter01.font = UIFont.init(name: "Montserrat", size: 15)
        lblAfter02.font = UIFont.init(name: "Montserrat", size: 15)
        lblAfter03.font = UIFont.init(name: "Montserrat", size: 15)
        lblAfter04.font = UIFont.init(name: "Montserrat", size: 15)
        lblAfter05.font = UIFont.init(name: "Montserrat", size: 15)
        lblAfter06.font = UIFont.init(name: "Montserrat", size: 15)
        lblAfter07.font = UIFont.init(name: "Montserrat", size: 15)
        
        
    }
    
    func initChartView() {
        chartView.chartDescription?.enabled = false
        chartView.setScaleEnabled(true)
        chartView.xAxis.gridLineDashLengths = [10, 10]
        chartView.xAxis.gridLineDashPhase = 0
        chartView.rightAxis.axisMinimum = 0
        chartView.rightAxis.spaceBottom = 0
        chartView.chartDescription?.text = ""

        let leftAxis = chartView.leftAxis
        leftAxis.drawLimitLinesBehindDataEnabled = true
        chartView.leftAxis.enabled = false
        chartView.legend.form = .line
    }
    
    func setInfo(dic: NSDictionary) {
        countOutofRange = 0
        
        let strWeek = dic["strWeek"] as! String
        let unit = "mg/dl"
        let strYear: String = String(strWeek.prefix(7))
        let strSubWeek = strWeek.suffix(4)
        var strPreMonth = String()
        
        var strDate01 = String()
        var strDate02 = String()
        var strDate03 = String()
        var strDate04 = String()
        var strDate05 = String()
        var strDate06 = String()
        var strDate07 = String()
        
//        valbefore01 = 0
//        valbefore02 = 0
//        valbefore03 = 0
//        valbefore04 = 0
//        valbefore05 = 0
//        valbefore06 = 0
//        valbefore07 = 0
//
//        valafter01 = 0
//        valafter02 = 0
//        valafter03 = 0
//        valafter04 = 0
//        valafter05 = 0
//        valafter06 = 0
//        valafter07 = 0
        
        valbefore01 = 0
        valbefore02 = 0
        valbefore03 = 0
        valbefore04 = 0
        valbefore05 = 0
        valbefore06 = 0
        valbefore07 = 0
        
        valafter01 = 0
        valafter02 = 0
        valafter03 = 0
        valafter04 = 0
        valafter05 = 0
        valafter06 = 0
        valafter07 = 0
        
        let arrayPrefix = ["0106",
                           "0713",
                           "1420",
                           "2127",
                           "2830",
                           ] as NSArray
        
        let arrayPrefixTitle = ["1-6",
                                "7-13",
                                "14-20",
                                "21-27",
                                "28-30",
                                ] as NSArray
        
        let arrayDays = [["1",  "2",    "3",    "4",    "5",    "6"],
                         ["7",  "8",    "9",    "10",   "11",   "12",   "13"],
                         ["14", "15",   "16",   "17",   "18",   "19",   "20"],
                         ["21", "22",   "23",   "24",   "25",   "26",   "27"],
                         ["28", "29",   "30"],
                         ] as NSArray
        
        var arrayDay = NSArray()
        
        valBefore01 = ""
        valBefore02 = ""
        valBefore03 = ""
        valBefore04 = ""
        valBefore05 = ""
        valBefore06 = ""
        valBefore07 = ""

        valAfter01 = ""
        valAfter02 = ""
        valAfter03 = ""
        valAfter04 = ""
        valAfter05 = ""
        valAfter06 = ""
        valAfter07 = ""

        let arrayBeforeVal = NSMutableArray.init(array: [valBefore01,
                                                         valBefore02,
                                                         valBefore03,
                                                         valBefore04,
                                                         valBefore05,
                                                         valBefore06,
                                                         valBefore07])
        
        let arrayAfterVal = NSMutableArray.init(array: [valAfter01,
                                                        valAfter02,
                                                        valAfter03,
                                                        valAfter04,
                                                        valAfter05,
                                                        valAfter06,
                                                        valAfter07])
        
        xVal = NSMutableArray.init(array: [0, 0, 0, 0, 0, 0, 0])
        yVal1 = NSMutableArray.init(array: [0, 0, 0, 0, 0, 0, 0])
        yVal2 = NSMutableArray.init(array: [0, 0, 0, 0, 0, 0, 0])

        // get date index
        let index = arrayPrefix.index(of: String(strSubWeek))
        if index != nil {
            arrayDay = arrayDays[index] as! NSArray
        }
        
        
        if let date = dateFormatterGet.date(from: strYear) {
            strPreMonth = dateFormatterPrint2.string(from: date)
        }

        if index == 0 {
            strDate01 = String(format: "%@ %@", strPreMonth, arrayDay[0] as! CVarArg)
            strDate02 = String(format: "%@ %@", strPreMonth, arrayDay[1] as! CVarArg)
            strDate03 = String(format: "%@ %@", strPreMonth, arrayDay[2] as! CVarArg)
            strDate04 = String(format: "%@ %@", strPreMonth, arrayDay[3] as! CVarArg)
            strDate05 = String(format: "%@ %@", strPreMonth, arrayDay[4] as! CVarArg)
            strDate06 = String(format: "%@ %@", strPreMonth, arrayDay[5] as! CVarArg)

            let v0 = Int(arrayDay[0] as! String)
            let v1 = Int(arrayDay[1] as! String)
            let v2 = Int(arrayDay[2] as! String)
            let v3 = Int(arrayDay[3] as! String)
            let v4 = Int(arrayDay[4] as! String)
            let v5 = Int(arrayDay[5] as! String)

            xVal = NSMutableArray.init(array: [v0!, v1!, v2!, v3!, v4!, v5!])
            
        } else if index == 4 {
            strDate01 = String(format: "%@ %@", strPreMonth, arrayDay[0] as! CVarArg)
            strDate02 = String(format: "%@ %@", strPreMonth, arrayDay[1] as! CVarArg)
            strDate03 = String(format: "%@ %@", strPreMonth, arrayDay[2] as! CVarArg)

            let v0 = Int(arrayDay[0] as! String)
            let v1 = Int(arrayDay[1] as! String)
            let v2 = Int(arrayDay[2] as! String)
            
            xVal = NSMutableArray.init(array: [v0!, v1!, v2!])

        } else {
            strDate01 = String(format: "%@ %@", strPreMonth, arrayDay[0] as! CVarArg)
            strDate02 = String(format: "%@ %@", strPreMonth, arrayDay[1] as! CVarArg)
            strDate03 = String(format: "%@ %@", strPreMonth, arrayDay[2] as! CVarArg)
            strDate04 = String(format: "%@ %@", strPreMonth, arrayDay[3] as! CVarArg)
            strDate05 = String(format: "%@ %@", strPreMonth, arrayDay[4] as! CVarArg)
            strDate06 = String(format: "%@ %@", strPreMonth, arrayDay[5] as! CVarArg)
            strDate07 = String(format: "%@ %@", strPreMonth, arrayDay[6] as! CVarArg)

            let v0 = Int(arrayDay[0] as! String)
            let v1 = Int(arrayDay[1] as! String)
            let v2 = Int(arrayDay[2] as! String)
            let v3 = Int(arrayDay[3] as! String)
            let v4 = Int(arrayDay[4] as! String)
            let v5 = Int(arrayDay[5] as! String)
            let v6 = Int(arrayDay[6] as! String)
            
            xVal = NSMutableArray.init(array: [v0!, v1!, v2!, v3!, v4!, v5!, v6!])

        }

        let arrayDate = [strDate01,
                         strDate02,
                         strDate03,
                         strDate04,
                         strDate05,
                         strDate06,
                         strDate07]
        
        // set date string
        lblDate01.text = arrayDate[0]
        lblDate02.text = arrayDate[1]
        lblDate03.text = arrayDate[2]
        lblDate04.text = arrayDate[3]
        lblDate05.text = arrayDate[4]
        lblDate06.text = arrayDate[5]
        lblDate07.text = arrayDate[6]
        
        // get before index
        for before in dic["before"] as! NSArray {
            let dicValue = before as! NSDictionary
            let strDate = dicValue["strDate"] as! String
            let numValue = dicValue["value"] as! NSNumber
            let strValue = numValue.stringValue
            let intValue = numValue.intValue
            
            if let date1 = dateFormatterGet2.date(from: strDate) {
                let strDay = dateFormatterPrint3.string(from: date1)
                let indexBefore = arrayDate.index(of: strDay)
                if indexBefore != nil {
                    arrayBeforeVal.replaceObject(at: indexBefore!, with: strValue)
                }
            }
            
            // out of range
            if intValue < 80 || intValue > 130 {
                countOutofRange = countOutofRange + 1
            }
        }

        // get after index
        for before in dic["after"] as! NSArray {
            let dicValue = before as! NSDictionary
            let strDate = dicValue["strDate"] as! String
            let numValue = dicValue["value"] as! NSNumber
            let strValue = numValue.stringValue
            let intValue = numValue.intValue
            
            if let date1 = dateFormatterGet2.date(from: strDate) {
                let strDay = dateFormatterPrint3.string(from: date1)
                let indexAfter = arrayDate.index(of: strDay)
                if indexAfter != nil {
                    arrayAfterVal.replaceObject(at: indexAfter!, with: strValue)
                }
            }

            // out of range
            if intValue > 180 {
                countOutofRange = countOutofRange + 1
            }

        }
        
        // set before & after labels
        var strBeforeVal01 = "-"
        var strBeforeVal02 = "-"
        var strBeforeVal03 = "-"
        var strBeforeVal04 = "-"
        var strBeforeVal05 = "-"
        var strBeforeVal06 = "-"
        var strBeforeVal07 = "-"
        
        var strAfterVal01 = "-"
        var strAfterVal02 = "-"
        var strAfterVal03 = "-"
        var strAfterVal04 = "-"
        var strAfterVal05 = "-"
        var strAfterVal06 = "-"
        var strAfterVal07 = "-"

        if (arrayBeforeVal[0] as! String).count > 0 {
            strBeforeVal01 = String(format: "%@%@", (arrayBeforeVal[0] as! String), unit)
        }
        if (arrayBeforeVal[1] as! String).count > 0 {
            strBeforeVal02 = String(format: "%@%@", (arrayBeforeVal[1] as! String), unit)
        }
        if (arrayBeforeVal[2] as! String).count > 0 {
            strBeforeVal03 = String(format: "%@%@", (arrayBeforeVal[2] as! String), unit)
        }
        if (arrayBeforeVal[3] as! String).count > 0 {
            strBeforeVal04 = String(format: "%@%@", (arrayBeforeVal[3] as! String), unit)
        }
        if (arrayBeforeVal[4] as! String).count > 0 {
            strBeforeVal05 = String(format: "%@%@", (arrayBeforeVal[4] as! String), unit)
        }
        if (arrayBeforeVal[5] as! String).count > 0 {
            strBeforeVal06 = String(format: "%@%@", (arrayBeforeVal[5] as! String), unit)
        }
        if (arrayBeforeVal[6] as! String).count > 0 {
            strBeforeVal07 = String(format: "%@%@", (arrayBeforeVal[6] as! String), unit)
        }
        
        //---------------
        
        if (arrayAfterVal[0] as! String).count > 0 {
            strAfterVal01 = String(format: "%@%@", (arrayAfterVal[0] as! String), unit)
        }
        if (arrayAfterVal[1] as! String).count > 0 {
            strAfterVal02 = String(format: "%@%@", (arrayAfterVal[1] as! String), unit)
        }
        if (arrayAfterVal[2] as! String).count > 0 {
            strAfterVal03 = String(format: "%@%@", (arrayAfterVal[2] as! String), unit)
        }
        if (arrayAfterVal[3] as! String).count > 0 {
            strAfterVal04 = String(format: "%@%@", (arrayAfterVal[3] as! String), unit)
        }
        if (arrayAfterVal[4] as! String).count > 0 {
            strAfterVal05 = String(format: "%@%@", (arrayAfterVal[4] as! String), unit)
        }
        if (arrayAfterVal[5] as! String).count > 0 {
            strAfterVal06 = String(format: "%@%@", (arrayAfterVal[5] as! String), unit)
        }
        if (arrayAfterVal[6] as! String).count > 0 {
            strAfterVal07 = String(format: "%@%@", (arrayAfterVal[6] as! String), unit)
        }
        
        yVal1 = [0, 0, 0, 0, 0, 0, 0]
        yVal2 = [0, 0, 0, 0, 0, 0, 0]

        if index == 0 {
            strBeforeVal07 = ""
            strAfterVal07 = ""
            
            var b0 = 0
            var b1 = 0
            var b2 = 0
            var b3 = 0
            var b4 = 0
            var b5 = 0
            
            var a0 = 0
            var a1 = 0
            var a2 = 0
            var a3 = 0
            var a4 = 0
            var a5 = 0
            
            if (arrayBeforeVal[0] as! String).count > 0 {
                b0 = Int(arrayBeforeVal[0] as! String)!
            }
            if (arrayBeforeVal[1] as! String).count > 0 {
                b1 = Int(arrayBeforeVal[1] as! String)!
            }
            if (arrayBeforeVal[2] as! String).count > 0 {
                b2 = Int(arrayBeforeVal[2] as! String)!
            }
            if (arrayBeforeVal[3] as! String).count > 0 {
                b3 = Int(arrayBeforeVal[3] as! String)!
            }
            if (arrayBeforeVal[4] as! String).count > 0 {
                b4 = Int(arrayBeforeVal[4] as! String)!
            }
            if (arrayBeforeVal[5] as! String).count > 0 {
                b5 = Int(arrayBeforeVal[5] as! String)!
            }

            if (arrayAfterVal[0] as! String).count > 0 {
                a0 = Int(arrayAfterVal[0] as! String)!
            }
            if (arrayAfterVal[1] as! String).count > 0 {
                a1 = Int(arrayAfterVal[1] as! String)!
            }
            if (arrayAfterVal[2] as! String).count > 0 {
                a2 = Int(arrayAfterVal[2] as! String)!
            }
            if (arrayAfterVal[3] as! String).count > 0 {
                a3 = Int(arrayAfterVal[3] as! String)!
            }
            if (arrayAfterVal[4] as! String).count > 0 {
                a4 = Int(arrayAfterVal[4] as! String)!
            }
            if (arrayAfterVal[5] as! String).count > 0 {
                a5 = Int(arrayAfterVal[5] as! String)!
            }
            
            yVal1 = NSMutableArray.init(array: [b0, b1, b2, b3, b4, b5])
            yVal2 = NSMutableArray.init(array: [a0, a1, a2, a3, a4, a5])

        } else if index == 4 {
            strBeforeVal04 = ""
            strBeforeVal05 = ""
            strBeforeVal06 = ""
            strBeforeVal07 = ""

            strAfterVal04 = ""
            strAfterVal05 = ""
            strAfterVal06 = ""
            strAfterVal07 = ""
            
            var b0 = 0
            var b1 = 0
            var b2 = 0
            
            var a0 = 0
            var a1 = 0
            var a2 = 0
            
            if (arrayBeforeVal[0] as! String).count > 0 {
                b0 = Int(arrayBeforeVal[0] as! String)!
            }
            if (arrayBeforeVal[1] as! String).count > 0 {
                b1 = Int(arrayBeforeVal[1] as! String)!
            }
            if (arrayBeforeVal[2] as! String).count > 0 {
                b2 = Int(arrayBeforeVal[2] as! String)!
            }
            
            if (arrayAfterVal[0] as! String).count > 0 {
                a0 = Int(arrayAfterVal[0] as! String)!
            }
            if (arrayAfterVal[1] as! String).count > 0 {
                a1 = Int(arrayAfterVal[1] as! String)!
            }
            if (arrayAfterVal[2] as! String).count > 0 {
                a2 = Int(arrayAfterVal[2] as! String)!
            }
            
            yVal1 = NSMutableArray.init(array: [b0, b1, b2])
            yVal2 = NSMutableArray.init(array: [a0, a1, a2])

        } else {
            var b0 = 0
            var b1 = 0
            var b2 = 0
            var b3 = 0
            var b4 = 0
            var b5 = 0
            var b6 = 0

            var a0 = 0
            var a1 = 0
            var a2 = 0
            var a3 = 0
            var a4 = 0
            var a5 = 0
            var a6 = 0

            if (arrayBeforeVal[0] as! String).count > 0 {
                b0 = Int(arrayBeforeVal[0] as! String)!
            }
            if (arrayBeforeVal[1] as! String).count > 0 {
                b1 = Int(arrayBeforeVal[1] as! String)!
            }
            if (arrayBeforeVal[2] as! String).count > 0 {
                b2 = Int(arrayBeforeVal[2] as! String)!
            }
            if (arrayBeforeVal[3] as! String).count > 0 {
                b3 = Int(arrayBeforeVal[3] as! String)!
            }
            if (arrayBeforeVal[4] as! String).count > 0 {
                b4 = Int(arrayBeforeVal[4] as! String)!
            }
            if (arrayBeforeVal[5] as! String).count > 0 {
                b5 = Int(arrayBeforeVal[5] as! String)!
            }
            if (arrayBeforeVal[6] as! String).count > 0 {
                b6 = Int(arrayBeforeVal[6] as! String)!
            }

            if (arrayAfterVal[0] as! String).count > 0 {
                a0 = Int(arrayAfterVal[0] as! String)!
            }
            if (arrayAfterVal[1] as! String).count > 0 {
                a1 = Int(arrayAfterVal[1] as! String)!
            }
            if (arrayAfterVal[2] as! String).count > 0 {
                a2 = Int(arrayAfterVal[2] as! String)!
            }
            if (arrayAfterVal[3] as! String).count > 0 {
                a3 = Int(arrayAfterVal[3] as! String)!
            }
            if (arrayAfterVal[4] as! String).count > 0 {
                a4 = Int(arrayAfterVal[4] as! String)!
            }
            if (arrayAfterVal[5] as! String).count > 0 {
                a5 = Int(arrayAfterVal[5] as! String)!
            }
            if (arrayAfterVal[6] as! String).count > 0 {
                a6 = Int(arrayAfterVal[6] as! String)!
            }

            yVal1 = NSMutableArray.init(array: [b0, b1, b2, b3, b4, b5, b6])
            yVal2 = NSMutableArray.init(array: [a0, a1, a2, a3, a4, a5, a6])
        }
        
        //  set values
        lblBefore01.text = strBeforeVal01
        lblBefore02.text = strBeforeVal02
        lblBefore03.text = strBeforeVal03
        lblBefore04.text = strBeforeVal04
        lblBefore05.text = strBeforeVal05
        lblBefore06.text = strBeforeVal06
        lblBefore07.text = strBeforeVal07
        
        lblAfter01.text = strAfterVal01
        lblAfter02.text = strAfterVal02
        lblAfter03.text = strAfterVal03
        lblAfter04.text = strAfterVal04
        lblAfter05.text = strAfterVal05
        lblAfter06.text = strAfterVal06
        lblAfter07.text = strAfterVal07
        
        // count of range
        lblOutofRang.text = String(format: "Values out of Range: %li", countOutofRange)
        
        // set year title
        let strPrefix = arrayPrefixTitle[index] as! String
        if let date = dateFormatterGet.date(from: strYear) {
            lblYear.text = String(format: "%@ %@, %@", dateFormatterPrint4.string(from: date), strPrefix, dateFormatterPrint1.string(from: date))
        }

        // set chart
        self.setChartView2(xVal: xVal, yVal1: yVal1, yVal2: yVal2)
    }
    
    func setChartView2(xVal: NSArray, yVal1: NSArray, yVal2: NSArray) {
        var allLineChartDataSets: [LineChartDataSet] = [LineChartDataSet]()
        
        var dataEntries: [ChartDataEntry] = []
        let dataPoints = xVal
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: xVal[i] as! Double, y: yVal1[i] as! Double)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet1: LineChartDataSet = LineChartDataSet(values: dataEntries, label: "Before")
        
        // set dataset1
        let gradientColors = [ChartColorTemplates.colorFromString("#aecbf1").cgColor,
                              ChartColorTemplates.colorFromString("#8bb3ec").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        lineChartDataSet1.setColor(.cyan)
        lineChartDataSet1.setCircleColor(.cyan)
        lineChartDataSet1.circleRadius = 5
        lineChartDataSet1.drawCircleHoleEnabled = false
        lineChartDataSet1.axisDependency = .right

        lineChartDataSet1.fillAlpha = 1
        lineChartDataSet1.fill = Fill(linearGradient: gradient, angle: 60)
        lineChartDataSet1.drawFilledEnabled = true
        lineChartDataSet1.mode = .cubicBezier
        
        allLineChartDataSets.append(lineChartDataSet1)
        
        
        var dataEntries2: [ChartDataEntry] = []
        let dataPoints2 = xVal

        for i in 0..<dataPoints2.count {
            let dataEntry2 = ChartDataEntry(x: xVal[i] as! Double, y: yVal2[i] as! Double)
            dataEntries2.append(dataEntry2)
        }
        
        let lineChartDataSet2 = LineChartDataSet(values: dataEntries2, label: "After")
        // set dataset1
        let gradientColors2 = [ChartColorTemplates.colorFromString("#8db5eb").cgColor,
                               ChartColorTemplates.colorFromString("#5c95e4").cgColor]
        let gradient2 = CGGradient(colorsSpace: nil, colors: gradientColors2 as CFArray, locations: nil)!
        
        lineChartDataSet2.setColor(.blue)
        lineChartDataSet2.setCircleColor(.blue)
        lineChartDataSet2.circleRadius = 5
        lineChartDataSet2.drawCircleHoleEnabled = false
        lineChartDataSet2.axisDependency = .right

        lineChartDataSet2.fillAlpha = 1
        lineChartDataSet2.fill = Fill(linearGradient: gradient2, angle: 60)
        lineChartDataSet2.drawFilledEnabled = true
        lineChartDataSet2.mode = .cubicBezier
        
        allLineChartDataSets.append(lineChartDataSet2)
        
        let lineChartData = LineChartData(dataSets: allLineChartDataSets)
        
        chartView.data = lineChartData
        
    }
    
}
