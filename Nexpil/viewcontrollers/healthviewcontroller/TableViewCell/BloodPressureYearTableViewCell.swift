//
//  BloodPressureYearTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/31.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import Charts

class BloodPressureYearTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgValues: UIView!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblOutofRange: UILabel!
    @IBOutlet weak var lblSub1: UILabel!
    @IBOutlet weak var lblSub2: UILabel!
    @IBOutlet weak var lblSub3: UILabel!
    @IBOutlet weak var lblSub4: UILabel!
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

    @IBOutlet weak var lblValue01: UILabel!
    @IBOutlet weak var lblValue02: UILabel!
    @IBOutlet weak var lblValue03: UILabel!
    @IBOutlet weak var lblValue04: UILabel!
    @IBOutlet weak var lblValue05: UILabel!
    @IBOutlet weak var lblValue06: UILabel!
    @IBOutlet weak var lblValue07: UILabel!
    @IBOutlet weak var lblValue08: UILabel!
    @IBOutlet weak var lblValue09: UILabel!
    @IBOutlet weak var lblValue10: UILabel!
    @IBOutlet weak var lblValue11: UILabel!
    @IBOutlet weak var lblValue12: UILabel!

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
        lblSub1.font = UIFont.init(name: "Montserrat", size: 15)
        lblSub2.font = UIFont.init(name: "Montserrat", size: 15)
        lblSub3.font = UIFont.init(name: "Montserrat", size: 15)
        lblSub4.font = UIFont.init(name: "Montserrat", size: 15)

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

        lblValue01.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue02.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue03.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue04.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue05.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue06.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue07.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue08.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue09.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue10.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue11.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue12.font = UIFont.init(name: "Montserrat", size: 15)

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
        let arrayData1 = dic["data1"] as! NSArray
        let arrayData2 = dic["data2"] as! NSArray
        
      
        var coutValuofRange = 0
        
        var val1_01 = 0
        var val1_02 = 0
        var val1_03 = 0
        var val1_04 = 0
        var val1_05 = 0
        var val1_06 = 0
        var val1_07 = 0
        var val1_08 = 0
        var val1_09 = 0
        var val1_10 = 0
        var val1_11 = 0
        var val1_12 = 0
        
        var val2_01 = 0
        var val2_02 = 0
        var val2_03 = 0
        var val2_04 = 0
        var val2_05 = 0
        var val2_06 = 0
        var val2_07 = 0
        var val2_08 = 0
        var val2_09 = 0
        var val2_10 = 0
        var val2_11 = 0
        var val2_12 = 0
        
        let unit = "mmHg"

        for dic in arrayData1 {
            let month = (dic as! NSDictionary)["month"] as! String
            let average = (dic as! NSDictionary)["average"] as! NSNumber
            let intAvarage = average.intValue
            
            if month == "01" {
               val1_01 = intAvarage
            }
            if month == "02" {
                val1_02 = intAvarage
            }
            if month == "03" {
                val1_03 = intAvarage
            }
            if month == "04" {
                val1_04 = intAvarage
            }
            if month == "05" {
                val1_05 = intAvarage
            }
            if month == "06" {
                val1_06 = intAvarage
            }
            if month == "07" {
                val1_07 = intAvarage
            }
            if month == "08" {
                val1_08 = intAvarage
            }
            if month == "09" {
                val1_09 = intAvarage
            }
            if month == "10" {
                val1_10 = intAvarage
            }
            if month == "11" {
                val1_11 = intAvarage
            }
            if month == "12" {
                val1_12 = intAvarage
            }
        }
        
        for dic in arrayData2 {
            let month = (dic as! NSDictionary)["month"] as! String
            let average = (dic as! NSDictionary)["average"] as! NSNumber
            let intAvarage = average.intValue
            
            if month == "01" {
                val2_01 = intAvarage
            }
            if month == "02" {
                val2_02 = intAvarage
            }
            if month == "03" {
                val2_03 = intAvarage
            }
            if month == "04" {
                val2_04 = intAvarage
            }
            if month == "05" {
                val2_05 = intAvarage
            }
            if month == "06" {
                val2_06 = intAvarage
            }
            if month == "07" {
                val2_07 = intAvarage
            }
            if month == "08" {
                val2_08 = intAvarage
            }
            if month == "09" {
                val2_09 = intAvarage
            }
            if month == "10" {
                val2_10 = intAvarage
            }
            if month == "11" {
                val2_11 = intAvarage
            }
            if month == "12" {
                val2_12 = intAvarage
            }
        }
        
        if val1_01 > 140 || val2_01 > 90 {
            coutValuofRange = coutValuofRange + 1
        }
        if val1_02 > 140 || val2_02 > 90 {
            coutValuofRange = coutValuofRange + 1
        }
        if val1_03 > 140 || val2_03 > 90 {
            coutValuofRange = coutValuofRange + 1
        }
        if val1_04 > 140 || val2_04 > 90 {
            coutValuofRange = coutValuofRange + 1
        }
        if val1_05 > 140 || val2_05 > 90 {
            coutValuofRange = coutValuofRange + 1
        }
        if val1_06 > 140 || val2_06 > 90 {
            coutValuofRange = coutValuofRange + 1
        }
        if val1_07 > 140 || val2_07 > 90 {
            coutValuofRange = coutValuofRange + 1
        }
        if val1_08 > 140 || val2_08 > 90 {
            coutValuofRange = coutValuofRange + 1
        }
        if val1_09 > 140 || val2_09 > 90 {
            coutValuofRange = coutValuofRange + 1
        }
        if val1_10 > 140 || val2_10 > 90 {
            coutValuofRange = coutValuofRange + 1
        }
        if val1_11 > 140 || val2_11 > 90 {
            coutValuofRange = coutValuofRange + 1
        }
        if val1_12 > 140 || val2_12 > 90 {
            coutValuofRange = coutValuofRange + 1
        }

        lblYear.text = strYear
        lblOutofRange.text = String(format: "Values out of Range: %li", coutValuofRange)
        
        if (NSInteger(val1_01) != 0 && NSInteger(val2_01) != 0) {
            lblValue01.text = String(format: "%li/%li%@", NSInteger(val1_01), NSInteger(val2_01), unit)
        } else {
            lblValue01.text = "-"
        }
        if (NSInteger(val1_02) != 0 && NSInteger(val2_02) != 0) {
            lblValue02.text = String(format: "%li/%li%@", NSInteger(val1_02), NSInteger(val2_02), unit)
        } else {
            lblValue02.text = "-"
        }
        if (NSInteger(val1_03) != 0 && NSInteger(val2_03) != 0) {
            lblValue03.text = String(format: "%li/%li%@", NSInteger(val1_03), NSInteger(val2_03), unit)
        } else {
            lblValue03.text = "-"
        }
        if (NSInteger(val1_04) != 0 && NSInteger(val2_04) != 0) {
            lblValue04.text = String(format: "%li/%li%@", NSInteger(val1_04), NSInteger(val2_04), unit)
        } else {
            lblValue04.text = "-"
        }
        if (NSInteger(val1_05) != 0 && NSInteger(val2_05) != 0) {
            lblValue05.text = String(format: "%li/%li%@", NSInteger(val1_05), NSInteger(val2_05), unit)
        } else {
            lblValue05.text = "-"
        }
        if (NSInteger(val1_06) != 0 && NSInteger(val2_06) != 0) {
            lblValue06.text = String(format: "%li/%li%@", NSInteger(val1_06), NSInteger(val2_06), unit)
        } else {
            lblValue06.text = "-"
        }
        if (NSInteger(val1_07) != 0 && NSInteger(val2_07) != 0) {
            lblValue07.text = String(format: "%li/%li%@", NSInteger(val1_07), NSInteger(val2_07), unit)
        } else {
            lblValue07.text = "-"
        }
        if (NSInteger(val1_08) != 0 && NSInteger(val2_08) != 0) {
            lblValue08.text = String(format: "%li/%li%@", NSInteger(val1_08), NSInteger(val2_08), unit)
        } else {
            lblValue08.text = "-"
        }
        if (NSInteger(val1_09) != 0 && NSInteger(val2_09) != 0) {
            lblValue09.text = String(format: "%li/%li%@", NSInteger(val1_09), NSInteger(val2_09), unit)
        } else {
            lblValue09.text = "-"
        }
        if (NSInteger(val1_10) != 0 && NSInteger(val2_10) != 0) {
            lblValue10.text = String(format: "%li/%li%@", NSInteger(val1_10), NSInteger(val2_10), unit)
        } else {
            lblValue10.text = "-"
        }
        if (NSInteger(val1_11) != 0 && NSInteger(val2_11) != 0) {
            lblValue11.text = String(format: "%li/%li%@", NSInteger(val1_11), NSInteger(val2_11), unit)
        } else {
            lblValue11.text = "-"
        }
        if (NSInteger(val1_12) != 0 && NSInteger(val2_12) != 0) {
            lblValue12.text = String(format: "%li/%li%@", NSInteger(val1_12), NSInteger(val2_12), unit)
        } else {
            lblValue12.text = "-"
        }

        let xVal = NSArray.init(array: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
        let yVal1 = NSArray.init(array: [val1_01, val1_02, val1_03,
                                         val1_04, val1_05, val1_06,
                                         val1_07, val1_08, val1_09,
                                         val1_10, val1_11, val1_12])
        let yVal2 = NSArray.init(array: [val2_01, val2_02, val2_03,
                                         val2_04, val2_05, val2_06,
                                         val2_07, val2_08, val2_09,
                                         val2_10, val2_11, val2_12])
        
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
