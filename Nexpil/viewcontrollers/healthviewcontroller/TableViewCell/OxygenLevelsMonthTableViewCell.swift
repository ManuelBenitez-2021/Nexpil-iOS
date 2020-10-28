//
//  OxygenLevelsMonthTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/31.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import Charts

class OxygenLevelsMonthTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgValues: UIView!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblOutofRang: UILabel!
    @IBOutlet weak var lblSub1: UILabel!
    @IBOutlet weak var lblSub2: UILabel!
    @IBOutlet weak var lblSub3: UILabel!
    @IBOutlet weak var lblSub4: UILabel!
    @IBOutlet weak var lblSub5: UILabel!
    
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
    
    var val0106 = NSInteger()
    var val0713 = NSInteger()
    var val1420 = NSInteger()
    var val2127 = NSInteger()
    var val2830 = NSInteger()
    
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
        lblSub5.font = UIFont.init(name: "Montserrat", size: 15)

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
        let unit = "%"
        var strValue0106 = "-"
        var strValue0713 = "-"
        var strValue1420 = "-"
        var strValue2127 = "-"
        var strValue2830 = "-"
        
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
        
        val0106 = dic["avg0106"] as! NSInteger
        val0713 = dic["avg0713"] as! NSInteger
        val1420 = dic["avg1420"] as! NSInteger
        val2127 = dic["avg2127"] as! NSInteger
        val2830 = dic["avg2830"] as! NSInteger
        
        if val0106 > 0 {
            strValue0106 = String(format: "%li%@", val0106, unit)
        }
        if val0713 > 0 {
            strValue0713 = String(format: "%li%@", val0713, unit)
        }
        if val1420 > 0 {
            strValue1420 = String(format: "%li%@", val1420, unit)
        }
        if val2127 > 0 {
            strValue2127 = String(format: "%li%@", val2127, unit)
        }
        if val2830 > 0 {
            strValue2830 = String(format: "%li%@", val2830, unit)
        }
        
        lblValue0106.text = strValue0106
        lblValue0713.text = strValue0713
        lblValue1420.text = strValue1420
        lblValue2127.text = strValue2127
        lblValue2830.text = strValue2830
        
        // out of range
        if val0106 > 0 && val0106 < 90 {
            countOutofRange = countOutofRange + 1
        }
        if val0713 > 0 && val0713 < 90 {
            countOutofRange = countOutofRange + 1
        }
        if val1420 > 0 && val1420 < 90 {
            countOutofRange = countOutofRange + 1
        }
        if val2127 > 0 && val2127 < 90 {
            countOutofRange = countOutofRange + 1
        }
        if val2830 > 0 && val2830 < 90 {
            countOutofRange = countOutofRange + 1
        }
        
        lblOutofRang.text = String(format: "Values out of Range: %li", countOutofRange)
        
        // chart
        let xVal = NSArray.init(array: [1, 7, 14, 21, 28])
        let yVal = NSArray.init(array: [val0106, val0713, val1420, val2127, val2830])
        
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
        let gradientColors = [ChartColorTemplates.colorFromString("#7ce2ec").cgColor,
                              ChartColorTemplates.colorFromString("#39d3e3").cgColor]
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
