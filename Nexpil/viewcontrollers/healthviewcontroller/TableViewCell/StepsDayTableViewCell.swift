//
//  StepsDayTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/31.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import Charts

class StepsDayTableViewCell: UITableViewCell {

    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblSubTitle1: UILabel!
    @IBOutlet weak var lblSubTitle2: UILabel!
    @IBOutlet weak var lblSteps: UILabel!
    @IBOutlet weak var lblTitleTarget: UILabel!
    @IBOutlet weak var lblTitleSteps: UILabel!
    @IBOutlet weak var lblValue1: UILabel!
    @IBOutlet weak var lblValue2: UILabel!
    
    var dateFormatterGet = DateFormatter()
    var dateFormatterPrint = DateFormatter()
    
    var manager = DataManager()
    var arrayList = NSArray()
    
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
        
        lblTitle.font = UIFont.init(name: "Montserrat", size: 30)
        lblSubTitle.font = UIFont.init(name: "Montserrat", size: 20)
        lblSubTitle1.font = UIFont.init(name: "Montserrat", size: 15)
        lblSubTitle2.font = UIFont.init(name: "Montserrat", size: 15)
        lblSteps.font = UIFont.init(name: "Montserrat", size: 17)
        lblTitleTarget.font = UIFont.init(name: "Montserrat", size: 14)
        lblTitleSteps.font = UIFont.init(name: "Montserrat", size: 14)
        lblValue1.font = UIFont.init(name: "Montserrat", size: 15)
        lblValue2.font = UIFont.init(name: "Montserrat", size: 15)

        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        dateFormatterPrint.dateFormat = "MMMM d, yyyy"

    }
    
    func initChartView() {
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.rightAxis.axisMinimum = 0
        chartView.rightAxis.spaceBottom = 0
        chartView.leftAxis.spaceBottom = 0
        chartView.chartDescription?.text = ""

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7


    }
    
    /*
    Distance(m) = ((height(cm) - 100)  * steps)/100
    CaloriesPerMile(cal/mile) =  3.7103 + 0.2678 * Weight(kg) + (0.0359*(Weight(kg)*60*0.0006213)*2)*Weight(kg)
    Caloies(cal) = Distance(m) * CaloriesPerMile(cal/mile) * 0.0006213
    */
    func setInfo(dic: NSDictionary) {
        // date string
        let day = dic["day"] as! String
        let data = (dic["data"] as! NSArray)[0] as! Steps
        
        if let date = dateFormatterGet.date(from: day) {
            lblTitle.text = dateFormatterPrint.string(from: date)
        } else {
            lblTitle.text = ""
        }
        
        let steps = data.value
        lblSteps.text = String(format: "%0.0f", steps)
        
        if steps == 0 {
            lblSubTitle.text = "No Data"
        } else if steps < 10000 {
            lblSubTitle.text = "WOW, you are unstoppable!"
        } else {
            lblSubTitle.text = "Great"
        }
        
//        if height > 0 && weight > 0 {
//            let distance = ((height * 100 - 100)  * steps) / 100
//            let distancemile = distance * 0.0006213
//            let caloiespermile = 3.7103 + 0.2678 * weight + (0.0359 * (weight * 60 * 0.0006213) * 2) * weight
//            let caloies = distance * caloiespermile * 0.0006213
//
//            lblValue1.text = String(format: "%0.2f", distancemile)
//            lblValue2.text = String(format: "%0.1f", caloies)
//
//        } else {
//            lblValue1.text = "-"
//            lblValue2.text = "-"
//        }
        
        // fetch steps hour
        self.fetchStepsHour()
        
        // fetch distance
        self.fetchDistanceDay()
        
        
        /*
        // fetch calories
        self.fetchCaloriesDay()
         */
    }
    
    // MARK - Steps hour
    func fetchStepsHour() {
        let array = manager.fetchStepsGetAllHoursData()
        arrayList = NSArray()
        let xVal = NSMutableArray()
        let yVal = NSMutableArray()

        
        if array.count > 0 {
            arrayList = array

            for model in arrayList {
                let value = (model as! StepsHour).value
                yVal.add(value)
            }
    
        }

        if yVal.count > 0 {
            print(">>>yVal:", yVal)
            self.setChartView(xVal: xVal, yVal: yVal)
        }

    }
    
    func setChartView(xVal: NSMutableArray, yVal: NSMutableArray) {
        self.setDataCount(count: 24, vals: yVal)
    }
    
    func setDataCount(count: Int, vals: NSMutableArray) {
        let yVals = (0..<count).map { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: Double(i + 1), y: Double(vals[i] as! Int))
        }

        let set1 = BarChartDataSet(values: yVals as? [ChartDataEntry], label: "")
        set1.colors = [UIColor.init(hexString: "397ee3")]
        set1.drawValuesEnabled = false
        
        let data = BarChartData(dataSet: set1)
        data.barWidth = 0.5
        
        chartView.data = data
        
        //        chartView.setNeedsDisplay()
    }
 
    // MARK - Distance day
    func fetchDistanceDay() {
        let array = manager.fetchDistanceGetAllDaysData()
        if array.count > 0 {
            let model = array[0] as! Distance
            let value = model.value
            
            print(">>>> mode :%@  value:%f", model, value)
            if value > 0 {
                lblValue1.text = String(format: "%0.2f", value)
                
                // get calories
                self.getCalories(dis: value)
                

            } else {
                lblValue1.text = "-"
                lblValue2.text = "-"
            }
        } else {
            lblValue1.text = "-"
            lblValue2.text = "-"
        }
    }
    
    // MARK - Calories Day
    func fetchCaloriesDay() {
        let array = manager.fetchCaloriesGetAllDaysData()
        if array.count > 0 {
            let model = array[0] as! Calories
            let value = model.value
            
            print(">>>> mode :%@  value:%f", model, value)
            if value > 0 {
                lblValue2.text = String(format: "%0.2f", value)
                
            } else {
                lblValue2.text = "-"
            }
        } else {
            lblValue2.text = "-"
        }
    }
    
    func getCalories(dis: Double) {
        let distancemile = dis * 0.0006213
        let caloiespermile = 3.7103 + 0.2678 * 60 + (0.0359 * (60 * 60 * 0.0006213) * 2) * 60
        let caloies = distancemile * caloiespermile * 0.0006213
        
        lblValue2.text = String(format: "%0.1f", caloies * 1000)
        
    }
}
