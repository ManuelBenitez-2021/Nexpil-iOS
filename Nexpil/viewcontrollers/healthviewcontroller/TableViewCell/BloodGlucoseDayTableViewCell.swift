//
//  BloodGlucoseDayTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/31.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import Charts

protocol BloodGlucoseDayTableViewCellDelegate: class {
    func didTapButtonBloodGlucoseDayTableViewCell(index: NSInteger,
                                                  sendDic: NSDictionary)
}

class BloodGlucoseDayTableViewCell: UITableViewCell {

    weak var delegate:BloodGlucoseDayTableViewCellDelegate?
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblOutofRange: UILabel!
    @IBOutlet weak var lblSubTitle1: UILabel!
    @IBOutlet weak var lblSubTitle2: UILabel!
    @IBOutlet weak var lblSubTitle3: UILabel!
    @IBOutlet weak var lblSubTitle4: UILabel!
    @IBOutlet weak var lblSubTitle5: UILabel!
    @IBOutlet weak var lblSubTitle6: UILabel!
    @IBOutlet weak var lblSubTitle7: UILabel!
    @IBOutlet weak var lblTime1: UILabel!
    @IBOutlet weak var lblTime2: UILabel!
    @IBOutlet weak var lblTime3: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgValues: UIView!
    
    @IBOutlet weak var btnValue0: UIButton!
    @IBOutlet weak var btnValue1: UIButton!
    @IBOutlet weak var btnValue2: UIButton!
    @IBOutlet weak var btnValue3: UIButton!
    @IBOutlet weak var btnValue4: UIButton!
    @IBOutlet weak var btnValue5: UIButton!
    
    @IBOutlet weak var chartView: LineChartView!
    
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
        
        btnValue0.tag = 0
        btnValue1.tag = 1
        btnValue2.tag = 2
        btnValue3.tag = 3
        btnValue4.tag = 4
        btnValue5.tag = 5

        lblDate.font = UIFont.init(name: "Montserrat", size: 30)
        lblOutofRange.font = UIFont.init(name: "Montserrat", size: 20)
        lblSubTitle1.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle2.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle3.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle4.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle5.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle6.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle7.font = UIFont.init(name: "Montserrat", size: 15)

        lblTime1.font = UIFont.init(name: "Montserrat", size: 15)
        lblTime2.font = UIFont.init(name: "Montserrat", size: 15)
        lblTime3.font = UIFont.init(name: "Montserrat", size: 15)

        btnValue0.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnValue1.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnValue2.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnValue3.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnValue4.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnValue5.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)

        
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
        sendDic = dic
        
        // date string
        let day = dic["day"] as! String
        let arrayData = dic["data"] as! NSArray
        
        if let date = dateFormatterGet.date(from: day) {
            lblDate.text = dateFormatterPrint.string(from: date)
        } else {
            lblDate.text = ""
        }
        
        // data
        btnValue0.setTitle("Add", for: .normal)
        btnValue1.setTitle("Add", for: .normal)
        btnValue2.setTitle("Add", for: .normal)
        btnValue3.setTitle("Add", for: .normal)
        btnValue4.setTitle("Add", for: .normal)
        btnValue5.setTitle("Add", for: .normal)

        btnValue0.setTitleColor(nil, for: .normal)
        btnValue1.setTitleColor(nil, for: .normal)
        btnValue2.setTitleColor(nil, for: .normal)
        btnValue3.setTitleColor(nil, for: .normal)
        btnValue4.setTitleColor(nil, for: .normal)
        btnValue5.setTitleColor(nil, for: .normal)

        btnValue0.isEnabled = true
        btnValue1.isEnabled = true
        btnValue2.isEnabled = true
        btnValue3.isEnabled = true
        btnValue4.isEnabled = true
        btnValue5.isEnabled = true
        
        var val0 = Double()
        var val1 = Double()
        var val2 = Double()
        var val3 = Double()
        var val4 = Double()
        var val5 = Double()

        for dicDate in arrayData {
            let model = dicDate as! BloodGlucose
            let whenIndex = model.whenIndex
            let value = Int(model.value)
            let srtValue = String(format: "%li mg/dl", value)
            
            if whenIndex == "0" {
                btnValue0.setTitle(srtValue, for: .normal)
                btnValue0.isEnabled = false
                btnValue0.setTitleColor(UIColor.init(hexString: "333333"), for: .normal)
                
                // get values of range count
                if (value < 80 || value > 130) {
                    countOutofRange = countOutofRange + 1
                }
                val0 = Double(model.value)
                
            } else if whenIndex == "1" {
                btnValue1.setTitle(srtValue, for: .normal)
                btnValue1.isEnabled = false
                btnValue1.setTitleColor(UIColor.init(hexString: "333333"), for: .normal)

                // get values of range count
                if (value < 80 || value > 130) {
                    countOutofRange = countOutofRange + 1
                }
                
                val1 = Double(model.value)
                
            } else if whenIndex == "2" {
                btnValue2.setTitle(srtValue, for: .normal)
                btnValue2.isEnabled = false
                btnValue2.setTitleColor(UIColor.init(hexString: "333333"), for: .normal)

                // get values of range count
                if (value < 80 || value > 130) {
                    countOutofRange = countOutofRange + 1
                }
                
                val2 = Double(model.value)

            } else if whenIndex == "3" {
                btnValue3.setTitle(srtValue, for: .normal)
                btnValue3.isEnabled = false
                btnValue3.setTitleColor(UIColor.init(hexString: "333333"), for: .normal)

                // get values of range count
                if (value > 180) {
                    countOutofRange = countOutofRange + 1
                }
                
                val3 = Double(model.value)

            } else if whenIndex == "4" {
                btnValue4.setTitle(srtValue, for: .normal)
                btnValue4.isEnabled = false
                btnValue4.setTitleColor(UIColor.init(hexString: "333333"), for: .normal)

                // get values of range count
                if (value > 180) {
                    countOutofRange = countOutofRange + 1
                }
                
                val4 = Double(model.value)
                
            } else if whenIndex == "5" {
                btnValue5.setTitle(srtValue, for: .normal)
                btnValue5.isEnabled = false
                btnValue5.setTitleColor(UIColor.init(hexString: "333333"), for: .normal)

                // get values of range count
                if (value > 180) {
                    countOutofRange = countOutofRange + 1
                }
             
                val5 = Double(model.value)

            }
            
        }

        lblOutofRange.text = String(format: "Values out of Range: %li", countOutofRange)
        
        // chart viiew
        self.setChartView(xVal: [8, 12, 16], yVal1: [val0, val1, val2], yVal2: [val3, val4, val5])
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
    
    
    
    @IBAction func tapBtnValue(_ sender: Any) {
        let tag = (sender as AnyObject).tag as NSInteger
        self.delegate?.didTapButtonBloodGlucoseDayTableViewCell(index: tag,
                                                                sendDic: sendDic)
    }
    
    
    
}
