//
//  DataManager.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/06/04.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import HealthKit
import CoreMotion

var ZBLOODGLUCOSE   = "BloodGlucose"
var ZBLOODPRESSURE  = "BloodPressure"
var ZOXYGENLEVEL    = "OxygenLevel"
var ZMOOD           = "Mood"
var ZSTEPS          = "Steps"
var ZSTEPSHOUR      = "StepsHour"
var ZDISTANCE       = "Distance"
var ZCALORIES       = "Calories"
var ZWEIGHT         = "Weight"
var ZHEMOGLOBINALC  = "HemoglobinAlc"
var ZLIPIDPANEL     = "LipidPanel"
var ZINR            = "INR"

class DataManager: NSObject {
    
    var context = NSManagedObjectContext()
    var dateFormatter = DateFormatter()
    var dateFormatter2 = DateFormatter()
    
    private let userHealthProfile = UserHealthProfile()
    
    let healthStore = HKHealthStore()
    
    override init() {
        super.init()
        
        self.initMainView()
        
    }
    
    //===========================================================
    // get health data
    //===========================================================
    
    // Auth HealthKit
    func authorizeHealthKit() {
        HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                
                return
            }
            
            print("HealthKit Successfully Authorized.")
        }
        
    }
    
    func updateHealthInfo() {
        loadAndDisplayMostRecentWeight()
        loadAndDisplayMostRecentHeight()
        loadAndDisplayGetTodaySteps()
        readSampleByBloodPressure()
        readSampleByBloodGlucose()
        readSampleByOxygenLevel()
    }
    
    func readSampleByBloodPressure() {
        guard let type = HKQuantityType.correlationType(forIdentifier: HKCorrelationTypeIdentifier.bloodPressure),
            let systolicType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureSystolic),
            let diastolicType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureDiastolic) else {
                
                return
        }
        
        let sampleQuery = HKSampleQuery(sampleType: type, predicate: nil, limit: 0, sortDescriptors: nil) { (sampleQuery, results, error) in
            if let dataList = results as? [HKCorrelation] {
                let data = dataList.last
                if data != nil {
                    if let data1 = data?.objects(for: systolicType).first as? HKQuantitySample,
                        let data2 = data?.objects(for: diastolicType).first as? HKQuantitySample {
                        
                        let value1 = data1.quantity.doubleValue(for: HKUnit.millimeterOfMercury())
                        let value2 = data2.quantity.doubleValue(for: HKUnit.millimeterOfMercury())
                        
                        let notificationKey = "sendBloodPressure"
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationKey),
                                                        object: nil,
                                                        userInfo: ["bloodPressure1":value1, "bloodPressure2": value2])
                    }
                    
                }
            }
        }
        
        healthStore.execute(sampleQuery)
    }
    
    func readSampleByBloodGlucose() {
        let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodGlucose)
        
        let sampleQuery = HKSampleQuery(sampleType: type!, predicate: nil, limit: 0, sortDescriptors: nil) { (sampleQuery, results, error) in
            if let dataList = results as? [HKQuantitySample] {
                let data = dataList.last
                if data != nil {
                    let value = data?.quantity
                    let metadata = data?.metadata
                    var whenIndex = String()
                    whenIndex = "0"
                    
                    if metadata!["HKBloodGlucoseMealTime"] != nil {
                        let mealTime = metadata!["HKBloodGlucoseMealTime"] as! NSInteger
                        
                        if mealTime == 2 {
                            whenIndex = "3"
                        } else {
                            whenIndex = "0"
                        }
                    }
                    
                    let mmol = HKUnit.moleUnit(with: .milli, molarMass: HKUnitMolarMassBloodGlucose)
                    let mmolL = mmol.unitDivided(by: HKUnit.liter())
                    
                    /* Unit convert
                     // https://stackoverflow.com/questions/42898641/apple-healthkit-glucose-level-reading-is-giving-conversion-error
                     */
                    
                    let sendBloodGlucose = value?.doubleValue(for: mmolL)
                    let notificationKey = "sendBloodGlucose"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationKey),
                                                    object: nil,
                                                    userInfo: ["bloodGlucose":Int(sendBloodGlucose!), "whenIndex": whenIndex])
                }
                
            }
        }
        
        healthStore.execute(sampleQuery)
    }
    
    func readSampleByOxygenLevel() {
        let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.oxygenSaturation)
        
        let sampleQuery = HKSampleQuery(sampleType: type!, predicate: nil, limit: 0, sortDescriptors: nil) { (sampleQuery, results, error) in
            if let dataList = results as? [HKQuantitySample] {
                
                let data = dataList.last
                if data != nil {
                    let value = data?.quantity
                    let metafata = data?.metadata
                    var whenIndex = String()
                    
                    whenIndex = "0"
                    
                    let doubleValue = value?.doubleValue(for: HKUnit(from: "%"))
                    
                    let sendOxygenLevel = Int(doubleValue! * 100)
                    
                    let notificationKey = "sendOxygenLevel"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationKey),
                                                    object: nil,
                                                    userInfo: ["oxygenLevel":sendOxygenLevel, "whenIndex": whenIndex])
                }
                
            }
        }
        
        healthStore.execute(sampleQuery)
    }
    func loadAndDisplayMostRecentWeight() {
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            print("Body Mass Sample Type is no longer available in HealthKit")
            return
        }
        
        ProfileDataStore.getMostRecentSample(for: weightSampleType) { (samples, error) in
            guard let samples = samples else {
                if let error = error {
                    print(">>> get Weight error:", error.localizedDescription)
                }
                return
            }
            
            // initialize weight table
            if self.deleteAllWeight() == true {
                var equalToday = false
                var strDate = String()
                var strToday = String()
                
                UserDefaults.standard.set(0.0, forKey: "weight")
                UserDefaults.standard.synchronize()
                
                if samples.count > 0 {
                    for sample in samples {
                        
                        let weightInKilograms = (sample as! HKQuantitySample).quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
                        let endDate = (sample as! HKQuantitySample).endDate
                        
                        strDate = self.getStrDate(date: endDate)
                        strToday = self.getStrDate(date: Date())
                        
                        if (strDate != strToday) {
                            equalToday = false
                        } else {
                            equalToday = true
                        }
                        
                        UserDefaults.standard.set(weightInKilograms, forKey: "weight")
                        UserDefaults.standard.synchronize()
                        
                        DispatchQueue.main.async {
                            if self.insertWeight(date: endDate, value: weightInKilograms) == true {
                                print(">>>> inserted weight data successful.")
                            }
                        }
                        
                        
                    }
                    
                    if equalToday == false {
                        UserDefaults.standard.set(0.0, forKey: "weight")
                        UserDefaults.standard.synchronize()
                        
                        DispatchQueue.main.async {
                            if self.insertWeight(date: Date(), value: 0.0) == true {
                                print(">>>> inserted weight data successful.")
                            }
                        }
                    }
                    
                    
                    
                } else {
                    print(">>>>> weight is empty")
                    
                    UserDefaults.standard.set(0.0, forKey: "weight")
                    UserDefaults.standard.synchronize()
                    
                    DispatchQueue.main.async {
                        if self.insertWeight(date: Date(), value: 0.0) == true {
                            print(">>>> inserted weight data successful.")
                        }
                    }
                    
                }
                
                
            }
            
            
        }
        
    }
    
    
    func loadAndDisplayMostRecentHeight() {
        
        //1. Use HealthKit to create the Height Sample Type
        guard let heightSampleType = HKSampleType.quantityType(forIdentifier: .height) else {
            print("Height Sample Type is no longer available in HealthKit")
            return
        }
        
        ProfileDataStore.getMostRecentSample(for: heightSampleType) { (samples, error) in
            guard let samples = samples else {
                
                if let error = error {
                    print(">>> get height error:", error.localizedDescription)
                }
                
                return
            }
            
            //2. Convert the height sample to meters, save to the profile model,
            //   and update the user interface.
            var heightInMeters = 0.0
            
            if samples.count > 0 {
                heightInMeters = (samples.lastObject as! HKQuantitySample).quantity.doubleValue(for: HKUnit.meter())
            }
            
            UserDefaults.standard.set(heightInMeters, forKey: "height")
            UserDefaults.standard.synchronize()
            
        }
        
    }
    
    func loadAndDisplayGetTodaySteps() {
        // get steps all
        getTodaysStepsAll { (result) in
            DispatchQueue.main.async {  // <--
                let notificationKey = "sendSteps"
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationKey),
                                                object: nil,
                                                userInfo: ["steps":result])
            }
        }
        
        // get steps hours
        for i in 0..<24 {
            // get steps hour
            getTodaysStepsHour(hour: i) { (result) in
                let re = self.insertStepsHour(date: Date(), value: Int64(result), hour: i)
                if re == true {
                    
                }
            }
            
        }
        
        // get distance all
        getTodaysDistanceAll { (result) in
            let re = self.insertDistance(date: Date(), value: result)
            if re == true {
                print(">>>> insert distance success:", Date(), result)
            }
        }
        
        /*
         // get calories all
         getTodaysCaloriesAll { (result) in
         let re = self.insertCalories(date: Date(), value: result)
         if re == true {
         print(">>>> insert calories success:", Date(), result)
         }
         }
         */
    }
    
    //---------------------------------
    // get today steps
    // --------------------------------
    func getTodaysStepsAll(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let date = Date()
        let calendar = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
        let startOfDay = calendar?.startOfDay(for: date)
        
        let components = NSDateComponents()
        components.hour   = 23
        components.minute = 59
        components.second = 59
        
        let endOfDay = calendar?.date(byAdding: components as DateComponents, to: startOfDay!, options: NSCalendar.Options(rawValue: 0))
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            var resultCount = 0.0
            guard let result = result else {
                print("Failed to fetch steps rate (getTodaysStepsAll)")
                completion(resultCount)
                return
            }
            
            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.count())
            }
            
            DispatchQueue.main.async { // <--
                completion(resultCount)
            }
        }
        healthStore.execute(query)
    }
    
    // steps hours
    func getTodaysStepsHour(hour: NSInteger, completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let date = Date()
        let calendar = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
        let initOfDay = calendar?.startOfDay(for: date)
        
        let startOfDay = calendar?.date(byAdding: .hour, value: hour, to: initOfDay!, options: [])
        let endOfDay = calendar?.date(byAdding: .hour, value: (hour + 1), to: initOfDay!, options: [])
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            var resultCount = 0.0
            guard let result = result else {
                print("Failed to fetch steps rate")
                completion(resultCount)
                return
            }
            
            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.count())
            }
            
            DispatchQueue.main.async { // <--
                completion(resultCount)
            }
        }
        healthStore.execute(query)
    }
    
    // distance
    func getTodaysDistanceAll(completion: @escaping (Double) -> Void) {
        let type = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        
        let date = Date()
        let calendar = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
        let newDate = calendar?.startOfDay(for: date)
        
        let predicate = HKQuery.predicateForSamples(withStart: newDate, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: [.cumulativeSum]) { (query, statistics, error) in
            var value: Double = 0
            
            if error != nil {
                print("something went wrong")
            } else if let quantity = statistics?.sumQuantity() {
                value = quantity.doubleValue(for: HKUnit.mile())
            }
            DispatchQueue.main.async { // <--
                completion(value)
            }
        }
        
        healthStore.execute(query)
    }
    
    // calories
    func getTodaysCaloriesAll(completion: @escaping (Double) -> Void) {
        let type = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        
        let date = Date()
        let calendar = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
        let newDate = calendar?.startOfDay(for: date)
        
        let predicate = HKQuery.predicateForSamples(withStart: newDate, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: [.cumulativeSum]) { (query, statistics, error) in
            var value: Double = 0
            
            if error != nil {
                print("something went wrong")
            } else if let quantity = statistics?.sumQuantity() {
                value = quantity.doubleValue(for: HKUnit.calorie())
            }
            DispatchQueue.main.async {
                completion(value)
            }
        }
        
        healthStore.execute(query)
    }
    
    
    //=================================================================
    // END Health Kit
    //=================================================================
    
    
    func initMainView() {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter2.dateFormat = "h:mm a"
    }
    
    func getStrDate(date: Date) -> String {
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    func getStrWeek(date: Date) -> String {
        let strDay = getDay(date: date)
        var strWeek = String()
        
        if strDay == "01" || strDay == "02" || strDay == "03" || strDay == "04" || strDay == "05" || strDay == "06" {
            strWeek = "0106"
            
        } else if strDay == "07" || strDay == "08" || strDay == "09" || strDay == "10" || strDay == "11" || strDay == "12" || strDay == "13" {
            strWeek = "0713"
            
        } else if strDay == "14" || strDay == "15" || strDay == "16" || strDay == "17" || strDay == "18" || strDay == "19" || strDay == "20" {
            strWeek = "1420"
            
        } else if strDay == "21" || strDay == "22" || strDay == "23" || strDay == "24" || strDay == "25" || strDay == "26" || strDay == "27" {
            strWeek = "2127"
            
        } else if strDay == "28" || strDay == "29" || strDay == "30" {
            strWeek = "2830"
            
        }
        
        return String(format: "%@-%@-%@", getYear(date: date), getMonth(date: date), strWeek)
    }
    
    func getStrMonth(date: Date) -> String {
        return String(format: "%@-%@", getYear(date: date), getMonth(date: date))
    }
    
    func getYear(date: Date) -> String {
        let strDate = dateFormatter.string(from: date)
        let array = strDate.components(separatedBy: "-")
        if array.count > 0 {
            return array[0]
        } else {
            return ""
        }
        
    }
    
    func getMonth(date: Date) -> String {
        let strDate = dateFormatter.string(from: date)
        let array = strDate.components(separatedBy: "-")
        if array.count > 1 {
            return array[1]
        } else {
            return ""
        }
        
    }
    
    func getDay(date: Date) -> String {
        let strDate = dateFormatter.string(from: date)
        let array = strDate.components(separatedBy: "-")
        if array.count > 2 {
            return array[2]
        } else {
            return ""
        }
        
    }
    
    func getHour(date: Date) -> String {
        let strTime = dateFormatter2.string(from: date)
        let array = strTime.components(separatedBy: " ")
        if array.count > 0 {
            let array2 = array[0].components(separatedBy: ":")
            if array2.count > 0 {
                return array2[0]
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
    
    func getMinute(date: Date) -> String {
        let strTime = dateFormatter2.string(from: date)
        let array = strTime.components(separatedBy: " ")
        if array.count > 0 {
            let array2 = array[0].components(separatedBy: ":")
            if array2.count > 1 {
                return array2[1]
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
    
    func getAMPM(date: Date) -> String {
        let strTime = dateFormatter2.string(from: date)
        let array = strTime.components(separatedBy: " ")
        if array.count > 1 {
            let ampm = array[1]
            
            return ampm.lowercased()
        } else {
            return ""
        }
    }
    
    
    func getStrTime(date: Date) -> String {
        var strTime = String()
        let strHour = self.getHour(date: date)
        let strMinute = self.getMinute(date: date)
        let strAMPM = self.getAMPM(date: date)
        
        strTime = String(format: "%@:%@%@", strHour, strMinute, strAMPM)
        
        return strTime
    }
    
    func getStrTimeIndex(date: Date) -> String {
        var strTimeIndex = String()
        let strHour = self.getHour(date: date)
        let strAMPM = self.getAMPM(date: date)
        
        let intHour = Int(strHour)
        
        if strAMPM == "am" && intHour! <= 11 {
            strTimeIndex = "0"
        } else if (strAMPM == "am" && intHour! == 12) || (strAMPM == "pm" && (intHour! == 12 || intHour! < 3)) {
            strTimeIndex = "1"
        } else {
            strTimeIndex = "2"
        }
        
        return strTimeIndex
    }
    
    
    // common
    func managedObjectContext() -> NSManagedObjectContext {
        var con = NSManagedObjectContext()
        var delegate = AppDelegate();
        DispatchQueue.main.async {
            delegate = UIApplication.shared.delegate as! AppDelegate
        }
        
        //        if delegate.responds(to: #selector(getter: delegate.persistentContainer)) {
        if delegate.responds(to: #selector(getter: delegate.persistentContainer)) {
            con = delegate.persistentContainer.viewContext
        }
        
        return con
    }
    
    //---------------------------------
    // Insert
    //---------------------------------
    
    // insert and update Blood Glucose
    func insertBloodGlucose(date: Date, whenIndex: String, value: NSInteger) -> Bool {
        self.context = self.managedObjectContext()
        
        let array = self.fetchBloodGlucoseQueryDate(strDate: getStrDate(date: date), whenIndex: whenIndex)
        if array.count == 0 {
            
            // insert
            let model: BloodGlucose = NSEntityDescription.insertNewObject(forEntityName: ZBLOODGLUCOSE, into: context) as! BloodGlucose
            model.date      = date as NSDate
            model.strDate   = self.getStrDate(date: date)
            model.strWeek   = self.getStrWeek(date: date)
            model.strMonth  = self.getStrMonth(date: date)
            model.year      = self.getYear(date: date)
            model.month     = self.getMonth(date: date)
            model.day       = self.getDay(date: date)
            model.whenIndex = whenIndex
            model.value     = Int64(value)
            
            do {
                try context.save()
                return true
                
            } catch {
                print(error)
                return false
            }
            
        } else {
            
            // update
            let model: BloodGlucose = array[0] as! BloodGlucose
            model.value = Int64(value)
            
            do {
                try context.save()
                return true
                
            } catch {
                print(error)
                return false
            }
            
        }
        
    }
    
    // insert and update Blood Pressure
    func insertBloodPressure(date: Date, time: String, timeIndex: String, value1: NSInteger, value2: NSInteger) -> Bool {
        self.context = self.managedObjectContext()
        
        let array = self.fetchBloodPressureQueryDate(strDate: getStrDate(date: date), timeIndex: timeIndex)
        if array.count == 0 {
            
            // insert
            let model: BloodPressure = NSEntityDescription.insertNewObject(forEntityName: ZBLOODPRESSURE, into: context) as! BloodPressure
            model.date      = date as NSDate
            model.strDate   = self.getStrDate(date: date)
            model.strWeek   = self.getStrWeek(date: date)
            model.strMonth  = self.getStrMonth(date: date)
            model.year      = self.getYear(date: date)
            model.month     = self.getMonth(date: date)
            model.day       = self.getDay(date: date)
            model.time      = time
            model.timeIndex = timeIndex
            model.value1    = Int64(value1)
            model.value2    = Int64(value2)
            
            do {
                try context.save()
                return true
                
            } catch {
                print(error)
                return false
            }
            
        } else {
            
            // update
            let model: BloodPressure = array[0] as! BloodPressure
            model.time = time
            model.value1 = Int64(value1)
            model.value2 = Int64(value2)
            
            do {
                try context.save()
                return true
                
            } catch {
                print(error)
                return false
            }
            
        }
        
    }
    
    // insert and update Oxygen level
    func insertOxygenLevel(date: Date, time: String, timeIndex: String, value: NSInteger) -> Bool {
        self.context = self.managedObjectContext()
        
        let array = self.fetchOxygenLevelQueryDate(strDate: getStrDate(date: date), timeIndex: timeIndex)
        if array.count == 0 {
            
            // insert
            let model: OxygenLevel = NSEntityDescription.insertNewObject(forEntityName: ZOXYGENLEVEL, into: context) as! OxygenLevel
            model.date      = date as NSDate
            model.strDate   = self.getStrDate(date: date)
            model.strWeek   = self.getStrWeek(date: date)
            model.strMonth  = self.getStrMonth(date: date)
            model.year      = self.getYear(date: date)
            model.month     = self.getMonth(date: date)
            model.day       = self.getDay(date: date)
            model.time      = time
            model.timeIndex = timeIndex
            model.value     = Int64(value)
            
            do {
                try context.save()
                return true
                
            } catch {
                print(error)
                return false
            }
            
        } else {
            
            // update
            let model: OxygenLevel = array[0] as! OxygenLevel
            model.time = time
            model.timeIndex = timeIndex
            model.value = Int64(value)
            
            do {
                try context.save()
                return true
                
            } catch {
                print(error)
                return false
            }
            
        }
        
    }
    
    // delete all object in weight
    func deleteAllWeight() -> Bool {
        self.context = self.managedObjectContext()
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: ZWEIGHT)
        let request = NSBatchDeleteRequest.init(fetchRequest: fetch)
        
        do {
            try context.execute(request)
            return true
            
        } catch {
            print(error)
            return false
        }
        
    }
    
    // insert and update weight
    func insertWeight(date: Date, value: Double) -> Bool {
        self.context = self.managedObjectContext()
        
        let array = self.fetchWeightQueryDate(strDate: getStrDate(date: date))
        if array.count == 0 {
            
            // insert
            let model: Weight = NSEntityDescription.insertNewObject(forEntityName: ZWEIGHT, into: context) as! Weight
            model.date      = date as NSDate
            model.strDate   = self.getStrDate(date: date)
            model.strWeek   = self.getStrWeek(date: date)
            model.strMonth  = self.getStrMonth(date: date)
            model.year      = self.getYear(date: date)
            model.month     = self.getMonth(date: date)
            model.day       = self.getDay(date: date)
            model.value     = Double(value * 2.2)
            
            do {
                try context.save()
                return true
                
            } catch {
                print(error)
                return false
            }
            
        } else {
            
            // update
            let model: Weight = array[0] as! Weight
            model.value = Double(value * 2.2)
            
            do {
                try context.save()
                return true
                
            } catch {
                print(error)
                return false
            }
            
        }
        
    }
    
    // insert and update steps
    func insertSteps(date: Date, value: Double) -> Bool {
        self.context = self.managedObjectContext()
        
        let array = self.fetchStepsQueryDate(strDate: getStrDate(date: date))
        if array.count == 0 {
            
            // insert
            let model: Steps = NSEntityDescription.insertNewObject(forEntityName: ZSTEPS, into: context) as! Steps
            model.date      = date
            model.strDate   = self.getStrDate(date: date)
            model.strWeek   = self.getStrWeek(date: date)
            model.strMonth  = self.getStrMonth(date: date)
            model.year      = self.getYear(date: date)
            model.month     = self.getMonth(date: date)
            model.day       = self.getDay(date: date)
            model.value     = Double(value)
            
            do {
                try context.save()
                return true
                
            } catch {
                print(error)
                return false
            }
            
        } else {
            
            // update
            let model: Steps = array[0] as! Steps
            model.value = Double(value)
            
            do {
                try context.save()
                return true
                
            } catch {
                print(error)
                return false
            }
            
        }
        
    }
    
    // insert and update steps hour
    func insertStepsHour(date: Date, value: Int64, hour: NSInteger) -> Bool {
        self.context = self.managedObjectContext()
        
        let strHours = String(format: "%@-%li", getStrDate(date: date), hour)
        
        let array = self.fetchStepsHourQueryStrHour(strHour: strHours)
        if array.count == 0 {
            
            // insert
            let model: StepsHour = NSEntityDescription.insertNewObject(forEntityName: ZSTEPSHOUR, into: context) as! StepsHour
            model.date      = date
            model.strDate   = self.getStrDate(date: date)
            model.strHour   = strHours
            model.hour      = String(format: "%ld", hour + 1)
            model.value     = Int64(value)
            
            do {
                try context.save()
                return true
                
            } catch {
                print(error)
                return false
            }
            
        } else {
            
            // update
            let model: StepsHour = array[0] as! StepsHour
            model.value = Int64(value)
            
            do {
                try context.save()
                return true
                
            } catch {
                print(error)
                return false
            }
            
        }
        
    }
    
    // insert and update distance
    func insertDistance(date: Date, value: Double) -> Bool {
        self.context = self.managedObjectContext()
        
        let array = self.fetchDistanceQueryDate(strDate: getStrDate(date: date))
        if array.count == 0 {
            
            // insert
            let model: Distance = NSEntityDescription.insertNewObject(forEntityName: ZDISTANCE, into: context) as! Distance
            model.date      = date
            model.strDate   = self.getStrDate(date: date)
            model.value     = Double(value)
            
            do {
                try context.save()
                return true
                
            } catch {
                print(error)
                return false
            }
            
        } else {
            
            // update
            let model: Distance = array[0] as! Distance
            model.value = Double(value)
            
            do {
                try context.save()
                return true
                
            } catch {
                print(error)
                return false
            }
            
        }
        
    }
    
    // insert and update calories
    func insertCalories(date: Date, value: Double) -> Bool {
        self.context = self.managedObjectContext()
        
        let array = self.fetchCaloriesQueryDate(strDate: getStrDate(date: date))
        if array.count == 0 {
            
            // insert
            let model: Calories = NSEntityDescription.insertNewObject(forEntityName: ZCALORIES, into: context) as! Calories
            model.date      = date
            model.strDate   = self.getStrDate(date: date)
            model.value     = Double(value)
            
            do {
                try context.save()
                return true
                
            } catch {
                print(error)
                return false
            }
            
        } else {
            
            // update
            let model: Calories = array[0] as! Calories
            model.value = Double(value)
            
            do {
                try context.save()
                return true
                
            } catch {
                print(error)
                return false
            }
            
        }
        
    }
    
    
    // insert Mood
    func insertMood(date: Date, feeling: NSInteger, notes: String) -> Bool {
        self.context = self.managedObjectContext()
        
        let array = self.fetchMoodQueryDate(strDate: getStrDate(date: date))
        if array.count == 0 {
            
            // insert
            let model: Mood = NSEntityDescription.insertNewObject(forEntityName: ZMOOD, into: context) as! Mood
            model.date      = date as NSDate
            model.strDate   = self.getStrDate(date: date)
            model.feeling = Int64(feeling)
            model.notes = notes
            
            do {
                try context.save()
                return true
                
            } catch {
                print(error)
                return false
            }
            
        } else {
            
            // update
            let model: Mood = array[0] as! Mood
            model.feeling = Int64(feeling)
            model.notes = notes
            
            do {
                try context.save()
                return true
                
            } catch {
                print(error)
                return false
            }
            
        }
        
    }
    
    // insert and update Hemoglobin Hlc
    func insertHemoglobinHlc(date: Date, value: Float) -> Bool {
        self.context = self.managedObjectContext()
        
        let array = self.fetchHemoglobinHlcQueryDate(strDate: getStrDate(date: date))
        if array.count == 0 {
            
            // insert
            let model: HemoglobinAlc = NSEntityDescription.insertNewObject(forEntityName: ZHEMOGLOBINALC, into: context) as! HemoglobinAlc
            model.date      = date as NSDate
            model.strDate   = self.getStrDate(date: date)
            model.strMonth  = self.getStrMonth(date: date)
            model.year      = self.getYear(date: date)
            model.month     = self.getMonth(date: date)
            model.day       = self.getDay(date: date)
            model.value     = Float(value)
            
            do {
                try context.save()
                return true
                
            } catch {
                print(error)
                return false
            }
            
        } else {
            
            // update
            let model: HemoglobinAlc = array[0] as! HemoglobinAlc
            model.value = Float(value)
            
            do {
                try context.save()
                return true
                
            } catch {
                print(error)
                return false
            }
            
        }
        
    }
    
    
    // insert INR
    func insertINR(date: Date, value: Float) -> Bool {
        self.context = self.managedObjectContext()
        
        let array = self.fetchINRQueryDate(strDate: getStrDate(date: date))
        if array.count == 0 {
            
            // insert
            let model: INR = NSEntityDescription.insertNewObject(forEntityName: ZINR, into: context) as! INR
            model.date      = date as NSDate
            model.strDate   = self.getStrDate(date: date)
            model.strMonth  = self.getStrMonth(date: date)
            model.year      = self.getYear(date: date)
            model.month     = self.getMonth(date: date)
            model.day       = self.getDay(date: date)
            model.value     = Float(value)
            
            do {
                try context.save()
                return true
                
            } catch {
                print(error)
                return false
            }
            
        } else {
            
            // update
            let model: INR = array[0] as! INR
            model.value = Float(value)
            
            do {
                try context.save()
                return true
                
            } catch {
                print(error)
                return false
            }
            
        }
        
    }
    
    // insert LipidPanel
    func insertLipidPanel(date: Date, value: NSInteger, index: String) -> Bool {
        self.context = self.managedObjectContext()
        
        let array = self.fetchLipidPanelQueryDate(strDate: getStrDate(date: date), index: index)
        if array.count == 0 {
            
            // insert
            let model: LipidPanel = NSEntityDescription.insertNewObject(forEntityName: ZLIPIDPANEL, into: context) as! LipidPanel
            model.date      = date as NSDate
            model.strDate   = self.getStrDate(date: date)
            model.strMonth  = self.getStrMonth(date: date)
            model.year      = self.getYear(date: date)
            model.month     = self.getMonth(date: date)
            model.day       = self.getDay(date: date)
            model.value     = value
            model.index     = index
            
            do {
                try context.save()
                return true
                
            } catch {
                print(error)
                return false
            }
            
        } else {
            
            // update
            let model: LipidPanel = array[0] as! LipidPanel
            model.value = value
            
            do {
                try context.save()
                return true
                
            } catch {
                print(error)
                return false
            }
            
        }
        
    }
    
    
    
    //---------------------------------
    // Fetch
    //---------------------------------
    
    // fetch Blood Glucose
    func fetchBloodGlucoseQueryDate(strDate: String, whenIndex: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODGLUCOSE)
        fetchRequest.predicate = NSPredicate(format: "strDate == %@ AND whenIndex == %@", strDate, whenIndex)
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    // fetch Blood Pressure
    func fetchBloodPressureQueryDate(strDate: String, timeIndex: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODPRESSURE)
        fetchRequest.predicate = NSPredicate(format: "strDate == %@ AND timeIndex == %@", strDate, timeIndex)
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    // fetch Oxygen level
    func fetchOxygenLevelQueryDate(strDate: String, timeIndex: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZOXYGENLEVEL)
        fetchRequest.predicate = NSPredicate(format: "strDate == %@ AND timeIndex == %@", strDate, timeIndex)
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    // fetch weight
    func fetchWeightQueryDate(strDate: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZWEIGHT)
        fetchRequest.predicate = NSPredicate(format: "strDate == %@", strDate)
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    // fetch steps
    func fetchStepsQueryDate(strDate: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZSTEPS)
        fetchRequest.predicate = NSPredicate(format: "strDate == %@", strDate)
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    // fetch steps hour
    func fetchStepsHourQueryStrHour(strHour: String) -> NSArray {
        self.context = self.managedObjectContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZSTEPSHOUR)
        fetchRequest.predicate = NSPredicate(format: "strHour == %@", strHour)
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
        
    }
    
    // fetch distance
    func fetchDistanceQueryDate(strDate: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZDISTANCE)
        fetchRequest.predicate = NSPredicate(format: "strDate == %@", strDate)
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    // fetch calories
    func fetchCaloriesQueryDate(strDate: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZCALORIES)
        fetchRequest.predicate = NSPredicate(format: "strDate == %@", strDate)
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    // fetch Mood
    func fetchMoodQueryDate(strDate: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZMOOD)
        fetchRequest.predicate = NSPredicate(format: "strDate == %@", strDate)
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    // fetch HemoglobinHlc
    func fetchHemoglobinHlcQueryDate(strDate: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZHEMOGLOBINALC)
        fetchRequest.predicate = NSPredicate(format: "strDate == %@", strDate)
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    // fetch INR
    func fetchINRQueryDate(strDate: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZINR)
        fetchRequest.predicate = NSPredicate(format: "strDate == %@", strDate)
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    // fetch LipidPanel
    func fetchLipidPanelQueryDate(strDate: String, index: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZLIPIDPANEL)
        fetchRequest.predicate = NSPredicate(format: "strDate == %@ AND index == %@", strDate, index)
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    // fetch BloodGlucose all
    func fetchBloodGlucose() -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODGLUCOSE)
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    // fetch Blood Glucose - Grooup by strdate
    // query: select ZSTRDATE from ZBLOODGLUCOSE group by ZSTRDATE
    //
    func fetchBloodGlucoseGroupBy(str: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODGLUCOSE)
        
        fetchRequest.propertiesToFetch = [str]
        fetchRequest.propertiesToGroupBy = [str]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    func fetchBloodPressureGroupBy(str: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODPRESSURE)
        
        fetchRequest.propertiesToFetch = [str]
        fetchRequest.propertiesToGroupBy = [str]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    func fetchWeightGroupBy(str: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZWEIGHT)
        
        fetchRequest.propertiesToFetch = [str]
        fetchRequest.propertiesToGroupBy = [str]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    func fetchStepsGroupBy(str: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZSTEPS)
        
        fetchRequest.propertiesToFetch = [str]
        fetchRequest.propertiesToGroupBy = [str]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    func fetchStepsHourGroupBy(str: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZSTEPSHOUR)
        fetchRequest.predicate = NSPredicate(format: "strHour <> %@", "0")
        
        fetchRequest.propertiesToFetch = [str]
        fetchRequest.propertiesToGroupBy = [str]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "strHour", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    
    
    func fetchOxygenLevelGroupBy(str: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZOXYGENLEVEL)
        
        fetchRequest.propertiesToFetch = [str]
        fetchRequest.propertiesToGroupBy = [str]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    
    func fetchHemoglobinGroupBy(str: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZHEMOGLOBINALC)
        
        fetchRequest.propertiesToFetch = [str]
        fetchRequest.propertiesToGroupBy = [str]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    func fetchINRGroupBy(str: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZINR)
        
        fetchRequest.propertiesToFetch = [str]
        fetchRequest.propertiesToGroupBy = [str]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    func fetchLipidPanelGroupBy(str: String) -> NSArray {
        context = self.managedObjectContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZLIPIDPANEL)
        
        fetchRequest.propertiesToFetch = [str]
        fetchRequest.propertiesToGroupBy = [str]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    // fetch Blood Glucose - Day query
    func fetchBloodGlucoseGetDays(str: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODGLUCOSE)
        fetchRequest.predicate = NSPredicate(format: "strDate == %@", str)
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    // fetch Blood Pressure - Day query
    func fetchBloodPressureGetDays1(str: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODPRESSURE)
        fetchRequest.predicate = NSPredicate(format: "strDate == %@", str)
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    func fetchBloodPressureGetDays(str: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODPRESSURE)
        fetchRequest.predicate = NSPredicate(format: "strDate == %@", str)
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    // fetch Oxygen Level - Day query
    func fetchOxygenLevelGetDays(str: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZOXYGENLEVEL)
        fetchRequest.predicate = NSPredicate(format: "strDate == %@", str)
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    // fetch Steps - Day query
    func fetchStepsGetDays(str: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZSTEPS)
        fetchRequest.predicate = NSPredicate(format: "strDate == %@", str)
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    // fetch Steps - Hour query
    func fetchStepsGetHours(str: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZSTEPSHOUR)
        fetchRequest.predicate = NSPredicate(format: "strDate == %@ AND strHour <> %@ AND hour <> NULL", str, " 0")
        
        let dateSort = NSSortDescriptor.init(key: "hour", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    // fetch Blood Glucose - Week query
    func fetchBloodGlucoseGetWeeks(str: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODGLUCOSE)
        fetchRequest.predicate = NSPredicate(format: "strWeek == %@", str)
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    // fetch Blood Glucose - Month query
    func fetchBloodGlucoseGetMonths(str: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODGLUCOSE)
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@", str)
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    // fetch Blood Glucose - Year query
    func fetchBloodGlucoseGetYears(str: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODGLUCOSE)
        fetchRequest.predicate = NSPredicate(format: "year == %@", str)
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    // fetch Blood Glucose Day
    func fetchBloodGlucoseGetAllDaysData() -> NSMutableArray {
        let arrayDays = self.fetchBloodGlucoseGroupBy(str: "strDate")
        
        if arrayDays.count > 0 {
            let arrayDayData = NSMutableArray()
            
            for day in arrayDays {
                if (day as! NSDictionary).value(forKey: "strDate") != nil {
                    let strDate = (day as! NSDictionary).value(forKey: "strDate") as! String
                    let array = self.fetchBloodGlucoseGetDays(str: strDate)
                    
                    if array.count > 0 {
                        let dic = ["day":strDate, "data": array] as [String : Any]
                        arrayDayData.add(dic)
                    }
                }
                
            }
            
            if arrayDayData.count > 0 {
                return arrayDayData
                
            } else {
                return NSMutableArray.init()
            }
            
        } else {
            return NSMutableArray.init()
        }
        
    }
    
    // fetch Blood Pressure Day
    func fetchBloodPressureGetAllDaysData() -> NSMutableArray {
        let arrayDays = self.fetchBloodPressureGroupBy(str: "strDate")
        
        if arrayDays.count > 0 {
            let arrayDayData = NSMutableArray()
            
            for day in arrayDays {
                if (day as! NSDictionary).value(forKey: "strDate") != nil {
                    let strDate = (day as! NSDictionary).value(forKey: "strDate") as! String
                    let array = self.fetchBloodPressureGetDays(str: strDate)
                    
                    if array.count > 0 {
                        let dic = ["day":strDate, "data": array] as [String : Any]
                        arrayDayData.add(dic)
                    }
                }
                
            }
            
            if arrayDayData.count > 0 {
                return arrayDayData
                
            } else {
                return NSMutableArray.init()
            }
            
        } else {
            return NSMutableArray.init()
        }
        
    }
    
    // fetch OxygenLevel Day
    func fetchOxygenLevelGetAllDaysData() -> NSMutableArray {
        let arrayDays = self.fetchOxygenLevelGroupBy(str: "strDate")
        
        if arrayDays.count > 0 {
            let arrayDayData = NSMutableArray()
            
            for day in arrayDays {
                if (day as! NSDictionary).value(forKey: "strDate") != nil {
                    let strDate = (day as! NSDictionary).value(forKey: "strDate") as! String
                    let array = self.fetchOxygenLevelGetDays(str: strDate)
                    
                    if array.count > 0 {
                        let dic = ["day":strDate, "data": array] as [String : Any]
                        arrayDayData.add(dic)
                    }
                }
                
            }
            
            if arrayDayData.count > 0 {
                return arrayDayData
                
            } else {
                return NSMutableArray.init()
            }
            
        } else {
            return NSMutableArray.init()
        }
        
    }
    
    // fetch steps Day
    func fetchStepsGetAllDaysData() -> NSMutableArray {
        let arrayDays = self.fetchStepsGroupBy(str: "strDate")
        
        if arrayDays.count > 0 {
            let arrayDayData = NSMutableArray()
            let currentDate = self.getStrDate(date: Date())
            let array = self.fetchStepsGetDays(str: currentDate)
            
            if array.count > 0 {
                let dic = ["day":currentDate, "data": array] as [String : Any]
                arrayDayData.add(dic)
            }
            
            if arrayDayData.count > 0 {
                return arrayDayData
            } else {
                return NSMutableArray.init()
            }
            
        } else {
            return NSMutableArray.init()
        }
        
    }
    
    // fetch steps Hour
    func fetchStepsGetAllHoursData() -> NSMutableArray {
        var arrayDayData = NSMutableArray()
        let currentDate = self.getStrDate(date: Date())
        let array = self.fetchStepsGetHours(str: currentDate)
        
        if array.count > 0 {
            arrayDayData = array.mutableCopy() as! NSMutableArray
            return arrayDayData
        } else {
            return NSMutableArray.init()
        }
        
    }
    
    // fetch distance day
    func fetchDistanceGetAllDaysData() -> NSMutableArray {
        var arrayDayData = NSMutableArray()
        let currentDate = self.getStrDate(date: Date())
        let array = self.fetchDistanceQueryDate(strDate: currentDate)
        
        if array.count > 0 {
            arrayDayData = array.mutableCopy() as! NSMutableArray
            return arrayDayData
        } else {
            return NSMutableArray.init()
        }
        
    }
    
    // fetch Calories day
    func fetchCaloriesGetAllDaysData() -> NSMutableArray {
        var arrayDayData = NSMutableArray()
        let currentDate = self.getStrDate(date: Date())
        let array = self.fetchCaloriesQueryDate(strDate: currentDate)
        
        if array.count > 0 {
            arrayDayData = array.mutableCopy() as! NSMutableArray
            return arrayDayData
        } else {
            return NSMutableArray.init()
        }
        
    }
    
    
    
    
    //===================================================================
    // fetch Blood Glucose Week
    //===================================================================
    func fetchBloodGlucoseGetAllWeekData() -> NSMutableArray {
        let arrayWeekData = NSMutableArray.init()
        let arrayWeeks = self.fetchBloodGlucoseGroupBy(str: "strWeek")
        
        if arrayWeeks.count > 0 {
            
            for week in arrayWeeks {
                let strWeek = (week as! NSDictionary).value(forKey: "strWeek") as! String
                let arrayBefore = self.fetchBloodGlucoseGetBeforeWithWeek(week: strWeek)
                let arrayAfter  = self.fetchBloodGlucoseGetAfterWithWeek(week: strWeek)
                
                let weekData = ["strWeek": strWeek, "before": arrayBefore, "after": arrayAfter] as NSDictionary
                arrayWeekData.add(weekData)
            }
            
            if arrayWeekData.count > 0 {
                return arrayWeekData
                
            } else {
                return NSMutableArray.init()
            }
            
        } else {
            return NSMutableArray.init()
        }
        
    }
    
    func fetchBloodGlucoseGetBeforeWithWeek(week: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODGLUCOSE)
        fetchRequest.predicate = NSPredicate(format: "strWeek == %@ AND (whenIndex == %@ OR whenIndex == %@ OR whenIndex == %@)",
                                             week, "0", "1", "2")
        fetchRequest.propertiesToFetch = ["value", "strDate"]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchBloodGlucoseGetAfterWithWeek(week: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODGLUCOSE)
        fetchRequest.predicate = NSPredicate(format: "strWeek == %@ AND (whenIndex == %@ OR whenIndex == %@ OR whenIndex == %@)",
                                             week, "3", "4", "5")
        fetchRequest.propertiesToFetch = ["value", "strDate"]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    
    //===================================================================
    // fetch Blood Pressure Week
    //===================================================================
    func fetchBloodPressureGetAllWeekData() -> NSMutableArray {
        let arrayWeekData = NSMutableArray.init()
        let arrayWeeks = self.fetchBloodPressureGroupBy(str: "strWeek")
        
        if arrayWeeks.count > 0 {
            
            for week in arrayWeeks {
                if ((week as! NSDictionary).value(forKey: "strWeek") != nil) {
                    let strWeek = (week as! NSDictionary).value(forKey: "strWeek") as! String
                    let arrayData = self.fetchBloodPressureGetBeforeWithWeek(week: strWeek)
                    
                    if arrayData.count > 0 {
                        let weekData = ["strWeek": strWeek, "data": arrayData] as NSDictionary
                        arrayWeekData.add(weekData)
                    }
                }
            }
            
            if arrayWeekData.count > 0 {
                return arrayWeekData
                
            } else {
                return NSMutableArray.init()
            }
            
        } else {
            return NSMutableArray.init()
        }
        
    }
    
    func fetchBloodPressureGetBeforeWithWeek(week: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODPRESSURE)
        fetchRequest.predicate = NSPredicate(format: "strWeek == %@", week)
        fetchRequest.propertiesToFetch = ["value1", "value2", "strDate"]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    //===================================================================
    // fetch weight Week
    //===================================================================
    func fetchWeightGetAllWeekData() -> NSMutableArray {
        let arrayWeekData = NSMutableArray.init()
        let arrayWeeks = self.fetchWeightGroupBy(str: "strWeek")
        
        if arrayWeeks.count > 0 {
            
            for week in arrayWeeks {
                if (week as! NSDictionary).value(forKey: "strWeek") != nil {
                    let strWeek = (week as! NSDictionary).value(forKey: "strWeek") as! String
                    let currentWeek = self.getStrWeek(date: Date())
                    
                    if strWeek == currentWeek {
                        let arrayData = self.fetchWeightWithWeek(week: strWeek)
                        
                        if arrayData.count > 0 {
                            let weekData = ["strWeek": strWeek, "data": arrayData] as NSDictionary
                            arrayWeekData.add(weekData)
                        }
                        
                        break
                    }
                }
            }
            
            if arrayWeekData.count > 0 {
                return arrayWeekData
                
            } else {
                return NSMutableArray.init()
            }
            
        } else {
            return NSMutableArray.init()
        }
        
    }
    
    func fetchWeightWithWeek(week: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let currentWeek = self.getStrWeek(date: Date())
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZWEIGHT)
        fetchRequest.predicate = NSPredicate(format: "strWeek == %@", currentWeek)
        fetchRequest.propertiesToFetch = ["value", "strDate"]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    //===================================================================
    // fetch Spteps Week
    //===================================================================
    func fetchStepsGetAllWeekData() -> NSMutableArray {
        let arrayWeekData = NSMutableArray.init()
        let arrayWeeks = self.fetchStepsGroupBy(str: "strWeek")
        let strWeek = self.getStrWeek(date: Date())
        
        if arrayWeeks.count > 0 {
            
            for week in arrayWeeks {
                if ((week as! NSDictionary).value(forKey: "strWeek") != nil) {
                    //                    let strWeek = (week as! NSDictionary).value(forKey: "strWeek") as! String
                    let arrayData = self.fetchStepsWithWeek(week: strWeek)
                    
                    let weekData = ["strWeek": strWeek, "data": arrayData] as NSDictionary
                    arrayWeekData.add(weekData)
                    break
                }
            }
            
            if arrayWeekData.count > 0 {
                return arrayWeekData
                
            } else {
                return NSMutableArray.init()
            }
            
        } else {
            return NSMutableArray.init()
        }
        
    }
    
    func fetchStepsWithWeek(week: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let currentWeek = self.getStrWeek(date: Date())
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZSTEPS)
        fetchRequest.predicate = NSPredicate(format: "strWeek == %@", currentWeek)
        fetchRequest.propertiesToFetch = ["value", "strDate"]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    
    //===================================================================
    // fetch Blood Glucose Month
    //===================================================================
    func fetchBloodGlucoseGetAllMonthData() -> NSMutableArray {
        let arrayMonthData = NSMutableArray.init()
        let arrayMonths = self.fetchBloodGlucoseGroupBy(str: "strMonth")
        
        if arrayMonths.count > 0 {
            
            for month in arrayMonths {
                if (month as! NSDictionary).value(forKey: "strMonth") != nil {
                    let strMonth = (month as! NSDictionary).value(forKey: "strMonth") as! String
                    
                    var avgBefore0106 = 0.0
                    var avgAfter0106  = 0.0
                    var avgBefore0713 = 0.0
                    var avgAfter0713  = 0.0
                    var avgBefore1420 = 0.0
                    var avgAfter1420  = 0.0
                    var avgBefore2127 = 0.0
                    var avgAfter2127  = 0.0
                    var avgBefore2830 = 0.0
                    var avgAfter2830  = 0.0
                    
                    if (self.fetchBloodGlucoseGetBeforeAverageValuesWithMonth0106(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avgBefore0106 = (self.fetchBloodGlucoseGetBeforeAverageValuesWithMonth0106(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchBloodGlucoseGetAfterAverageValuesWithMonth0106(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avgAfter0106  = (self.fetchBloodGlucoseGetAfterAverageValuesWithMonth0106(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchBloodGlucoseGetBeforeAverageValuesWithMonth0713(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avgBefore0713 = (self.fetchBloodGlucoseGetBeforeAverageValuesWithMonth0713(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchBloodGlucoseGetAfterAverageValuesWithMonth0713(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avgAfter0713  = (self.fetchBloodGlucoseGetAfterAverageValuesWithMonth0713(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchBloodGlucoseGetBeforeAverageValuesWithMonth1420(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avgBefore1420 = (self.fetchBloodGlucoseGetBeforeAverageValuesWithMonth1420(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchBloodGlucoseGetAfterAverageValuesWithMonth1420(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avgAfter1420  = (self.fetchBloodGlucoseGetAfterAverageValuesWithMonth1420(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchBloodGlucoseGetBeforeAverageValuesWithMonth2127(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avgBefore2127 = (self.fetchBloodGlucoseGetBeforeAverageValuesWithMonth2127(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchBloodGlucoseGetAfterAverageValuesWithMonth2127(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avgAfter2127  = (self.fetchBloodGlucoseGetAfterAverageValuesWithMonth2127(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchBloodGlucoseGetBeforeAverageValuesWithMonth2830(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avgBefore2830 = (self.fetchBloodGlucoseGetBeforeAverageValuesWithMonth2830(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchBloodGlucoseGetAfterAverageValuesWithMonth2830(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avgAfter2830  = (self.fetchBloodGlucoseGetAfterAverageValuesWithMonth2830(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    
                    let monthData = ["month": strMonth,
                                     "before0106"   : avgBefore0106,
                                     "after0106"    : avgAfter0106,
                                     "before0713"   : avgBefore0713,
                                     "after0713"    : avgAfter0713,
                                     "before1420"   : avgBefore1420,
                                     "after1420"    : avgAfter1420,
                                     "before2127"   : avgBefore2127,
                                     "after2127"    : avgAfter2127,
                                     "before2830"   : avgBefore2830,
                                     "after2830"    : avgAfter2830,
                                     ] as NSDictionary
                    
                    arrayMonthData.add(monthData)
                    
                }
            }
            
            if arrayMonthData.count > 0 {
                return arrayMonthData
                
            } else {
                return NSMutableArray.init()
            }
            
        } else {
            return NSMutableArray.init()
        }
        
    }
    
    
    //===================================================================
    // fetch Blood Pressure Month
    //===================================================================
    func fetchBloodPressureGetAllMonthData() -> NSMutableArray {
        let arrayMonthData = NSMutableArray.init()
        let arrayMonths = self.fetchBloodPressureGroupBy(str: "strMonth")
        
        if arrayMonths.count > 0 {
            
            for month in arrayMonths {
                if (month as! NSDictionary).value(forKey: "strMonth") != nil {
                    let strMonth = (month as! NSDictionary).value(forKey: "strMonth") as! String
                    
                    var avg1_0106 = 0.0
                    var avg2_0106 = 0.0
                    var avg1_0713 = 0.0
                    var avg2_0713 = 0.0
                    var avg1_1420 = 0.0
                    var avg2_1420 = 0.0
                    var avg1_2127 = 0.0
                    var avg2_2127 = 0.0
                    var avg1_2830 = 0.0
                    var avg2_2830 = 0.0
                    
                    if (self.fetchBloodPressureGetAverageValue1WithMonth0106(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avg1_0106 = (self.fetchBloodPressureGetAverageValue1WithMonth0106(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchBloodPressureGetAverageValue2WithMonth0106(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avg2_0106 = (self.fetchBloodPressureGetAverageValue2WithMonth0106(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchBloodPressureGetAverageValue1WithMonth0713(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avg1_0713 = (self.fetchBloodPressureGetAverageValue1WithMonth0713(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchBloodPressureGetAverageValue2WithMonth0713(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avg2_0713 = (self.fetchBloodPressureGetAverageValue2WithMonth0713(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchBloodPressureGetAverageValue1WithMonth1420(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avg1_1420 = (self.fetchBloodPressureGetAverageValue1WithMonth1420(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchBloodPressureGetAverageValue2WithMonth1420(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avg2_1420 = (self.fetchBloodPressureGetAverageValue2WithMonth1420(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchBloodPressureGetAverageValue1WithMonth2127(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avg1_2127 = (self.fetchBloodPressureGetAverageValue1WithMonth2127(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchBloodPressureGetAverageValue2WithMonth2127(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avg2_2127 = (self.fetchBloodPressureGetAverageValue2WithMonth2127(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchBloodPressureGetAverageValue1WithMonth2830(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avg1_2830 = (self.fetchBloodPressureGetAverageValue1WithMonth2830(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchBloodPressureGetAverageValue2WithMonth2830(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avg2_2830 = (self.fetchBloodPressureGetAverageValue2WithMonth2830(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    
                    let monthData = ["month": strMonth,
                                     "avg1_0106": avg1_0106,
                                     "avg2_0106": avg2_0106,
                                     "avg1_0713": avg1_0713,
                                     "avg2_0713": avg2_0713,
                                     "avg1_1420": avg1_1420,
                                     "avg2_1420": avg2_1420,
                                     "avg1_2127": avg1_2127,
                                     "avg2_2127": avg2_2127,
                                     "avg1_2830": avg1_2830,
                                     "avg2_2830": avg2_2830,
                                     ] as NSDictionary
                    
                    arrayMonthData.add(monthData)
                    
                }
            }
            
            if arrayMonthData.count > 0 {
                return arrayMonthData
                
            } else {
                return NSMutableArray.init()
            }
            
        } else {
            return NSMutableArray.init()
        }
        
    }
    
    //===================================================================
    // fetch Oxygen Level Month
    //===================================================================
    func fetchOxygenLevelGetAllMonthData() -> NSMutableArray {
        let arrayMonthData = NSMutableArray.init()
        let arrayMonths = self.fetchOxygenLevelGroupBy(str: "strMonth")
        
        if arrayMonths.count > 0 {
            
            for month in arrayMonths {
                if (month as! NSDictionary).value(forKey: "strMonth") != nil {
                    let strMonth = (month as! NSDictionary).value(forKey: "strMonth") as! String
                    
                    var avg0106 = 0.0
                    var avg0713 = 0.0
                    var avg1420 = 0.0
                    var avg2127 = 0.0
                    var avg2830 = 0.0
                    
                    if (self.fetchOxygenLevelGetAverageValuesWithMonth0106(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avg0106 = (self.fetchOxygenLevelGetAverageValuesWithMonth0106(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchOxygenLevelGetAverageValuesWithMonth0713(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avg0713 = (self.fetchOxygenLevelGetAverageValuesWithMonth0713(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchOxygenLevelGetAverageValuesWithMonth1420(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avg1420 = (self.fetchOxygenLevelGetAverageValuesWithMonth1420(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchOxygenLevelGetAverageValuesWithMonth2127(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avg2127 = (self.fetchOxygenLevelGetAverageValuesWithMonth2127(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchOxygenLevelGetAverageValuesWithMonth2830(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avg2830 = (self.fetchOxygenLevelGetAverageValuesWithMonth2830(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    
                    let monthData = ["month": strMonth,
                                     "avg0106": avg0106,
                                     "avg0713": avg0713,
                                     "avg1420": avg1420,
                                     "avg2127": avg2127,
                                     "avg2830": avg2830,
                                     ] as NSDictionary
                    
                    arrayMonthData.add(monthData)
                }
                
            }
            
            if arrayMonthData.count > 0 {
                return arrayMonthData
                
            } else {
                return NSMutableArray.init()
            }
            
        } else {
            return NSMutableArray.init()
        }
        
    }
    
    //===================================================================
    // fetch Weight Month
    //===================================================================
    func fetchWeightGetAllMonthData() -> NSMutableArray {
        let arrayMonthData = NSMutableArray.init()
        let arrayMonths = self.fetchWeightGroupBy(str: "strMonth")
        
        if arrayMonths.count > 0 {
            
            for month in arrayMonths {
                if (month as! NSDictionary).value(forKey: "strMonth") != nil {
                    let strMonth = (month as! NSDictionary).value(forKey: "strMonth") as! String
                    let currentMonth = self.getStrMonth(date: Date())
                    
                    print(">>>>>>>strMonth:", strMonth)
                    print(">>>currentMonth:", currentMonth)
                    
                    if strMonth == currentMonth {
                        var avg0106 = 0.0
                        var avg0713 = 0.0
                        var avg1420 = 0.0
                        var avg2127 = 0.0
                        var avg2830 = 0.0
                        
                        if (self.fetchWeightGetAverageValuesWithMonth0106(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                            avg0106 = (self.fetchWeightGetAverageValuesWithMonth0106(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                        }
                        if (self.fetchWeightGetAverageValuesWithMonth0713(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                            avg0713 = (self.fetchWeightGetAverageValuesWithMonth0713(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                        }
                        if (self.fetchWeightGetAverageValuesWithMonth1420(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                            avg1420 = (self.fetchWeightGetAverageValuesWithMonth1420(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                        }
                        if (self.fetchWeightGetAverageValuesWithMonth2127(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                            avg2127 = (self.fetchWeightGetAverageValuesWithMonth2127(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                        }
                        if (self.fetchWeightGetAverageValuesWithMonth2830(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                            avg2830 = (self.fetchWeightGetAverageValuesWithMonth2830(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                        }
                        
                        let monthData = ["month": strMonth,
                                         "avg0106": avg0106,
                                         "avg0713": avg0713,
                                         "avg1420": avg1420,
                                         "avg2127": avg2127,
                                         "avg2830": avg2830,
                                         ] as NSDictionary
                        
                        arrayMonthData.add(monthData)
                        
                        print(">>> array:", arrayMonthData)
                    }
                }
                
            }
            
            if arrayMonthData.count > 0 {
                return arrayMonthData
                
            } else {
                return NSMutableArray.init()
            }
            
        } else {
            return NSMutableArray.init()
        }
        
    }
    
    //===================================================================
    // fetch Steps Month
    //===================================================================
    func fetchStepsGetAllMonthData() -> NSMutableArray {
        let arrayMonthData = NSMutableArray.init()
        let arrayMonths = self.fetchStepsGroupBy(str: "strMonth")
        
        if arrayMonths.count > 0 {
            
            for month in arrayMonths {
                if (month as! NSDictionary).value(forKey: "strMonth") != nil {
                    let strMonth = (month as! NSDictionary).value(forKey: "strMonth") as! String
                    
                    var avg0106 = 0.0
                    var avg0713 = 0.0
                    var avg1420 = 0.0
                    var avg2127 = 0.0
                    var avg2830 = 0.0
                    
                    if (self.fetchStepsGetAverageValuesWithMonth0106(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avg0106 = (self.fetchStepsGetAverageValuesWithMonth0106(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchStepsGetAverageValuesWithMonth0713(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avg0713 = (self.fetchStepsGetAverageValuesWithMonth0713(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchStepsGetAverageValuesWithMonth0106(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avg1420 = (self.fetchStepsGetAverageValuesWithMonth1420(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchStepsGetAverageValuesWithMonth0106(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avg2127 = (self.fetchStepsGetAverageValuesWithMonth2127(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    if (self.fetchStepsGetAverageValuesWithMonth0106(month: strMonth)[0] as! NSDictionary)["average"] != nil {
                        avg2830 = (self.fetchStepsGetAverageValuesWithMonth2830(month: strMonth)[0] as! NSDictionary)["average"] as! Double
                    }
                    
                    let monthData = ["month": strMonth,
                                     "avg0106": avg0106,
                                     "avg0713": avg0713,
                                     "avg1420": avg1420,
                                     "avg2127": avg2127,
                                     "avg2830": avg2830,
                                     ] as NSDictionary
                    
                    arrayMonthData.add(monthData)
                }
            }
            
            if arrayMonthData.count > 0 {
                return arrayMonthData
                
            } else {
                return NSMutableArray.init()
            }
            
        } else {
            return NSMutableArray.init()
        }
        
    }
    
    
    
    
    // select avg(ZVALUE) from ZBLOODGLUCOSE where ZSTRMONTH = '2018-06' and (ZWHENINDEX = 3 or ZWHENINDEX = 4 or ZWHENINDEX = 5) and (ZDAY = '07' or ZDAY = '08'  or ZDAY = '09'  or ZDAY = '10'  or ZDAY = '11'  or ZDAY = '12'  or ZDAY = '13' )
    
    func fetchBloodGlucoseGetBeforeAverageValuesWithMonth0106(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODGLUCOSE)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (whenIndex == %@ OR whenIndex == %@ OR whenIndex == %@) AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)", month, "0", "1", "2", "01", "02", "03", "04", "05", "06")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    
    func fetchOxygenLevelGetAverageValuesWithMonth0106(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZOXYGENLEVEL)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             month, "01", "02", "03", "04", "05", "06")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchWeightGetAverageValuesWithMonth0106(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let currentMonth = self.getStrMonth(date: Date())
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZWEIGHT)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             currentMonth, "01", "02", "03", "04", "05", "06")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchStepsGetAverageValuesWithMonth0106(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let currentMonth = self.getStrMonth(date: Date())
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZSTEPS)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             currentMonth, "01", "02", "03", "04", "05", "06")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchBloodPressureGetAverageValue1WithMonth0106(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODPRESSURE)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value1")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             month, "01", "02", "03", "04", "05", "06")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchBloodPressureGetAverageValue2WithMonth0106(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODPRESSURE)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value2")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             month, "01", "02", "03", "04", "05", "06")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    
    
    func fetchBloodGlucoseGetBeforeAverageValuesWithMonth0713(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODGLUCOSE)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (whenIndex == %@ OR whenIndex == %@ OR whenIndex == %@) AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             month, "0", "1", "2", "07", "08", "09", "10", "11", "12", "13")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchBloodPressureGetAverageValue1WithMonth0713(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODPRESSURE)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value1")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             month, "07", "08", "09", "10", "11", "12", "13")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchBloodPressureGetAverageValue2WithMonth0713(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODPRESSURE)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value2")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             month, "07", "08", "09", "10", "11", "12", "13")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchOxygenLevelGetAverageValuesWithMonth0713(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZOXYGENLEVEL)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             month, "07", "08", "09", "10", "11", "12", "13")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchWeightGetAverageValuesWithMonth0713(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let currentMonth = self.getStrMonth(date: Date())
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZWEIGHT)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             currentMonth, "07", "08", "09", "10", "11", "12", "13")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchStepsGetAverageValuesWithMonth0713(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let currentMonth = self.getStrMonth(date: Date())
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZSTEPS)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .floatAttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             currentMonth, "07", "08", "09", "10", "11", "12", "13")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchBloodGlucoseGetBeforeAverageValuesWithMonth1420(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODGLUCOSE)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (whenIndex == %@ OR whenIndex == %@ OR whenIndex == %@) AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             month, "0", "1", "2", "14", "15", "16", "17", "18", "19", "20")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchOxygenLevelGetAverageValuesWithMonth1420(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZOXYGENLEVEL)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             month, "14", "15", "16", "17", "18", "19", "20")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchWeightGetAverageValuesWithMonth1420(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let currentMonth = self.getStrMonth(date: Date())
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZWEIGHT)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             currentMonth, "14", "15", "16", "17", "18", "19", "20")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchStepsGetAverageValuesWithMonth1420(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let currentMonth = self.getStrMonth(date: Date())
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZSTEPS)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             currentMonth, "14", "15", "16", "17", "18", "19", "20")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchBloodPressureGetAverageValue1WithMonth1420(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODPRESSURE)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value1")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             month, "14", "15", "16", "17", "18", "19", "20")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchBloodPressureGetAverageValue2WithMonth1420(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODPRESSURE)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value2")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             month, "14", "15", "16", "17", "18", "19", "20")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    func fetchBloodGlucoseGetBeforeAverageValuesWithMonth2127(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODGLUCOSE)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (whenIndex == %@ OR whenIndex == %@ OR whenIndex == %@) AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             month, "0", "1", "2", "21", "22", "23", "24", "25", "26", "27")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchBloodPressureGetAverageValue1WithMonth2127(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODPRESSURE)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value1")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             month, "21", "22", "23", "24", "25", "26", "27")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchBloodPressureGetAverageValue2WithMonth2127(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODPRESSURE)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value2")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             month, "21", "22", "23", "24", "25", "26", "27")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchOxygenLevelGetAverageValuesWithMonth2127(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZOXYGENLEVEL)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             month, "21", "22", "23", "24", "25", "26", "27")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchWeightGetAverageValuesWithMonth2127(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let currentMonth = self.getStrMonth(date: Date())
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZWEIGHT)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             currentMonth, "21", "22", "23", "24", "25", "26", "27")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchStepsGetAverageValuesWithMonth2127(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let currentMonth = self.getStrMonth(date: Date())
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZSTEPS)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             currentMonth, "21", "22", "23", "24", "25", "26", "27")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    
    func fetchBloodGlucoseGetBeforeAverageValuesWithMonth2830(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODGLUCOSE)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (whenIndex == %@ OR whenIndex == %@ OR whenIndex == %@) AND (day == %@ OR day == %@ OR day == %@)",
                                             month, "0", "1", "2", "28", "29", "29")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchBloodPressureGetAverageValue1WithMonth2830(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODPRESSURE)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value1")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (day == %@ OR day == %@ OR day == %@)",
                                             month, "28", "29", "30")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchBloodPressureGetAverageValue2WithMonth2830(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODPRESSURE)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value2")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (day == %@ OR day == %@ OR day == %@)",
                                             month, "28", "29", "30")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchOxygenLevelGetAverageValuesWithMonth2830(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZOXYGENLEVEL)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (day == %@ OR day == %@ OR day == %@)",
                                             month, "28", "29", "30")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchWeightGetAverageValuesWithMonth2830(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let currentMonth = self.getStrMonth(date: Date())
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZWEIGHT)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (day == %@ OR day == %@ OR day == %@)",
                                             currentMonth, "28", "29", "30")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchStepsGetAverageValuesWithMonth2830(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let currentMonth = self.getStrMonth(date: Date())
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZSTEPS)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (day == %@ OR day == %@ OR day == %@)",
                                             currentMonth, "28", "29", "30")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchBloodGlucoseGetAfterAverageValuesWithMonth0106(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODGLUCOSE)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (whenIndex == %@ OR whenIndex == %@ OR whenIndex == %@) AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             month, "3", "4", "5", "01", "02", "03", "04", "05", "06")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchBloodGlucoseGetAfterAverageValuesWithMonth0713(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODGLUCOSE)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (whenIndex == %@ OR whenIndex == %@ OR whenIndex == %@) AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             month, "3", "4", "5", "07", "08", "09", "10", "11", "12", "13")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchBloodGlucoseGetAfterAverageValuesWithMonth1420(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODGLUCOSE)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (whenIndex == %@ OR whenIndex == %@ OR whenIndex == %@) AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             month, "3", "4", "5", "14", "15", "16", "17", "18", "19", "20")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchBloodGlucoseGetAfterAverageValuesWithMonth2127(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODGLUCOSE)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (whenIndex == %@ OR whenIndex == %@ OR whenIndex == %@) AND (day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@ OR day == %@)",
                                             month, "3", "4", "5", "21", "22", "23", "24", "25", "26", "27")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchBloodGlucoseGetAfterAverageValuesWithMonth2830(month: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODGLUCOSE)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "strMonth == %@ AND (whenIndex == %@ OR whenIndex == %@ OR whenIndex == %@) AND (day == %@ OR day == %@ OR day == %@)",
                                             month, "3", "4", "5", "28", "29", "30")
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    
    //===================================================================
    // fetch Blood Glucose Year
    //===================================================================
    func fetchBloodGlucoseGetAllYearData() -> NSMutableArray {
        let arrayYearData = NSMutableArray.init()
        let arrayYears = self.fetchBloodGlucoseGroupBy(str: "year")
        
        if arrayYears.count > 0 {
            
            for year in arrayYears {
                if (year as! NSDictionary).value(forKey: "year") != nil {
                    let strYear = (year as! NSDictionary).value(forKey: "year") as! String
                    let arrayBefore = self.fetchBloodGlucoseGetBeforeAverageValuesWithYear(year: strYear)
                    let arrayAfter  = self.fetchBloodGlucoseGetAfterAverageValuesWithYear(year: strYear)
                    
                    let yearData = ["year": strYear, "before": arrayBefore, "after": arrayAfter] as NSDictionary
                    arrayYearData.add(yearData)
                }
            }
            
            if arrayYearData.count > 0 {
                return arrayYearData
                
            } else {
                return NSMutableArray.init()
            }
            
        } else {
            return NSMutableArray.init()
        }
        
    }
    
    //===================================================================
    // fetch Blood Pressure Year
    //===================================================================
    func fetchBloodPressureGetAllYearData() -> NSMutableArray {
        let arrayYearData = NSMutableArray.init()
        let arrayYears = self.fetchBloodPressureGroupBy(str: "year")
        
        if arrayYears.count > 0 {
            
            for year in arrayYears {
                if (year as! NSDictionary).value(forKey: "year") != nil {
                    let strYear = (year as! NSDictionary).value(forKey: "year") as! String
                    let arrayData1 = self.fetchBloodPressureGetAverageValue1WithYear(year: strYear)
                    let arrayData2 = self.fetchBloodPressureGetAverageValue2WithYear(year: strYear)
                    
                    let yearData = ["year": strYear, "data1": arrayData1, "data2": arrayData2] as NSDictionary
                    arrayYearData.add(yearData)
                }
                
            }
            
            if arrayYearData.count > 0 {
                return arrayYearData
                
            } else {
                return NSMutableArray.init()
            }
            
        } else {
            return NSMutableArray.init()
        }
        
    }
    
    //===================================================================
    // fetch Oxygen Level Year
    //===================================================================
    func fetchOxygenLevelGetAllYearData() -> NSMutableArray {
        let arrayYearData = NSMutableArray.init()
        let arrayYears = self.fetchOxygenLevelGroupBy(str: "year")
        
        if arrayYears.count > 0 {
            
            for year in arrayYears {
                if (year as! NSDictionary).value(forKey: "year") != nil {
                    let strYear = (year as! NSDictionary).value(forKey: "year") as! String
                    let arrayData = self.fetchOxygenLevelGetAverageValuesWithYear(year: strYear)
                    
                    if arrayData.count > 0 {
                        let yearData = ["year": strYear, "data": arrayData] as NSDictionary
                        arrayYearData.add(yearData)
                    }
                }
            }
            
            if arrayYearData.count > 0 {
                return arrayYearData
                
            } else {
                return NSMutableArray.init()
            }
            
        } else {
            return NSMutableArray.init()
        }
        
    }
    
    //===================================================================
    // fetch Weight Year
    //===================================================================
    func fetchWeightGetAllYearData() -> NSMutableArray {
        let arrayYearData = NSMutableArray.init()
        let arrayYears = self.fetchWeightGroupBy(str: "year")
        let currentYear = self.getYear(date: Date())
        
        if arrayYears.count > 0 {
            let arrayData = self.fetchWeightGetAverageValuesWithYear(year: currentYear)
            
            if arrayData.count > 0 {
                let yearData = ["year": currentYear, "data": arrayData] as NSDictionary
                arrayYearData.add(yearData)
            }
            
            if arrayYearData.count > 0 {
                return arrayYearData
                
            } else {
                return NSMutableArray.init()
            }
            
        } else {
            return NSMutableArray.init()
        }
        
    }
    
    //===================================================================
    // fetch StepsYear
    //===================================================================
    func fetchStepsGetAllYearData() -> NSMutableArray {
        let arrayYearData = NSMutableArray.init()
        let arrayYears = self.fetchStepsGroupBy(str: "year")
        let currentYear = self.getYear(date: Date())
        
        if arrayYears.count > 0 {
            
            let arrayData = self.fetchStepsGetAverageValuesWithYear(year: currentYear)
            
            if arrayData.count > 0 {
                let yearData = ["year": currentYear, "data": arrayData] as NSDictionary
                arrayYearData.add(yearData)
            }
            
            if arrayYearData.count > 0 {
                return arrayYearData
                
            } else {
                return NSMutableArray.init()
            }
            
        } else {
            return NSMutableArray.init()
        }
        
    }
    
    //===================================================================
    // fetch HemoglobinHlc Year
    //===================================================================
    func fetchHemoglobinHlcGetAllYearData() -> NSMutableArray {
        let arrayYearData = NSMutableArray.init()
        let arrayYears = self.fetchHemoglobinGroupBy(str: "year")
        
        if arrayYears.count > 0 {
            
            for year in arrayYears {
                if ((year as! NSDictionary).value(forKey: "year") != nil) {
                    let strYear = (year as! NSDictionary).value(forKey: "year") as! String
                    let arrayData = self.fetchHemoglobinHlcGetAverageValuesWithYear(year: strYear)
                    
                    if arrayData.count > 0 {
                        let yearData = ["year": strYear, "data": arrayData] as NSDictionary
                        arrayYearData.add(yearData)
                    }
                }
            }
            
            if arrayYearData.count > 0 {
                return arrayYearData
                
            } else {
                return NSMutableArray.init()
            }
            
        } else {
            return NSMutableArray.init()
        }
        
    }
    
    
    //===================================================================
    // fetch INR Year
    //===================================================================
    func fetchINRGetAllYearData() -> NSMutableArray {
        let arrayYearData = NSMutableArray.init()
        let arrayYears = self.fetchINRGroupBy(str: "year")
        
        if arrayYears.count > 0 {
            
            for year in arrayYears {
                if ((year as! NSDictionary).value(forKey: "year") != nil) {
                    let strYear = (year as! NSDictionary).value(forKey: "year") as! String
                    let arrayData = self.fetchINRGetAverageValuesWithYear(year: strYear)
                    
                    if arrayData.count > 0 {
                        let yearData = ["year": strYear, "data": arrayData] as NSDictionary
                        arrayYearData.add(yearData)
                    }
                    
                }
                
            }
            
            if arrayYearData.count > 0 {
                return arrayYearData
                
            } else {
                return NSMutableArray.init()
            }
            
        } else {
            return NSMutableArray.init()
        }
        
    }
    
    //===================================================================
    // fetch Lipid Panel Year
    //===================================================================
    func fetchLipidPanelGetAllYearData(index: String) -> NSMutableArray {
        let arrayYearData = NSMutableArray.init()
        let arrayYears = self.fetchLipidPanelGroupBy(str: "year")
        
        if arrayYears.count > 0 {
            
            for year in arrayYears {
                if ((year as! NSDictionary).value(forKey: "year") != nil) {
                    let strYear = (year as! NSDictionary).value(forKey: "year") as! String
                    let arrayData = self.fetchLipidPanelGetAverageValuesWithYear(year: strYear, index: index)
                    
                    if arrayData.count > 0 {
                        let yearData = ["year": strYear, "data": arrayData] as NSDictionary
                        arrayYearData.add(yearData)
                    }
                    
                }
                
            }
            
            if arrayYearData.count > 0 {
                return arrayYearData
                
            } else {
                return NSMutableArray.init()
            }
            
        } else {
            return NSMutableArray.init()
        }
        
    }
    
    
    // fetch Blood Glucose average values for Year and whenindex == 0, 1, 2 by month
    // select sum(ZVALUE), count(*), sum(ZVALUE)/count(*), ZMONTH from ZBLOODGLUCOSE where ZYEAR = 2018 and (ZWHENINDEX = 0 or ZWHENINDEX = 1 or ZWHENINDEX = 2) group by ZMONTH
    
    func fetchBloodGlucoseGetBeforeAverageValuesWithYear(year: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODGLUCOSE)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "year == %@ AND (whenIndex == 0 OR whenIndex == 1 OR whenIndex == 2)", year)
        
        fetchRequest.propertiesToFetch = ["month", expressionDescription]
        fetchRequest.propertiesToGroupBy = ["month"]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchBloodPressureGetAverageValue1WithYear(year: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODPRESSURE)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value1")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "year == %@", year)
        
        fetchRequest.propertiesToFetch = ["month", expressionDescription]
        fetchRequest.propertiesToGroupBy = ["month"]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchBloodPressureGetAverageValue2WithYear(year: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODPRESSURE)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value2")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "year == %@", year)
        
        fetchRequest.propertiesToFetch = ["month", expressionDescription]
        fetchRequest.propertiesToGroupBy = ["month"]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    
    func fetchOxygenLevelGetAverageValuesWithYear(year: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZOXYGENLEVEL)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "year == %@", year)
        
        fetchRequest.propertiesToFetch = ["month", expressionDescription]
        fetchRequest.propertiesToGroupBy = ["month"]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchWeightGetAverageValuesWithYear(year: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZWEIGHT)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "year == %@ AND value != %@", year, "0.0")
        
        fetchRequest.propertiesToFetch = ["month", expressionDescription]
        fetchRequest.propertiesToGroupBy = ["month"]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchStepsGetAverageValuesWithYear(year: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZSTEPS)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .floatAttributeType
        
        fetchRequest.predicate = NSPredicate(format: "year == %@", year)
        
        fetchRequest.propertiesToFetch = ["month", expressionDescription]
        fetchRequest.propertiesToGroupBy = ["month"]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchHemoglobinHlcGetAverageValuesWithYear(year: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZHEMOGLOBINALC)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "year == %@", year)
        
        fetchRequest.propertiesToFetch = ["month", expressionDescription]
        fetchRequest.propertiesToGroupBy = ["month"]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchINRGetAverageValuesWithYear(year: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZINR)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "year == %@", year)
        
        fetchRequest.propertiesToFetch = ["month", expressionDescription]
        fetchRequest.propertiesToGroupBy = ["month"]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchLipidPanelGetAverageValuesWithYear(year: String, index: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZLIPIDPANEL)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "year == %@ AND index == %@", year, index)
        
        fetchRequest.propertiesToFetch = ["month", expressionDescription]
        fetchRequest.propertiesToGroupBy = ["month"]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    func fetchBloodGlucoseGetAfterAverageValuesWithYear(year: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZBLOODGLUCOSE)
        
        let valueExpression: NSExpression = NSExpression.init(forKeyPath: "value")
        // average
        let averageExpression: NSExpression = NSExpression.init(forFunction: "average:", arguments: [valueExpression])
        
        let expressionDescription: NSExpressionDescription = NSExpressionDescription.init()
        let expressionName = "average"
        
        expressionDescription.name = expressionName
        expressionDescription.expression = averageExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fetchRequest.predicate = NSPredicate(format: "year == %@ AND (whenIndex == 3 OR whenIndex == 4 OR whenIndex == 5)", year)
        
        fetchRequest.propertiesToFetch = ["month", expressionDescription]
        fetchRequest.propertiesToGroupBy = ["month"]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    
    //===================================================================
    // fetch Oxygen level Week
    //===================================================================
    func fetchOxygenLevelGetAllWeekData() -> NSMutableArray {
        let arrayWeekData = NSMutableArray.init()
        let arrayWeeks = self.fetchOxygenLevelGroupBy(str: "strWeek")
        
        if arrayWeeks.count > 0 {
            
            for week in arrayWeeks {
                if (week as! NSDictionary).value(forKey: "strWeek") != nil {
                    let strWeek = (week as! NSDictionary).value(forKey: "strWeek") as! String
                    let arrayData = self.fetchOxygenLevelWithWeek(week: strWeek)
                    
                    if arrayData.count > 0 {
                        let weekData = ["strWeek": strWeek, "data": arrayData] as NSDictionary
                        arrayWeekData.add(weekData)
                    }
                    
                }
                
            }
            
            if arrayWeekData.count > 0 {
                return arrayWeekData
                
            } else {
                return NSMutableArray.init()
            }
            
        } else {
            return NSMutableArray.init()
        }
        
    }
    
    func fetchOxygenLevelWithWeek(week: String) -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZOXYGENLEVEL)
        fetchRequest.predicate = NSPredicate(format: "strWeek == %@", week)
        fetchRequest.propertiesToFetch = ["value", "strDate"]
        fetchRequest.resultType = .dictionaryResultType
        
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
        
    }
    
    // fetch Mood
    func fetchMood() -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZMOOD)
        let dateSort = NSSortDescriptor.init(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    // fetch Hemoglobin Alc
    func fetchHemoglobinAlc() -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZHEMOGLOBINALC)
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    // fetch INR
    func fetchINR() -> NSArray {
        self.context = self.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ZINR)
        let dateSort = NSSortDescriptor.init(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            return try context.fetch(fetchRequest) as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return NSArray.init()
        }
    }
    
    
}
