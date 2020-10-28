//
//  OxygenLevelsDayTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/31.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import Charts

class OxygenLevelsDayTableViewCell: UITableViewCell {

    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgValues: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblOutofRange: UILabel!
    
    @IBOutlet weak var lblSub1: UILabel!
    @IBOutlet weak var lblSub2: UILabel!
    @IBOutlet weak var lblSub3: UILabel!
    @IBOutlet weak var lblSub4: UILabel!
    @IBOutlet weak var lblSub5: UILabel!

    @IBOutlet weak var lblTime1: UILabel!
    @IBOutlet weak var lblTime2: UILabel!
    @IBOutlet weak var lblTime3: UILabel!

    @IBOutlet weak var lblValue0: UILabel!
    @IBOutlet weak var lblValue1: UILabel!
    @IBOutlet weak var lblValue2: UILabel!
    
    var dateFormatterGet = DateFormatter()
    var dateFormatterPrint = DateFormatter()
    var countOutofRange = NSInteger()
    
    var val0 = NSInteger()
    var val1 = NSInteger()
    var val2 = NSInteger()
    
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
        lblSub1.font = UIFont.init(name: "Montserrat", size: 15)
        lblSub2.font = UIFont.init(name: "Montserrat", size: 15)
        lblSub3.font = UIFont.init(name: "Montserrat", size: 15)
        lblSub4.font = UIFont.init(name: "Montserrat", size: 15)
        lblSub5.font = UIFont.init(name: "Montserrat", size: 15)

        lblTime1.font = UIFont.init(name: "Montserrat", size: 15)
        lblTime2.font = UIFont.init(name: "Montserrat", size: 15)
        lblTime3.font = UIFont.init(name: "Montserrat", size: 15)

        lblValue0.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue1.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue2.font = UIFont.init(name: "Montserrat", size: 15)

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
    
    func setInfo(dic: NSDictionary) {
        countOutofRange = 0
        
        val0 = 0
        val1 = 0
        val2 = 0
        
        lblTime1.text = "-"
        lblTime2.text = "-"
        lblTime3.text = "-"
        
        lblValue0.text = "-"
        lblValue1.text = "-"
        lblValue2.text = "-"
        
        // date string
        let day = dic["day"] as! String
        let arrayData = dic["data"] as! NSArray
        
        if let date = dateFormatterGet.date(from: day) {
            lblDate.text = dateFormatterPrint.string(from: date)
        } else {
            lblDate.text = ""
        }
        
        // data
        for dicDate in arrayData {
            let model = dicDate as! OxygenLevel
            let time = model.time
            let timeIndex = model.timeIndex
            let value = Int(model.value)
            let strValue = String(format: "%li%%", value)
            
            if timeIndex == "0" {
                lblTime1.text = time
                lblValue0.text = strValue
                val0 = value

                // get values of range count
                if value < 90 {
                    countOutofRange = countOutofRange + 1
                }
                
            } else if timeIndex == "1" {
                lblTime2.text = time
                lblValue1.text = strValue
                val1 = value
                
                // get values of range count
                if value < 90 {
                    countOutofRange = countOutofRange + 1
                }

            } else if timeIndex == "2" {
                lblTime3.text = time
                lblValue2.text = strValue
                val2 = value
                
                // get values of range count
                if value < 90 {
                    countOutofRange = countOutofRange + 1
                }

            }
            
        }
        
        lblOutofRange.text = String(format: "Values out of Range: %li", countOutofRange)
        
        // chart viiew
        let xVal = NSArray.init(array: [8, 14, 20])
        let yVal = NSArray.init(array: [val0, val1, val2])
        
        self.setChartView(xVal: xVal, yVal: yVal)
    }
}
