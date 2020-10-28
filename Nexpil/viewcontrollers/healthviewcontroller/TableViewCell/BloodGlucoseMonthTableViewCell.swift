//
//  BloodGlucoseMonthTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/31.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import Charts

class BloodGlucoseMonthTableViewCell: UITableViewCell {

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
    @IBOutlet weak var lblMonth0106: UILabel!
    @IBOutlet weak var lblMonth0713: UILabel!
    @IBOutlet weak var lblMonth1420: UILabel!
    @IBOutlet weak var lblMonth2127: UILabel!
    @IBOutlet weak var lblMonth2830: UILabel!
    @IBOutlet weak var lblBefore0106: UILabel!
    @IBOutlet weak var lblBefore0713: UILabel!
    @IBOutlet weak var lblBefore1420: UILabel!
    @IBOutlet weak var lblBefore2127: UILabel!
    @IBOutlet weak var lblBefore2830: UILabel!
    @IBOutlet weak var lblAfter0106: UILabel!
    @IBOutlet weak var lblAfter0713: UILabel!
    @IBOutlet weak var lblAfter1420: UILabel!
    @IBOutlet weak var lblAfter2127: UILabel!
    @IBOutlet weak var lblAfter2830: UILabel!

    var dateFormatterGet = DateFormatter()
    var dateFormatterPrint = DateFormatter()
    var dateFormatterPrint2 = DateFormatter()
    var countOutofRange = NSInteger()
    var strMonth = ""
    
    var valBefore0106 = NSInteger()
    var valBefore0713 = NSInteger()
    var valBefore1420 = NSInteger()
    var valBefore2127 = NSInteger()
    var valBefore2830 = NSInteger()
    var valAfter0106 = NSInteger()
    var valAfter0713 = NSInteger()
    var valAfter1420 = NSInteger()
    var valAfter2127 = NSInteger()
    var valAfter2830 = NSInteger()

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
        dateFormatterPrint.dateFormat = "MMMM, yyyy"
        dateFormatterPrint2.dateFormat = "MMM"

        lblYear.font = UIFont.init(name: "Montserrat", size: 30)
        lblOutofRang.font = UIFont.init(name: "Montserrat", size: 20)
        lblSubTitle1.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle2.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle3.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle4.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle5.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle6.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle7.font = UIFont.init(name: "Montserrat", size: 15)

        lblMonth0106.font = UIFont.init(name: "Montserrat", size: 15)
        lblMonth0713.font = UIFont.init(name: "Montserrat", size: 15)
        lblMonth1420.font = UIFont.init(name: "Montserrat", size: 15)
        lblMonth2127.font = UIFont.init(name: "Montserrat", size: 15)
        lblMonth2830.font = UIFont.init(name: "Montserrat", size: 15)

        lblBefore0106.font = UIFont.init(name: "Montserrat", size: 15)
        lblBefore0713.font = UIFont.init(name: "Montserrat", size: 15)
        lblBefore1420.font = UIFont.init(name: "Montserrat", size: 15)
        lblBefore2127.font = UIFont.init(name: "Montserrat", size: 15)
        lblBefore2830.font = UIFont.init(name: "Montserrat", size: 15)

        lblAfter0106.font = UIFont.init(name: "Montserrat", size: 15)
        lblAfter0713.font = UIFont.init(name: "Montserrat", size: 15)
        lblAfter1420.font = UIFont.init(name: "Montserrat", size: 15)
        lblAfter2127.font = UIFont.init(name: "Montserrat", size: 15)
        lblAfter2830.font = UIFont.init(name: "Montserrat", size: 15)

        
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
        let strDate = dic["month"] as! String
        let unit = "mg/dl"
        var strBefore0106 = "-"
        var strBefore0713 = "-"
        var strBefore1420 = "-"
        var strBefore2127 = "-"
        var strBefore2830 = "-"
        var strAfter0106 = "-"
        var strAfter0713 = "-"
        var strAfter1420 = "-"
        var strAfter2127 = "-"
        var strAfter2830 = "-"

        countOutofRange = 0
        
        if let date = dateFormatterGet.date(from: strDate) {
            lblYear.text = dateFormatterPrint.string(from: date)
            strMonth = dateFormatterPrint2.string(from: date)
        }
        
        lblMonth0106.text = String(format: "%@ 1-6", strMonth)
        lblMonth0713.text = String(format: "%@ 7-13", strMonth)
        lblMonth1420.text = String(format: "%@ 14-20", strMonth)
        lblMonth2127.text = String(format: "%@ 21-27", strMonth)
        lblMonth2830.text = String(format: "%@ 28-30", strMonth)
        
        valBefore0106 = dic["before0106"] as! NSInteger
        valBefore0713 = dic["before0713"] as! NSInteger
        valBefore1420 = dic["before1420"] as! NSInteger
        valBefore2127 = dic["before2127"] as! NSInteger
        valBefore2830 = dic["before2830"] as! NSInteger
        valAfter0106 = dic["after0106"] as! NSInteger
        valAfter0713 = dic["after0713"] as! NSInteger
        valAfter1420 = dic["after1420"] as! NSInteger
        valAfter2127 = dic["after2127"] as! NSInteger
        valAfter2830 = dic["after2830"] as! NSInteger

        if valBefore0106 > 0 {
            strBefore0106 = String(format: "%li%@", valBefore0106, unit)
        }
        if valBefore0713 > 0 {
            strBefore0713 = String(format: "%li%@", valBefore0713, unit)
        }
        if valBefore1420 > 0 {
            strBefore1420 = String(format: "%li%@", valBefore1420, unit)
        }
        if valBefore2127 > 0 {
            strBefore2127 = String(format: "%li%@", valBefore2127, unit)
        }
        if valBefore2830 > 0 {
            strBefore2830 = String(format: "%li%@", valBefore2830, unit)
        }

        if valAfter0106 > 0 {
            strAfter0106 = String(format: "%li%@", valAfter0106, unit)
        }
        if valAfter0713 > 0 {
            strAfter0713 = String(format: "%li%@", valAfter0713, unit)
        }
        if valAfter1420 > 0 {
            strAfter1420 = String(format: "%li%@", valAfter1420, unit)
        }
        if valAfter2127 > 0 {
            strAfter2127 = String(format: "%li%@", valAfter2127, unit)
        }
        if valAfter2830 > 0 {
            strAfter2830 = String(format: "%li%@", valAfter2830, unit)
        }
        
        lblBefore0106.text = strBefore0106
        lblBefore0713.text = strBefore0713
        lblBefore1420.text = strBefore1420
        lblBefore2127.text = strBefore2127
        lblBefore2830.text = strBefore2830
        
        lblAfter0106.text = strAfter0106
        lblAfter0713.text = strAfter0713
        lblAfter1420.text = strAfter1420
        lblAfter2127.text = strAfter2127
        lblAfter2830.text = strAfter2830

        // out of range
        if valBefore0106 > 0 && (valBefore0106 < 80 || valBefore0106 > 130) {
            countOutofRange = countOutofRange + 1
        }
        if valBefore0713 > 0 && (valBefore0713 < 80 || valBefore0713 > 130) {
            countOutofRange = countOutofRange + 1
        }
        if valBefore1420 > 0 && (valBefore1420 < 80 || valBefore1420 > 130) {
            countOutofRange = countOutofRange + 1
        }
        if valBefore2127 > 0 && (valBefore2127 < 80 || valBefore2127 > 130) {
            countOutofRange = countOutofRange + 1
        }
        if valBefore2830 > 0 && (valBefore2830 < 80 || valBefore2830 > 130) {
            countOutofRange = countOutofRange + 1
        }
        if valAfter0106 > 180 {
            countOutofRange = countOutofRange + 1
        }
        if valAfter0713 > 180 {
            countOutofRange = countOutofRange + 1
        }
        if valAfter1420 > 180 {
            countOutofRange = countOutofRange + 1
        }
        if valAfter2127 > 180 {
            countOutofRange = countOutofRange + 1
        }
        if valAfter2830 > 180 {
            countOutofRange = countOutofRange + 1
        }

        lblOutofRang.text = String(format: "Values out of Range: %li", countOutofRange)
     
        // chart
        let xVal = NSArray.init(objects: 1, 7, 14, 21, 28)
        let yVal1 = NSArray.init(objects: valBefore0106, valBefore0713, valBefore1420, valBefore2127, valBefore2830)
        let yVal2 = NSArray.init(objects: valAfter0106, valAfter0713, valAfter1420, valAfter2127, valAfter2830)
        
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
