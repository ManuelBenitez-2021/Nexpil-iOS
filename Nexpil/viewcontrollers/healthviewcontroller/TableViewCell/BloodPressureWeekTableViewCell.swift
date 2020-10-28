//
//  BloodPressureWeekTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/31.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import Charts

class BloodPressureWeekTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgValues: UIView!
    @IBOutlet weak var chartView: LineChartView!
    
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblOutofRang: UILabel!
    
    @IBOutlet weak var lblSubTitle1: UILabel!
    @IBOutlet weak var lblSubTitle2: UILabel!
    @IBOutlet weak var lblSubTitle3: UILabel!
    @IBOutlet weak var lblSubTitle4: UILabel!

    @IBOutlet weak var lblDate01: UILabel!
    @IBOutlet weak var lblDate02: UILabel!
    @IBOutlet weak var lblDate03: UILabel!
    @IBOutlet weak var lblDate04: UILabel!
    @IBOutlet weak var lblDate05: UILabel!
    @IBOutlet weak var lblDate06: UILabel!
    @IBOutlet weak var lblDate07: UILabel!
    
    @IBOutlet weak var lblValue01: UILabel!
    @IBOutlet weak var lblValue02: UILabel!
    @IBOutlet weak var lblValue03: UILabel!
    @IBOutlet weak var lblValue04: UILabel!
    @IBOutlet weak var lblValue05: UILabel!
    @IBOutlet weak var lblValue06: UILabel!
    @IBOutlet weak var lblValue07: UILabel!

    var dateFormatterGet = DateFormatter()
    var dateFormatterGet2 = DateFormatter()
    var dateFormatterPrint1 = DateFormatter()
    var dateFormatterPrint2 = DateFormatter()
    var dateFormatterPrint3 = DateFormatter()
    var dateFormatterPrint4 = DateFormatter()
    var countOutofRange = NSInteger()
    
    var strVal1_01 = String()
    var strVal1_02 = String()
    var strVal1_03 = String()
    var strVal1_04 = String()
    var strVal1_05 = String()
    var strVal1_06 = String()
    var strVal1_07 = String()
    
    var strVal2_01 = String()
    var strVal2_02 = String()
    var strVal2_03 = String()
    var strVal2_04 = String()
    var strVal2_05 = String()
    var strVal2_06 = String()
    var strVal2_07 = String()

    var val1_01 = NSInteger()
    var val1_02 = NSInteger()
    var val1_03 = NSInteger()
    var val1_04 = NSInteger()
    var val1_05 = NSInteger()
    var val1_06 = NSInteger()
    var val1_07 = NSInteger()
    
    var val2_01 = NSInteger()
    var val2_02 = NSInteger()
    var val2_03 = NSInteger()
    var val2_04 = NSInteger()
    var val2_05 = NSInteger()
    var val2_06 = NSInteger()
    var val2_07 = NSInteger()
    
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
        lblDate01.font = UIFont.init(name: "Montserrat", size: 15)
        lblDate02.font = UIFont.init(name: "Montserrat", size: 15)
        lblDate03.font = UIFont.init(name: "Montserrat", size: 15)
        lblDate04.font = UIFont.init(name: "Montserrat", size: 15)
        lblDate05.font = UIFont.init(name: "Montserrat", size: 15)
        lblDate06.font = UIFont.init(name: "Montserrat", size: 15)
        lblDate07.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue01.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue02.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue03.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue03.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue04.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue05.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue06.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue07.font = UIFont.init(name: "Montserrat", size: 15)
        
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
        let unit = "mmHg"
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
        
        val1_01 = 0
        val1_02 = 0
        val1_03 = 0
        val1_04 = 0
        val1_05 = 0
        val1_06 = 0
        val1_07 = 0
        
        val2_01 = 0
        val2_02 = 0
        val2_03 = 0
        val2_04 = 0
        val2_05 = 0
        val2_06 = 0
        val2_07 = 0

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
        
        strVal1_01 = ""
        strVal1_02 = ""
        strVal1_03 = ""
        strVal1_04 = ""
        strVal1_05 = ""
        strVal1_06 = ""
        strVal1_07 = ""
        
        strVal2_01 = ""
        strVal2_02 = ""
        strVal2_03 = ""
        strVal2_04 = ""
        strVal2_05 = ""
        strVal2_06 = ""
        strVal2_07 = ""

        let arrayVal1 = NSMutableArray.init(array: [val1_01,
                                                         val1_02,
                                                         val1_03,
                                                         val1_04,
                                                         val1_05,
                                                         val1_06,
                                                         val1_07])
        
        let arrayVal2 = NSMutableArray.init(array: [val2_01,
                                                        val2_02,
                                                        val2_03,
                                                        val2_04,
                                                        val2_05,
                                                        val2_06,
                                                        val2_07])
        
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
        for data in dic["data"] as! NSArray {
            let dicData = data as! NSDictionary
            let strDate = dicData["strDate"] as! String
            let numValue1 = dicData["value1"] as! NSNumber
            let numValue2 = dicData["value2"] as! NSNumber
            let intValue1 = numValue1.intValue
            let intValue2 = numValue2.intValue

            if let date1 = dateFormatterGet2.date(from: strDate) {
                let strDay = dateFormatterPrint3.string(from: date1)
                let index = arrayDate.index(of: strDay)
                if index != nil {
                    arrayVal1.replaceObject(at: index!, with: intValue1)
                    arrayVal2.replaceObject(at: index!, with: intValue2)
                }
            }
            
            // out of range
            if (intValue1 > 0 && intValue1 < 140) || (intValue2 > 0 && intValue2 < 90) {
                countOutofRange = countOutofRange + 1
            }
        }
        
        strVal1_01 = "-"
        strVal1_02 = "-"
        strVal1_03 = "-"
        strVal1_04 = "-"
        strVal1_05 = "-"
        strVal1_06 = "-"
        strVal1_07 = "-"

        strVal2_01 = "-"
        strVal2_02 = "-"
        strVal2_03 = "-"
        strVal2_04 = "-"
        strVal2_05 = "-"
        strVal2_06 = "-"
        strVal2_07 = "-"

        if ((arrayVal1[0] as! NSInteger) > 0 || (arrayVal2[0] as! NSInteger) > 0) {
            lblValue01.text = String(format: "%li/%li%@", arrayVal1[0] as! CVarArg, arrayVal2[0] as! CVarArg, unit)
        }
        if ((arrayVal1[1] as! NSInteger) > 0 || (arrayVal2[1] as! NSInteger) > 0) {
            lblValue02.text = String(format: "%li/%li%@", arrayVal1[1] as! CVarArg, arrayVal2[1] as! CVarArg, unit)
        }
        if ((arrayVal1[2] as! NSInteger) > 0 || (arrayVal2[2] as! NSInteger) > 0) {
            lblValue03.text = String(format: "%li/%li%@", arrayVal1[2] as! CVarArg, arrayVal2[2] as! CVarArg, unit)
        }
        if ((arrayVal1[3] as! NSInteger) > 0 || (arrayVal2[3] as! NSInteger) > 0) {
            lblValue04.text = String(format: "%li/%li%@", arrayVal1[3] as! CVarArg, arrayVal2[3] as! CVarArg, unit)
        }
        if ((arrayVal1[4] as! NSInteger) > 0 || (arrayVal2[4] as! NSInteger) > 0) {
            lblValue05.text = String(format: "%li/%li%@", arrayVal1[4] as! CVarArg, arrayVal2[4] as! CVarArg, unit)
        }
        if ((arrayVal1[5] as! NSInteger) > 0 || (arrayVal2[5] as! NSInteger) > 0) {
            lblValue06.text = String(format: "%li/%li%@", arrayVal1[5] as! CVarArg, arrayVal2[5] as! CVarArg, unit)
        }
        if ((arrayVal1[6] as! NSInteger) > 0 || (arrayVal2[6] as! NSInteger) > 0) {
            lblValue07.text = String(format: "%li/%li%@", arrayVal1[6] as! CVarArg, arrayVal2[6] as! CVarArg, unit)
        }

        yVal1 = [0, 0, 0, 0, 0, 0, 0]
        yVal2 = [0, 0, 0, 0, 0, 0, 0]
        
        if index == 0 {
            strVal1_07 = ""
            strVal2_07 = ""
            
            var v1_0 = 0
            var v1_1 = 0
            var v1_2 = 0
            var v1_3 = 0
            var v1_4 = 0
            var v1_5 = 0
            
            var v2_0 = 0
            var v2_1 = 0
            var v2_2 = 0
            var v2_3 = 0
            var v2_4 = 0
            var v2_5 = 0
            
            if (arrayVal1[0] as! NSInteger) > 0 {
                v1_0 = arrayVal1[0] as! NSInteger
            }
            if (arrayVal1[1] as! NSInteger) > 0 {
                v1_1 = arrayVal1[1] as! NSInteger
            }
            if (arrayVal1[2] as! NSInteger) > 0 {
                v1_2 = arrayVal1[2] as! NSInteger
            }
            if (arrayVal1[3] as! NSInteger) > 0 {
                v1_3 = arrayVal1[3] as! NSInteger
            }
            if (arrayVal1[4] as! NSInteger) > 0 {
                v1_4 = arrayVal1[4] as! NSInteger
            }
            if (arrayVal1[5] as! NSInteger) > 0 {
                v1_5 = arrayVal1[5] as! NSInteger
            }
            
            if (arrayVal2[0] as! NSInteger) > 0 {
                v2_0 = arrayVal2[0] as! NSInteger
            }
            if (arrayVal2[1] as! NSInteger) > 0 {
                v2_1 = arrayVal2[1] as! NSInteger
            }
            if (arrayVal2[2] as! NSInteger) > 0 {
                v2_2 = arrayVal2[2] as! NSInteger
            }
            if (arrayVal2[3] as! NSInteger) > 0 {
                v2_3 = arrayVal2[3] as! NSInteger
            }
            if (arrayVal2[4] as! NSInteger) > 0 {
                v2_4 = arrayVal2[4] as! NSInteger
            }
            if (arrayVal2[5] as! NSInteger) > 0 {
                v2_5 = arrayVal2[5] as! NSInteger
            }

            yVal1 = NSMutableArray.init(array: [v1_0, v1_1, v1_2, v1_3, v1_4, v1_5])
            yVal2 = NSMutableArray.init(array: [v2_0, v2_1, v2_2, v2_3, v2_4, v2_5])
            
            //  set values
            if (yVal1[0] as! NSInteger == 0 && yVal2[0] as! NSInteger == 0) {
                lblValue01.text = "-"
            } else {
                lblValue01.text = String(format: "%li/%li%@", yVal1[0] as! NSInteger, yVal2[0] as! NSInteger, unit)
            }
            if (yVal1[1] as! NSInteger == 0 && yVal2[1] as! NSInteger == 0) {
                lblValue02.text = "-"
            } else {
                lblValue02.text = String(format: "%li/%li%@", yVal1[1] as! NSInteger, yVal2[1] as! NSInteger, unit)
            }
            if (yVal1[2] as! NSInteger == 0 && yVal2[2] as! NSInteger == 0) {
                lblValue03.text = "-"
            } else {
                lblValue03.text = String(format: "%li/%li%@", yVal1[2] as! NSInteger, yVal2[2] as! NSInteger, unit)
            }
            if (yVal1[3] as! NSInteger == 0 && yVal2[3] as! NSInteger == 0) {
                lblValue04.text = "-"
            } else {
                lblValue04.text = String(format: "%li/%li%@", yVal1[3] as! NSInteger, yVal2[3] as! NSInteger, unit)
            }
            if (yVal1[4] as! NSInteger == 0 && yVal2[4] as! NSInteger == 0) {
                lblValue05.text = "-"
            } else {
                lblValue05.text = String(format: "%li/%li%@", yVal1[4] as! NSInteger, yVal2[4] as! NSInteger, unit)
            }
            if (yVal1[5] as! NSInteger == 0 && yVal2[5] as! NSInteger == 0) {
                lblValue06.text = "-"
            } else {
                lblValue06.text = String(format: "%li/%li%@", yVal1[5] as! NSInteger, yVal2[5] as! NSInteger, unit)
            }
            lblValue07.text = ""
            
        } else if index == 4 {
            strVal1_04 = ""
            strVal1_05 = ""
            strVal1_06 = ""
            strVal1_07 = ""
            
            strVal2_04 = ""
            strVal2_05 = ""
            strVal2_06 = ""
            strVal2_07 = ""
            
            var v1_0 = 0
            var v1_1 = 0
            var v1_2 = 0
            
            var v2_0 = 0
            var v2_1 = 0
            var v2_2 = 0

           
            if (arrayVal1[0] as! NSInteger) > 0 {
                v1_0 = arrayVal1[0] as! NSInteger
            }
            if (arrayVal1[1] as! NSInteger) > 0 {
                v1_1 = arrayVal1[1] as! NSInteger
            }
            if (arrayVal1[2] as! NSInteger) > 0 {
                v1_2 = arrayVal1[2] as! NSInteger
            }
            
            if (arrayVal2[0] as! NSInteger) > 0 {
                v2_0 = arrayVal2[0] as! NSInteger
            }
            if (arrayVal2[1] as! NSInteger) > 0 {
                v2_1 = arrayVal2[1] as! NSInteger
            }
            if (arrayVal2[2] as! NSInteger) > 0 {
                v2_2 = arrayVal2[2] as! NSInteger
            }
            

            yVal1 = NSMutableArray.init(array: [v1_0, v1_1, v1_2])
            yVal2 = NSMutableArray.init(array: [v2_0, v2_1, v2_2])
            
            //  set values
            if (yVal1[0] as! NSInteger == 0 && yVal2[0] as! NSInteger == 0) {
                lblValue01.text = "-"
            } else {
                lblValue01.text = String(format: "%li/%li%@", yVal1[0] as! NSInteger, yVal2[0] as! NSInteger, unit)
            }
            if (yVal1[1] as! NSInteger == 0 && yVal2[1] as! NSInteger == 0) {
                lblValue02.text = "-"
            } else {
                lblValue02.text = String(format: "%li/%li%@", yVal1[1] as! NSInteger, yVal2[1] as! NSInteger, unit)
            }
            if (yVal1[2] as! NSInteger == 0 && yVal2[2] as! NSInteger == 0) {
                lblValue03.text = "-"
            } else {
                lblValue03.text = String(format: "%li/%li%@", yVal1[2] as! NSInteger, yVal2[2] as! NSInteger, unit)
            }
            
            lblValue04.text = ""
            lblValue05.text = ""
            lblValue06.text = ""
            lblValue07.text = ""
            
        } else {
            var v1_0 = 0
            var v1_1 = 0
            var v1_2 = 0
            var v1_3 = 0
            var v1_4 = 0
            var v1_5 = 0
            var v1_6 = 0
            
            var v2_0 = 0
            var v2_1 = 0
            var v2_2 = 0
            var v2_3 = 0
            var v2_4 = 0
            var v2_5 = 0
            var v2_6 = 0
            
            if arrayVal1[0] as! NSInteger > 0 {
                v1_0 = arrayVal1[0] as! NSInteger
            }
            if arrayVal1[1] as! NSInteger > 0 {
                v1_1 = arrayVal1[1] as! NSInteger
            }
            if arrayVal1[2] as! NSInteger > 0 {
                v1_2 = arrayVal1[2] as! NSInteger
            }
            if arrayVal1[3] as! NSInteger > 0 {
                v1_3 = arrayVal1[3] as! NSInteger
            }
            if arrayVal1[4] as! NSInteger > 0 {
                v1_4 = arrayVal1[4] as! NSInteger
            }
            if arrayVal1[5] as! NSInteger > 0 {
                v1_5 = arrayVal1[5] as! NSInteger
            }
            if arrayVal1[6] as! NSInteger > 0 {
                v1_6 = arrayVal1[6] as! NSInteger
            }

            if arrayVal2[0] as! NSInteger > 0 {
                v2_0 = arrayVal2[0] as! NSInteger
            }
            if arrayVal2[1] as! NSInteger > 0 {
                v2_1 = arrayVal2[1] as! NSInteger
            }
            if arrayVal2[2] as! NSInteger > 0 {
                v2_2 = arrayVal2[2] as! NSInteger
            }
            if arrayVal2[3] as! NSInteger > 0 {
                v2_3 = arrayVal2[3] as! NSInteger
            }
            if arrayVal2[4] as! NSInteger > 0 {
                v2_4 = arrayVal2[4] as! NSInteger
            }
            if arrayVal2[5] as! NSInteger > 0 {
                v2_5 = arrayVal2[5] as! NSInteger
            }
            if arrayVal2[6] as! NSInteger > 0 {
                v2_6 = arrayVal2[6] as! NSInteger
            }

            
            yVal1 = NSMutableArray.init(array: [v1_0, v1_1, v1_2, v1_3, v1_4, v1_5, v1_6])
            yVal2 = NSMutableArray.init(array: [v2_0, v2_1, v2_2, v2_3, v2_4, v2_5, v2_6])
            
            //  set values
            if (yVal1[0] as! NSInteger) != 0 && (yVal2[0] as! NSInteger) != 0 {
                lblValue01.text = String(format: "%li/%li%@", yVal1[0] as! NSInteger, yVal2[0] as! NSInteger, unit)
            } else {
                lblValue01.text = "-"
            }
            if (yVal1[1] as! NSInteger) != 0 && (yVal2[1] as! NSInteger) != 0 {
                lblValue02.text = String(format: "%li/%li%@", yVal1[1] as! NSInteger, yVal2[1] as! NSInteger, unit)
            } else {
                lblValue02.text = "-"
            }
            if (yVal1[2] as! NSInteger) != 0 && (yVal2[2] as! NSInteger) != 0 {
                lblValue03.text = String(format: "%li/%li%@", yVal1[2] as! NSInteger, yVal2[2] as! NSInteger, unit)
            } else {
                lblValue03.text = "-"
            }
            if (yVal1[3] as! NSInteger) != 0 && (yVal2[3] as! NSInteger) != 0 {
                lblValue04.text = String(format: "%li/%li%@", yVal1[3] as! NSInteger, yVal2[3] as! NSInteger, unit)
            } else {
                lblValue04.text = "-"
            }
            if (yVal1[4] as! NSInteger) != 0 && (yVal2[4] as! NSInteger) != 0 {
                lblValue05.text = String(format: "%li/%li%@", yVal1[4] as! NSInteger, yVal2[4] as! NSInteger, unit)
            } else {
                lblValue05.text = "-"
            }
            if (yVal1[5] as! NSInteger) != 0 && (yVal2[5] as! NSInteger) != 0 {
                lblValue06.text = String(format: "%li/%li%@", yVal1[5] as! NSInteger, yVal2[5] as! NSInteger, unit)
            } else {
                lblValue06.text = "-"
            }
            if (yVal1[6] as! NSInteger) != 0 && (yVal2[6] as! NSInteger) != 0 {
                lblValue07.text = String(format: "%li/%li%@", yVal1[6] as! NSInteger, yVal2[6] as! NSInteger, unit)
            } else {
                lblValue07.text = "-"
            }
            
        }
        

        
        // count of range
        lblOutofRang.text = String(format: "Values out of Range: %li", countOutofRange)
        
        // set year title
        let strPrefix = arrayPrefixTitle[index] as! String
        if let date = dateFormatterGet.date(from: strYear) {
            lblYear.text = String(format: "%@ %@, %@", dateFormatterPrint4.string(from: date), strPrefix, dateFormatterPrint1.string(from: date))
        }
        
        // set chart
        self.setChartView(xVal: xVal, yVal1: yVal1, yVal2: yVal2)
        
    }
    
    func setChartView(xVal: NSArray, yVal1: NSArray, yVal2: NSArray) {
        var allLineChartDataSets: [LineChartDataSet] = [LineChartDataSet]()
        
        var dataEntries: [ChartDataEntry] = []
        let dataPoints = xVal
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: xVal[i] as! Double, y: yVal1[i] as! Double)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet1: LineChartDataSet = LineChartDataSet(values: dataEntries, label: "Before")
        
        // set dataset1
        let gradientColors = [ChartColorTemplates.colorFromString("#b5aff0").cgColor,
                              ChartColorTemplates.colorFromString("#938deb").cgColor]
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
        let gradientColors2 = [ChartColorTemplates.colorFromString("#978feb").cgColor,
                               ChartColorTemplates.colorFromString("#675ee4").cgColor]
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
