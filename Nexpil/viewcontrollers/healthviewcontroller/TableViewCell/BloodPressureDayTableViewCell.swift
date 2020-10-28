//
//  BloodPressureDayTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/31.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import Charts

class BloodPressureDayTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgValues: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblOutofRange: UILabel!
    @IBOutlet weak var lblSubTitle1: UILabel!
    @IBOutlet weak var lblSubTitle2: UILabel!
    @IBOutlet weak var lblSubTitle3: UILabel!
    @IBOutlet weak var lblSubTitle4: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var lblTime1: UILabel!
    @IBOutlet weak var lblTime2: UILabel!
    @IBOutlet weak var lblTime3: UILabel!
    @IBOutlet weak var lblValue1: UILabel!
    @IBOutlet weak var lblValue2: UILabel!
    @IBOutlet weak var lblValue3: UILabel!
    
    var dateFormatterGet = DateFormatter()
    var dateFormatterPrint = DateFormatter()
    var sendDic = NSDictionary()
    var countOutofRange = NSInteger()
    
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
        
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        dateFormatterPrint.dateFormat = "MMMM d, yyyy"
        
        lblDate.font = UIFont.init(name: "Montserrat", size: 30)
        lblOutofRange.font = UIFont.init(name: "Montserrat", size: 20)
        lblSubTitle1.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle2.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle3.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle4.font = UIFont.init(name: "Montserrat", size: 15)

        lblTime1.font = UIFont.init(name: "Montserrat", size: 15)
        lblTime2.font = UIFont.init(name: "Montserrat", size: 15)
        lblTime3.font = UIFont.init(name: "Montserrat", size: 15)

        lblValue1.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue2.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue3.font = UIFont.init(name: "Montserrat", size: 15)

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

        // date string
        let day = dic["day"] as! String
        let arrayData = dic["data"] as! NSArray
        
        if let date = dateFormatterGet.date(from: day) {
            lblDate.text = dateFormatterPrint.string(from: date)
        } else {
            lblDate.text = ""
        }

        var val0_1 = 0
        var val0_2 = 0
        var val1_1 = 0
        var val1_2 = 0
        var val2_1 = 0
        var val2_2 = 0

        let unit = "mmHg"
        lblTime1.text = "-"
        lblTime2.text = "-"
        lblTime3.text = "-"

        lblValue1.text = "-"
        lblValue2.text = "-"
        lblValue3.text = "-"
        
        for dicDate in arrayData {
            let model = dicDate as! BloodPressure
            let timeIndex = model.timeIndex
            let time = model.time
            let value1 = Int(model.value1)
            let value2 = Int(model.value2)
            
            let strTime = "-"
            let srtValue = String(format: "%li/%li%@", value1, value2, unit)

            if (value1 > 0 && value1 > 140) || (value2 > 0 && value2 < 90) {
                countOutofRange = countOutofRange + 1
            }

            if timeIndex == "0" {
                val0_1 = value1
                val0_2 = value2
                
                lblTime1.text = time
                lblValue1.text = String(format: "%li/%li%@", value1, value2, unit)
                
            } else if timeIndex == "1" {
                val1_1 = value1
                val1_2 = value2

                lblTime2.text = time
                lblValue2.text = String(format: "%li/%li%@", value1, value2, unit)

            } else if timeIndex == "2" {
                val2_1 = value1
                val2_2 = value2
                
                lblTime3.text = time
                lblValue3.text = String(format: "%li/%li%@", value1, value2, unit)
                
            }
            
        }
        
        lblOutofRange.text = String(format: "Values out of Range: %li", countOutofRange)
        
        // chart viiew
        let xVal = NSArray.init(array: [8, 14, 16])
        let yVal1 = NSArray.init(array: [val0_1, val1_1, val2_1])
        let yVal2 = NSArray.init(array: [val0_2, val1_2, val2_2])

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
