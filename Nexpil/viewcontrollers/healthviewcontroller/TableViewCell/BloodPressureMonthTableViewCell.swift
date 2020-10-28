//
//  BloodPressureMonthTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/31.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import Charts

class BloodPressureMonthTableViewCell: UITableViewCell {

    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgValues: UIView!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblOutofRang: UILabel!
    @IBOutlet weak var lblSub1: UILabel!
    @IBOutlet weak var lblSub2: UILabel!
    @IBOutlet weak var lblSub3: UILabel!
    @IBOutlet weak var lblSub4: UILabel!
    
    @IBOutlet weak var lblMonth0106: UILabel!
    @IBOutlet weak var lblMonth0713: UILabel!
    @IBOutlet weak var lblMonth1420: UILabel!
    @IBOutlet weak var lblMonth2127: UILabel!
    @IBOutlet weak var lblMonth2830: UILabel!
    @IBOutlet weak var lblValue0106: UILabel!
    @IBOutlet weak var lblValue0713: UILabel!
    @IBOutlet weak var lblValue1420: UILabel!
    @IBOutlet weak var lblValue2127: UILabel!
    @IBOutlet weak var lblValue2830: UILabel!

    
    var dateFormatterGet = DateFormatter()
    var dateFormatterPrint = DateFormatter()
    var dateFormatterPrint2 = DateFormatter()
    var countOutofRange = NSInteger()
    var strMonth = ""
    
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
        lblSub1.font = UIFont.init(name: "Montserrat", size: 15)
        lblSub2.font = UIFont.init(name: "Montserrat", size: 15)
        lblSub3.font = UIFont.init(name: "Montserrat", size: 15)
        lblSub4.font = UIFont.init(name: "Montserrat", size: 15)

        lblMonth0106.font = UIFont.init(name: "Montserrat", size: 15)
        lblMonth0713.font = UIFont.init(name: "Montserrat", size: 15)
        lblMonth1420.font = UIFont.init(name: "Montserrat", size: 15)
        lblMonth2127.font = UIFont.init(name: "Montserrat", size: 15)
        lblMonth2830.font = UIFont.init(name: "Montserrat", size: 15)

        lblValue0106.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue0713.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue1420.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue2127.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue2830.font = UIFont.init(name: "Montserrat", size: 15)


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
        let unit = "mmHg"
        
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
        
        let val1_0106 = dic["avg1_0106"] as! NSInteger
        let val1_0713 = dic["avg1_0713"] as! NSInteger
        let val1_1420 = dic["avg1_1420"] as! NSInteger
        let val1_2127 = dic["avg1_2127"] as! NSInteger
        let val1_2830 = dic["avg1_2830"] as! NSInteger
        let val2_0106 = dic["avg2_0106"] as! NSInteger
        let val2_0713 = dic["avg2_0713"] as! NSInteger
        let val2_1420 = dic["avg2_1420"] as! NSInteger
        let val2_2127 = dic["avg2_2127"] as! NSInteger
        let val2_2830 = dic["avg2_2830"] as! NSInteger
        
        if (val1_0106 != 0 && val2_0106 != 0) {
            lblValue0106.text = String(format: "%li/%li%@", val1_0106, val2_0106, unit)
        } else {
            lblValue0106.text = "-"
        }
        if (val1_0713 != 0 && val2_0713 != 0) {
            lblValue0713.text = String(format: "%li/%li%@", val1_0713, val2_0713, unit)
        } else {
            lblValue0713.text = "-"
        }
        if (val1_1420 != 0 && val2_1420 != 0) {
            lblValue1420.text = String(format: "%li/%li%@", val1_1420, val2_1420, unit)
        } else {
            lblValue1420.text = "-"
        }
        if (val1_2127 != 0 && val2_2127 != 0) {
            lblValue2127.text = String(format: "%li/%li%@", val1_2127, val2_2127, unit)
        } else {
            lblValue2127.text = "-"
        }
        if (val1_2830 != 0 && val2_2830 != 0) {
            lblValue2830.text = String(format: "%li/%li%@", val1_2830, val2_2830, unit)
        } else {
            lblValue2830.text = "-"
        }
        
        // out of range
        if (val1_0106 > 0 && val1_0106 < 140) || (val2_0106 > 0 && val2_0106 < 90) {
            countOutofRange = countOutofRange + 1
        }
        if (val1_0713 > 0 && val1_0713 < 140) || (val2_0713 > 0 && val2_0713 < 90) {
            countOutofRange = countOutofRange + 1
        }
        if (val1_1420 > 0 && val1_1420 < 140) || (val2_1420 > 0 && val2_1420 < 90) {
            countOutofRange = countOutofRange + 1
        }
        if (val1_2127 > 0 && val1_2127 < 140) || (val2_2127 > 0 && val2_2127 < 90) {
            countOutofRange = countOutofRange + 1
        }
        if (val1_2830 > 0 && val1_2830 < 140) || (val2_2830 > 0 && val2_2830 < 90) {
            countOutofRange = countOutofRange + 1
        }

        lblOutofRang.text = String(format: "Values out of Range: %li", countOutofRange)
        
        // chart
        let xVal = NSArray.init(objects: 1, 7, 14, 21, 28)
        let yVal1 = NSArray.init(objects: val1_0106, val1_0713, val1_1420, val1_2127, val1_2830)
        let yVal2 = NSArray.init(objects: val2_0106, val2_0713, val2_1420, val2_2127, val2_2830)
        
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
