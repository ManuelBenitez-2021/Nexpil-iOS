//
//  WeightWeekTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/31.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import Charts

class WeightWeekTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    
    @IBOutlet weak var lblTitleDate: UILabel!
    @IBOutlet weak var lblTitleWeight: UILabel!
    @IBOutlet weak var lblTitleGoal: UILabel!
    @IBOutlet weak var lblValueGoal: UILabel!
    
    
    @IBOutlet weak var lblDate01: UILabel!
    @IBOutlet weak var lblDate02: UILabel!
    @IBOutlet weak var lblDate03: UILabel!
    @IBOutlet weak var lblDate04: UILabel!
    @IBOutlet weak var lblDate05: UILabel!
    @IBOutlet weak var lblDate06: UILabel!
    @IBOutlet weak var lblDate07: UILabel!
    
    @IBOutlet weak var lblValue1: UILabel!
    @IBOutlet weak var lblValue2: UILabel!
    @IBOutlet weak var lblValue3: UILabel!
    @IBOutlet weak var lblValue4: UILabel!
    @IBOutlet weak var lblValue5: UILabel!
    @IBOutlet weak var lblValue6: UILabel!
    @IBOutlet weak var lblValue7: UILabel!
    
    var dateFormatterGet = DateFormatter()
    var dateFormatterGet2 = DateFormatter()
    var dateFormatterPrint1 = DateFormatter()
    var dateFormatterPrint2 = DateFormatter()
    var dateFormatterPrint3 = DateFormatter()
    var dateFormatterPrint4 = DateFormatter()
    var countOutofRange = NSInteger()
    
    var val1 = NSInteger()
    var val2 = NSInteger()
    var val3 = NSInteger()
    var val4 = NSInteger()
    var val5 = NSInteger()
    var val6 = NSInteger()
    var val7 = NSInteger()
    
    var strVal1 = String()
    var strVal2 = String()
    var strVal3 = String()
    var strVal4 = String()
    var strVal5 = String()
    var strVal6 = String()
    var strVal7 = String()
    
    var xVal = NSArray()
    var yVal = NSArray()
    
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
        
        dateFormatterGet.dateFormat = "yyyy-MM"
        dateFormatterGet2.dateFormat = "yyyy-MM-dd"
        dateFormatterPrint1.dateFormat = "yyyy"
        dateFormatterPrint2.dateFormat = "MMM"
        dateFormatterPrint3.dateFormat = "MMM d"
        dateFormatterPrint4.dateFormat = "MMMM"
        
        lblYear.font = UIFont.init(name: "Montserrat", size: 30)
        lblTitleDate.font = UIFont.init(name: "Montserrat", size: 15)
        lblTitleWeight.font = UIFont.init(name: "Montserrat", size: 15)
        lblTitleGoal.font = UIFont.init(name: "Montserrat", size: 15)
        lblValueGoal.font = UIFont.init(name: "Montserrat", size: 15)
        lblDate01.font = UIFont.init(name: "Montserrat", size: 15)
        lblDate02.font = UIFont.init(name: "Montserrat", size: 15)
        lblDate03.font = UIFont.init(name: "Montserrat", size: 15)
        lblDate04.font = UIFont.init(name: "Montserrat", size: 15)
        lblDate05.font = UIFont.init(name: "Montserrat", size: 15)
        lblDate06.font = UIFont.init(name: "Montserrat", size: 15)
        lblDate07.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue1.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue2.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue3.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue4.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue5.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue6.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue7.font = UIFont.init(name: "Montserrat", size: 15)

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
        let strWeek = dic["strWeek"] as! String
        let unit = "lbs"
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
        
        val1 = 0
        val2 = 0
        val3 = 0
        val4 = 0
        val5 = 0
        val6 = 0
        val7 = 0
        
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
        
        strVal1 = ""
        strVal2 = ""
        strVal3 = ""
        strVal4 = ""
        strVal5 = ""
        strVal6 = ""
        strVal7 = ""
        
        let arrayVal = NSMutableArray.init(array: [strVal1,
                                                   strVal2,
                                                   strVal3,
                                                   strVal4,
                                                   strVal5,
                                                   strVal6,
                                                   strVal7])
        
        xVal = NSMutableArray.init(array: [0, 0, 0, 0, 0, 0, 0])
        yVal = NSMutableArray.init(array: [0, 0, 0, 0, 0, 0, 0])
        
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
        
        // get value index
        for data in dic["data"] as! NSArray {
            let dicValue = data as! NSDictionary
            let strDate = dicValue["strDate"] as! String
            let numValue = dicValue["value"] as! NSNumber
            let strValue = numValue.stringValue
            let intValue = numValue.intValue
            
            if let date1 = dateFormatterGet2.date(from: strDate) {
                let strDay = dateFormatterPrint3.string(from: date1)
                let indexBefore = arrayDate.index(of: strDay)
                if indexBefore != nil {
                    arrayVal.replaceObject(at: indexBefore!, with: strValue)
                }
            }
            
            // out of range
            if intValue < 95 {
                countOutofRange = countOutofRange + 1
            }
        }
        
        // set before & after labels
        strVal1 = "-"
        strVal2 = "-"
        strVal3 = "-"
        strVal4 = "-"
        strVal5 = "-"
        strVal6 = "-"
        strVal7 = "-"
        
        if (arrayVal[0] as! String).count > 0 {
            var v = Double(arrayVal[0] as! String)!
            v = Double(String(format: "%.0f", v))!
            
            strVal1 = String(format: "%.0f%@", v, unit)
        }
        if (arrayVal[1] as! String).count > 0 {
            var v = Double(arrayVal[1] as! String)!
            v = Double(String(format: "%.0f", v))!

            strVal2 = String(format: "%.0f%@", v, unit)
        }
        if (arrayVal[2] as! String).count > 0 {
            var v = Double(arrayVal[2] as! String)!
            v = Double(String(format: "%.0f", v))!

            strVal3 = String(format: "%.0f%@", v, unit)
        }
        if (arrayVal[3] as! String).count > 0 {
            var v = Double(arrayVal[3] as! String)!
            v = Double(String(format: "%.0f", v))!

            strVal4 = String(format: "%.0f%@", v, unit)
        }
        if (arrayVal[4] as! String).count > 0 {
            var v = Double(arrayVal[4] as! String)!
            v = Double(String(format: "%.0f", v))!

            strVal5 = String(format: "%.0f%@", v, unit)
        }
        if (arrayVal[5] as! String).count > 0 {
            var v = Double(arrayVal[5] as! String)!
            v = Double(String(format: "%.0f", v))!

            strVal6 = String(format: "%.0f%@", v, unit)
        }
        if (arrayVal[6] as! String).count > 0 {
            var v = Double(arrayVal[6] as! String)!
            v = Double(String(format: "%.0f", v))!

            strVal7 = String(format: "%.0f%@", v, unit)
        }
        
        yVal = [0, 0, 0, 0, 0, 0, 0]
        
        if index == 0 {
            strVal7 = ""
            
            var v0: Double = 0.0
            var v1: Double = 0.0
            var v2: Double = 0.0
            var v3: Double = 0.0
            var v4: Double = 0.0
            var v5: Double = 0.0
            
            if (arrayVal[0] as! String).count > 0 {
                v0 = Double(arrayVal[0] as! String)!
                v0 = Double(String(format: "%.0f", v0))!
            }
            if (arrayVal[1] as! String).count > 0 {
                v1 = Double(arrayVal[1] as! String)!
                v1 = Double(String(format: "%.0f", v1))!
            }
            if (arrayVal[2] as! String).count > 0 {
                v2 = Double(arrayVal[2] as! String)!
                v2 = Double(String(format: "%.0f", v2))!
            }
            if (arrayVal[3] as! String).count > 0 {
                v3 = Double(arrayVal[3] as! String)!
                v3 = Double(String(format: "%.0f", v3))!
            }
            if (arrayVal[4] as! String).count > 0 {
                v4 = Double(arrayVal[4] as! String)!
                v4 = Double(String(format: "%.0f", v4))!
            }
            if (arrayVal[5] as! String).count > 0 {
                v5 = Double(arrayVal[5] as! String)!
                v5 = Double(String(format: "%.0f", v5))!
            }
            
            yVal = NSMutableArray.init(array: [v0, v1, v2, v3, v4, v5])
            
        } else if index == 4 {
            strVal4 = ""
            strVal5 = ""
            strVal6 = ""
            strVal7 = ""
            
            var v0 = 0
            var v1 = 0
            var v2 = 0
            
            if (arrayVal[0] as! String).count > 0 {
                v0 = Int(arrayVal[0] as! String)!
            }
            if (arrayVal[1] as! String).count > 0 {
                v1 = Int(arrayVal[1] as! String)!
            }
            if (arrayVal[2] as! String).count > 0 {
                v2 = Int(arrayVal[2] as! String)!
            }
            
            yVal = NSMutableArray.init(array: [v0, v1, v2])
            
        } else {
            var v0: Double = 0.0
            var v1: Double = 0.0
            var v2: Double = 0.0
            var v3: Double = 0.0
            var v4: Double = 0.0
            var v5: Double = 0.0
            var v6: Double = 0.0
            
            if (arrayVal[0] as! String).count > 0 {
                v0 = Double(arrayVal[0] as! String)!
            }
            if (arrayVal[1] as! String).count > 0 {
                v1 = Double(arrayVal[1] as! String)!
            }
            if (arrayVal[2] as! String).count > 0 {
                v2 = Double(arrayVal[2] as! String)!
            }
            if (arrayVal[3] as! String).count > 0 {
                v3 = Double(arrayVal[3] as! String)!
            }
            if (arrayVal[4] as! String).count > 0 {
                v4 = Double(arrayVal[4] as! String)!
            }
            if (arrayVal[5] as! String).count > 0 {
                v5 = Double(arrayVal[5] as! String)!
            }
            if (arrayVal[6] as! String).count > 0 {
                v6 = Double(arrayVal[6] as! String)!
            }
            
            yVal = NSMutableArray.init(array: [v0, v1, v2, v3, v4, v5, v6])
        }
        
        //  set values
        lblValue1.text = strVal1
        lblValue2.text = strVal2
        lblValue3.text = strVal3
        lblValue4.text = strVal4
        lblValue5.text = strVal5
        lblValue6.text = strVal6
        lblValue7.text = strVal7
        
        if strVal1 == "0lbs" {
            lblValue1.text = "-"
        }
        if strVal2 == "0lbs" {
            lblValue2.text = "-"
        }
        if strVal3 == "0lbs" {
            lblValue3.text = "-"
        }
        if strVal4 == "0lbs" {
            lblValue4.text = "-"
        }
        if strVal5 == "0lbs" {
            lblValue5.text = "-"
        }
        if strVal6 == "0lbs" {
            lblValue6.text = "-"
        }
        if strVal7 == "0lbs" {
            lblValue7.text = "-"
        }

        // set year title
        let strPrefix = arrayPrefixTitle[index] as! String
        if let date = dateFormatterGet.date(from: strYear) {
            lblYear.text = String(format: "%@ %@, %@", dateFormatterPrint4.string(from: date), strPrefix, dateFormatterPrint1.string(from: date))
        }
        
        
        // set chart
        self.setChartView(xVal: xVal, yVal: yVal)
        
        
    }
    
    func setChartView(xVal: NSArray, yVal: NSArray) {
        var allLineChartDataSets: [LineChartDataSet] = [LineChartDataSet]()
        
        var dataEntries: [ChartDataEntry] = []
        let dataPoints = xVal
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: xVal[i] as! Double, y: yVal[i] as! Double)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet1: LineChartDataSet = LineChartDataSet(values: dataEntries, label: "")
        
        // set dataset1
        let gradientColors = [ChartColorTemplates.colorFromString("#b5aff0").cgColor,
                              ChartColorTemplates.colorFromString("#938deb").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        //        lineChartDataSet1.setColor(.cyan)
        lineChartDataSet1.setCircleColor(.blue)
        lineChartDataSet1.circleRadius = 5
        lineChartDataSet1.drawCircleHoleEnabled = false
        lineChartDataSet1.axisDependency = .right
        
        lineChartDataSet1.fillAlpha = 1
        lineChartDataSet1.fill = Fill(linearGradient: gradient, angle: 60)
        lineChartDataSet1.drawFilledEnabled = true
        lineChartDataSet1.mode = .cubicBezier
        
        allLineChartDataSets.append(lineChartDataSet1)
        let lineChartData = LineChartData(dataSets: allLineChartDataSets)
        
        chartView.data = lineChartData
        
    }
    
}
