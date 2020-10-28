//
//  BloodGlucoseYearTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/31.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import Charts

class BloodGlucoseYearTableViewCell: UITableViewCell {

    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgValues: UIView!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblOutofRange: UILabel!
    @IBOutlet weak var lblSubTitle1: UILabel!
    @IBOutlet weak var lblSubTitle2: UILabel!
    @IBOutlet weak var lblSubTitle3: UILabel!
    @IBOutlet weak var lblSubTitle4: UILabel!
    @IBOutlet weak var lblSubTitle5: UILabel!
    @IBOutlet weak var lblSubTitle6: UILabel!
    @IBOutlet weak var lblSubTitle7: UILabel!
    @IBOutlet weak var lblMonth01: UILabel!
    @IBOutlet weak var lblMonth02: UILabel!
    @IBOutlet weak var lblMonth03: UILabel!
    @IBOutlet weak var lblMonth04: UILabel!
    @IBOutlet weak var lblMonth05: UILabel!
    @IBOutlet weak var lblMonth06: UILabel!
    @IBOutlet weak var lblMonth07: UILabel!
    @IBOutlet weak var lblMonth08: UILabel!
    @IBOutlet weak var lblMonth09: UILabel!
    @IBOutlet weak var lblMonth10: UILabel!
    @IBOutlet weak var lblMonth11: UILabel!
    @IBOutlet weak var lblMonth12: UILabel!
    
    @IBOutlet weak var lblBefore01: UILabel!
    @IBOutlet weak var lblBefore02: UILabel!
    @IBOutlet weak var lblBefore03: UILabel!
    @IBOutlet weak var lblBefore04: UILabel!
    @IBOutlet weak var lblBefore05: UILabel!
    @IBOutlet weak var lblBefore06: UILabel!
    @IBOutlet weak var lblBefore07: UILabel!
    @IBOutlet weak var lblBefore08: UILabel!
    @IBOutlet weak var lblBefore09: UILabel!
    @IBOutlet weak var lblBefore10: UILabel!
    @IBOutlet weak var lblBefore11: UILabel!
    @IBOutlet weak var lblBefore12: UILabel!
    @IBOutlet weak var lblAfter01: UILabel!
    @IBOutlet weak var lblAfter02: UILabel!
    @IBOutlet weak var lblAfter03: UILabel!
    @IBOutlet weak var lblAfter04: UILabel!
    @IBOutlet weak var lblAfter05: UILabel!
    @IBOutlet weak var lblAfter06: UILabel!
    @IBOutlet weak var lblAfter07: UILabel!
    @IBOutlet weak var lblAfter08: UILabel!
    @IBOutlet weak var lblAfter09: UILabel!
    @IBOutlet weak var lblAfter10: UILabel!
    @IBOutlet weak var lblAfter11: UILabel!
    @IBOutlet weak var lblAfter12: UILabel!

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
        
        lblYear.font = UIFont.init(name: "Montserrat", size: 30)
        lblOutofRange.font = UIFont.init(name: "Montserrat", size: 20)
        lblSubTitle1.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle2.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle3.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle4.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle5.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle6.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle7.font = UIFont.init(name: "Montserrat", size: 15)

        lblMonth01.font = UIFont.init(name: "Montserrat", size: 15)
        lblMonth02.font = UIFont.init(name: "Montserrat", size: 15)
        lblMonth03.font = UIFont.init(name: "Montserrat", size: 15)
        lblMonth04.font = UIFont.init(name: "Montserrat", size: 15)
        lblMonth05.font = UIFont.init(name: "Montserrat", size: 15)
        lblMonth06.font = UIFont.init(name: "Montserrat", size: 15)
        lblMonth07.font = UIFont.init(name: "Montserrat", size: 15)
        lblMonth08.font = UIFont.init(name: "Montserrat", size: 15)
        lblMonth09.font = UIFont.init(name: "Montserrat", size: 15)
        lblMonth10.font = UIFont.init(name: "Montserrat", size: 15)
        lblMonth11.font = UIFont.init(name: "Montserrat", size: 15)
        lblMonth12.font = UIFont.init(name: "Montserrat", size: 15)

        lblBefore01.font = UIFont.init(name: "Montserrat", size: 15)
        lblBefore02.font = UIFont.init(name: "Montserrat", size: 15)
        lblBefore03.font = UIFont.init(name: "Montserrat", size: 15)
        lblBefore04.font = UIFont.init(name: "Montserrat", size: 15)
        lblBefore05.font = UIFont.init(name: "Montserrat", size: 15)
        lblBefore06.font = UIFont.init(name: "Montserrat", size: 15)
        lblBefore07.font = UIFont.init(name: "Montserrat", size: 15)
        lblBefore08.font = UIFont.init(name: "Montserrat", size: 15)
        lblBefore09.font = UIFont.init(name: "Montserrat", size: 15)
        lblBefore10.font = UIFont.init(name: "Montserrat", size: 15)
        lblBefore11.font = UIFont.init(name: "Montserrat", size: 15)
        lblBefore12.font = UIFont.init(name: "Montserrat", size: 15)

        lblAfter01.font = UIFont.init(name: "Montserrat", size: 15)
        lblAfter02.font = UIFont.init(name: "Montserrat", size: 15)
        lblAfter03.font = UIFont.init(name: "Montserrat", size: 15)
        lblAfter04.font = UIFont.init(name: "Montserrat", size: 15)
        lblAfter05.font = UIFont.init(name: "Montserrat", size: 15)
        lblAfter06.font = UIFont.init(name: "Montserrat", size: 15)
        lblAfter07.font = UIFont.init(name: "Montserrat", size: 15)
        lblAfter08.font = UIFont.init(name: "Montserrat", size: 15)
        lblAfter09.font = UIFont.init(name: "Montserrat", size: 15)
        lblAfter10.font = UIFont.init(name: "Montserrat", size: 15)
        lblAfter11.font = UIFont.init(name: "Montserrat", size: 15)
        lblAfter12.font = UIFont.init(name: "Montserrat", size: 15)

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
        
        let strYear = dic["year"] as! String
        let arrayBefore = dic["before"] as! NSArray
        let arrayafter = dic["after"] as! NSArray
        
        var strBefore01 = "-"
        var strBefore02 = "-"
        var strBefore03 = "-"
        var strBefore04 = "-"
        var strBefore05 = "-"
        var strBefore06 = "-"
        var strBefore07 = "-"
        var strBefore08 = "-"
        var strBefore09 = "-"
        var strBefore10 = "-"
        var strBefore11 = "-"
        var strBefore12 = "-"

        var strAfter01 = "-"
        var strAfter02 = "-"
        var strAfter03 = "-"
        var strAfter04 = "-"
        var strAfter05 = "-"
        var strAfter06 = "-"
        var strAfter07 = "-"
        var strAfter08 = "-"
        var strAfter09 = "-"
        var strAfter10 = "-"
        var strAfter11 = "-"
        var strAfter12 = "-"
        
        var coutValuofRange = 0
        
        var valBefore01 = 0
        var valBefore02 = 0
        var valBefore03 = 0
        var valBefore04 = 0
        var valBefore05 = 0
        var valBefore06 = 0
        var valBefore07 = 0
        var valBefore08 = 0
        var valBefore09 = 0
        var valBefore10 = 0
        var valBefore11 = 0
        var valBefore12 = 0
        
        var valAfter01 = 0
        var valAfter02 = 0
        var valAfter03 = 0
        var valAfter04 = 0
        var valAfter05 = 0
        var valAfter06 = 0
        var valAfter07 = 0
        var valAfter08 = 0
        var valAfter09 = 0
        var valAfter10 = 0
        var valAfter11 = 0
        var valAfter12 = 0

        lblBefore01.text = strBefore01
        lblBefore02.text = strBefore02
        lblBefore03.text = strBefore03
        lblBefore04.text = strBefore04
        lblBefore05.text = strBefore05
        lblBefore06.text = strBefore06
        lblBefore07.text = strBefore07
        lblBefore08.text = strBefore08
        lblBefore09.text = strBefore09
        lblBefore10.text = strBefore10
        lblBefore11.text = strBefore11
        lblBefore12.text = strBefore12

        lblAfter01.text = strAfter01
        lblAfter02.text = strAfter02
        lblAfter03.text = strAfter03
        lblAfter04.text = strAfter04
        lblAfter05.text = strAfter05
        lblAfter06.text = strAfter06
        lblAfter07.text = strAfter07
        lblAfter08.text = strAfter08
        lblAfter09.text = strAfter09
        lblAfter10.text = strAfter10
        lblAfter11.text = strAfter11
        lblAfter12.text = strAfter12

        for dic in arrayBefore {
            let month = (dic as! NSDictionary)["month"] as! String
            let average = (dic as! NSDictionary)["average"] as! NSNumber
            let intAvarage = average.intValue
            let strAvarage = average.stringValue
            let unit = "mg/dl"
            if (intAvarage < 80 || intAvarage > 130) {
                coutValuofRange = coutValuofRange + 1
            }
            
            if month == "01" {
                strBefore01 = String(format: "%@%@", strAvarage, unit)
                valBefore01 = intAvarage
            }
            if month == "02" {
                strBefore02 = String(format: "%@%@", strAvarage, unit)
                valBefore02 = intAvarage
            }
            if month == "03" {
                strBefore03 = String(format: "%@%@", strAvarage, unit)
                valBefore03 = intAvarage
            }
            if month == "04" {
                strBefore04 = String(format: "%@%@", strAvarage, unit)
                valBefore04 = intAvarage
            }
            if month == "05" {
                strBefore05 = String(format: "%@%@", strAvarage, unit)
                valBefore05 = intAvarage
            }
            if month == "06" {
                strBefore06 = String(format: "%@%@", strAvarage, unit)
                valBefore06 = intAvarage
            }
            if month == "07" {
                strBefore07 = String(format: "%@%@", strAvarage, unit)
                valBefore07 = intAvarage
            }
            if month == "08" {
                strBefore08 = String(format: "%@%@", strAvarage, unit)
                valBefore08 = intAvarage
            }
            if month == "09" {
                strBefore09 = String(format: "%@%@", strAvarage, unit)
                valBefore09 = intAvarage
            }
            if month == "10" {
                strBefore10 = String(format: "%@%@", strAvarage, unit)
                valBefore10 = intAvarage
            }
            if month == "11" {
                strBefore11 = String(format: "%@%@", strAvarage, unit)
                valBefore11 = intAvarage
            }
            if month == "12" {
                strBefore12 = String(format: "%@%@", strAvarage, unit)
                valBefore12 = intAvarage
            }
        }
        
        for dic in arrayafter {
            let month = (dic as! NSDictionary)["month"] as! String
            let average = (dic as! NSDictionary)["average"] as! NSNumber
            let intAvarage = average.intValue
            let strAvarage = average.stringValue
            let unit = "mg/dl"
            if (intAvarage > 80) {
                coutValuofRange = coutValuofRange + 1
            }
            
            if month == "01" {
                strAfter01 = String(format: "%@%@", strAvarage, unit)
                valAfter01 = intAvarage
            }
            if month == "02" {
                strAfter02 = String(format: "%@%@", strAvarage, unit)
                valAfter02 = intAvarage
            }
            if month == "03" {
                strAfter03 = String(format: "%@%@", strAvarage, unit)
                valAfter03 = intAvarage
            }
            if month == "04" {
                strAfter04 = String(format: "%@%@", strAvarage, unit)
                valAfter04 = intAvarage
            }
            if month == "05" {
                strAfter05 = String(format: "%@%@", strAvarage, unit)
                valAfter05 = intAvarage
            }
            if month == "06" {
                strAfter06 = String(format: "%@%@", strAvarage, unit)
                valAfter06 = intAvarage
            }
            if month == "07" {
                strAfter07 = String(format: "%@%@", strAvarage, unit)
                valAfter07 = intAvarage
            }
            if month == "08" {
                strAfter08 = String(format: "%@%@", strAvarage, unit)
                valAfter08 = intAvarage
            }
            if month == "09" {
                strAfter09 = String(format: "%@%@", strAvarage, unit)
                valAfter09 = intAvarage
            }
            if month == "10" {
                strAfter10 = String(format: "%@%@", strAvarage, unit)
                valAfter10 = intAvarage
            }
            if month == "11" {
                strAfter11 = String(format: "%@%@", strAvarage, unit)
                valAfter11 = intAvarage
            }
            if month == "12" {
                strAfter12 = String(format: "%@%@", strAvarage, unit)
                valAfter12 = intAvarage
            }
        }
        
        lblYear.text = strYear
        lblOutofRange.text = String(format: "Values out of Range: %li", coutValuofRange)
        
        lblBefore01.text = strBefore01
        lblBefore02.text = strBefore02
        lblBefore03.text = strBefore03
        lblBefore04.text = strBefore04
        lblBefore05.text = strBefore05
        lblBefore06.text = strBefore06
        lblBefore07.text = strBefore07
        lblBefore08.text = strBefore08
        lblBefore09.text = strBefore09
        lblBefore10.text = strBefore10
        lblBefore11.text = strBefore11
        lblBefore12.text = strBefore12
        
        lblAfter01.text = strAfter01
        lblAfter02.text = strAfter02
        lblAfter03.text = strAfter03
        lblAfter04.text = strAfter04
        lblAfter05.text = strAfter05
        lblAfter06.text = strAfter06
        lblAfter07.text = strAfter07
        lblAfter08.text = strAfter08
        lblAfter09.text = strAfter09
        lblAfter10.text = strAfter10
        lblAfter11.text = strAfter11
        lblAfter12.text = strAfter12
        
        let xVal = NSArray.init(array: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
        let yVal1 = NSArray.init(array: [valBefore01, valBefore02, valBefore03,
                                         valBefore04, valBefore05, valBefore06,
                                         valBefore07, valBefore08, valBefore09,
                                         valBefore10, valBefore11, valBefore12])
        let yVal2 = NSArray.init(array: [valAfter01, valAfter02, valAfter03,
                                         valAfter04, valAfter05, valAfter06,
                                         valAfter07, valAfter08, valAfter09,
                                         valAfter10, valAfter11, valAfter12])
        
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
