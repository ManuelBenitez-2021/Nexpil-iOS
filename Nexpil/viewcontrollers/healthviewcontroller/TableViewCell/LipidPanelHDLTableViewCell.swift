//
//  LipidPanelHDLTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/31.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import Charts

class LipidPanelHDLTableViewCell: UITableViewCell {

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
    
    @IBOutlet weak var lblVal01: UILabel!
    @IBOutlet weak var lblVal02: UILabel!
    @IBOutlet weak var lblVal03: UILabel!
    @IBOutlet weak var lblVal04: UILabel!
    @IBOutlet weak var lblVal05: UILabel!
    @IBOutlet weak var lblVal06: UILabel!
    @IBOutlet weak var lblVal07: UILabel!
    @IBOutlet weak var lblVal08: UILabel!
    @IBOutlet weak var lblVal09: UILabel!
    @IBOutlet weak var lblVal10: UILabel!
    @IBOutlet weak var lblVal11: UILabel!
    @IBOutlet weak var lblVal12: UILabel!
    
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
        lblVal01.font = UIFont.init(name: "Montserrat", size: 15)
        lblVal02.font = UIFont.init(name: "Montserrat", size: 15)
        lblVal03.font = UIFont.init(name: "Montserrat", size: 15)
        lblVal04.font = UIFont.init(name: "Montserrat", size: 15)
        lblVal05.font = UIFont.init(name: "Montserrat", size: 15)
        lblVal06.font = UIFont.init(name: "Montserrat", size: 15)
        lblVal07.font = UIFont.init(name: "Montserrat", size: 15)
        lblVal08.font = UIFont.init(name: "Montserrat", size: 15)
        lblVal09.font = UIFont.init(name: "Montserrat", size: 15)
        lblVal10.font = UIFont.init(name: "Montserrat", size: 15)
        lblVal11.font = UIFont.init(name: "Montserrat", size: 15)
        lblVal12.font = UIFont.init(name: "Montserrat", size: 15)

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
        let arrayData = dic["data"] as! NSArray
        
        var strVal01 = "-"
        var strVal02 = "-"
        var strVal03 = "-"
        var strVal04 = "-"
        var strVal05 = "-"
        var strVal06 = "-"
        var strVal07 = "-"
        var strVal08 = "-"
        var strVal09 = "-"
        var strVal10 = "-"
        var strVal11 = "-"
        var strVal12 = "-"
        
        var coutValueofRange = 0
        
        var val01 = 0
        var val02 = 0
        var val03 = 0
        var val04 = 0
        var val05 = 0
        var val06 = 0
        var val07 = 0
        var val08 = 0
        var val09 = 0
        var val10 = 0
        var val11 = 0
        var val12 = 0
        
        lblVal01.text = strVal01
        lblVal02.text = strVal02
        lblVal03.text = strVal03
        lblVal04.text = strVal04
        lblVal05.text = strVal05
        lblVal06.text = strVal06
        lblVal07.text = strVal07
        lblVal08.text = strVal08
        lblVal09.text = strVal09
        lblVal10.text = strVal10
        lblVal11.text = strVal11
        lblVal12.text = strVal12
        
        for dic in arrayData {
            let month = (dic as! NSDictionary)["month"] as! String
            let average = (dic as! NSDictionary)["average"] as! NSNumber
            let intAvarage = average.intValue
            let strAvarage = average.stringValue
            let unit = "mg/dl"
            if (intAvarage > 100) {
                coutValueofRange = coutValueofRange + 1
            }
            
            if month == "01" {
                strVal01 = String(format: "%@%@", strAvarage, unit)
                val01 = intAvarage
            }
            if month == "02" {
                strVal02 = String(format: "%@%@", strAvarage, unit)
                val02 = intAvarage
            }
            if month == "03" {
                strVal03 = String(format: "%@%@", strAvarage, unit)
                val03 = intAvarage
            }
            if month == "04" {
                strVal04 = String(format: "%@%@", strAvarage, unit)
                val04 = intAvarage
            }
            if month == "05" {
                strVal05 = String(format: "%@%@", strAvarage, unit)
                val05 = intAvarage
            }
            if month == "06" {
                strVal06 = String(format: "%@%@", strAvarage, unit)
                val06 = intAvarage
            }
            if month == "07" {
                strVal07 = String(format: "%@%@", strAvarage, unit)
                val07 = intAvarage
            }
            if month == "08" {
                strVal08 = String(format: "%@%@", strAvarage, unit)
                val08 = intAvarage
            }
            if month == "09" {
                strVal09 = String(format: "%@%@", strAvarage, unit)
                val09 = intAvarage
            }
            if month == "10" {
                strVal10 = String(format: "%@%@", strAvarage, unit)
                val10 = intAvarage
            }
            if month == "11" {
                strVal11 = String(format: "%@%@", strAvarage, unit)
                val11 = intAvarage
            }
            if month == "12" {
                strVal12 = String(format: "%@%@", strAvarage, unit)
                val12 = intAvarage
            }
        }
        
        lblYear.text = strYear
        lblOutofRange.text = String(format: "Values out of Range: %li", coutValueofRange)
        
        lblVal01.text = strVal01
        lblVal02.text = strVal02
        lblVal03.text = strVal03
        lblVal04.text = strVal04
        lblVal05.text = strVal05
        lblVal06.text = strVal06
        lblVal07.text = strVal07
        lblVal08.text = strVal08
        lblVal09.text = strVal09
        lblVal10.text = strVal10
        lblVal11.text = strVal11
        lblVal12.text = strVal12
        
        let xVal = NSArray.init(array: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
        let yVal = NSArray.init(array: [val01, val02, val03,
                                        val04, val05, val06,
                                        val07, val08, val09,
                                        val10, val11, val12])
        
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
        let gradientColors = [ChartColorTemplates.colorFromString("#b2acf0").cgColor,
                              ChartColorTemplates.colorFromString("#958eeb").cgColor]
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
