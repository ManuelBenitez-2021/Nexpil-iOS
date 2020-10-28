//
//  NPPrescriptionFinder.swift
//  NexpilVision
//
//  Created by Cagri Sahan on 7/11/18.
//  Copyright © 2018 Cagri Sahan. All rights reserved.
//

import Foundation

public enum NPPrescriptionEvent {
    case foundPatientName
    case foundPharmacy
    case foundFillDate
    case foundPrescriptionNumber
    case foundDoctorName
    case foundDose
    case foundFrequency
    case foundDrug
    case foundDrugQuantity
    case prescriptionComplete
}

public class NPPrescriptionFinder {
    
    var pages: [Page] = [] {
        didSet {
            for i in 0..<pages.count-1 {
                for j in 0..<pages[i].blocks.count {
                    pages[i].blocks[j].complete(from: pages.last!)
                }
            }
            scrapePages()
        }
    }
    
    var phoneNumbers: [String] = []
    
    var patientName: String? = "Scott Studner" {
        didSet {
            delegate.handleEvent(.foundPatientName)
            if isComplete() {
                delegate.handleEvent(.prescriptionComplete)
            }
        }
    }
    
    var fillDate: Date? {
        didSet {
            delegate.handleEvent(.foundFillDate)
            if isComplete() {
                delegate.handleEvent(.prescriptionComplete)
            }
        }
    }
    
    var prescriptionNumber: String? {
        didSet {
            delegate.handleEvent(.foundPrescriptionNumber)
            if isComplete() {
                delegate.handleEvent(.prescriptionComplete)
            }
        }
    }
    
    var doctorName: String? {
        didSet {
            delegate.handleEvent(.foundDoctorName)
            if isComplete() {
                delegate.handleEvent(.prescriptionComplete)
            }
        }
    }
    
    var directions: String? {
        didSet {
            guard frequency == nil || dose == nil else { return }
            directions = directions!.replacingOccurrences(of: "\n", with: " ")
            dose = {
                let regex = try! NSRegularExpression(pattern: "take ([1-9]|one|two|three|four|five) \\w+", options: [.caseInsensitive])
                let matches = regex.matches(in: directions!, options: [], range: NSRange(location: 0, length: directions!.count)).map {
                    String(directions![Range($0.range, in: directions!)!])
                }
                return matches.first?.capitalized
            }()
            frequency = {
                let regex = try! NSRegularExpression(pattern: "((once|twice)|((one|two|three|four|five|[1-9]) times?)) (daily|(a day))", options: [.caseInsensitive])
                let matches = regex.matches(in: directions!, options: [], range: NSRange(location: 0, length: directions!.count)).map {
                    String(directions![Range($0.range, in: directions!)!])
                }
                return matches.first?.capitalized
            }()
            if frequency == nil {
                if directions!.lowercased().contains("as needed") {
                    frequency = "As Needed"
                }
                else {
                    let regex = try! NSRegularExpression(pattern: "(([1-9]|one|two|three|four|five) ((?!times?))\\w+) ((daily)|(a day)|(every day))", options: [.caseInsensitive])
                    let matches = regex.matches(in: directions!, options: [], range: NSRange(location: 0, length: directions!.count))
                    if let match = matches.first {
                        dose = String(directions![Range(match.range(at: 1), in: directions!)!]).capitalized
                        frequency = String(directions![Range(match.range(at: 4), in: directions!)!]).capitalized
                    }
                }
            }
            if isComplete() {
                delegate.handleEvent(.prescriptionComplete)
            }
        }
    }
    
    var dose: String? {
        didSet {
            guard dose != nil else { return }
            delegate.handleEvent(.foundDose)
            if isComplete() {
                delegate.handleEvent(.prescriptionComplete)
            }
        }
    }
    
    var frequency: String? {
        didSet {
            guard frequency != nil else { return }
            delegate.handleEvent(.foundFrequency)
            if isComplete() {
                delegate.handleEvent(.prescriptionComplete)
            }
        }
    }
    
    var drugQuantity: Int? {
        didSet {
            delegate.handleEvent(.foundDrugQuantity)
            if isComplete() {
                delegate.handleEvent(.prescriptionComplete)
            }
        }
    }
    
    var NDCCode: String? {
        didSet {
            NPDrug.getDrug(by: NDCCode!) { (drug) in
                self.drug = drug
            }
        }
    }
    
    var drug: NPDrug? {
        didSet {
            delegate.handleEvent(.foundDrug)
            if isComplete() {
                delegate.handleEvent(.prescriptionComplete)
            }
        }
    }
    
    var pharmacy: NPPharmacy? {
        didSet {
            delegate.handleEvent(.foundPharmacy)
            if isComplete() {
                delegate.handleEvent(.prescriptionComplete)
            }
        }
    }
    
    var manufacturer: String? {
        didSet {
            if drugName != nil && drugDosage != nil && drugForm != nil {
                NPDrug.getDrug(name: drugName!, dosage: drugDosage!, form: drugForm!, manufacturer: manufacturer!) { (drug) in
                    self.drug = drug
                }
            }
        }
    }
    
    var drugName: String?
    var drugDosage: String?
    var drugForm: String?
    
    public static let shared = NPPrescriptionFinder()
    private init() {}
    
    public var delegate: NPPrescriptionEventHandler!
    public var userName: String!
    
    public func getDrugData(withNDC: String) {
        
    }
    
    public func addResponse(_ response: Response) {
        if let annotationResponse = response.responses.first {
            if let page = annotationResponse.fullTextAnnotation?.pages.first {
                pages.append(page)
            }
        }
    }
    
    public func scrapePages() {
        for page in self.pages {
            for block in page.blocks {
                
                findPhoneNumber(in: block)
                findPrescriptionNumber(in: block)
                findNDCCode(in: block)
                findPharmacyInfo(in: block)
                findDrugQuantity(in: block)
                findFillDate(in: block)
                findManufacturer(in: block)
                findDrug(in: block)
                findDoctorName(in: block)
                findDirections(in: block)
            }
        }
    }
    
    func findPhoneNumber(in block: Block) {
        guard pharmacy == nil else { return }
        
        let string = block.text
        let regex = try! NSRegularExpression(pattern: "\\([0-9]{3}\\) ?[0-9]{3}-? ?[0-9]{4}", options: [.anchorsMatchLines])
        let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count)).map {
            String(string[Range($0.range, in: string)!])
        }
        if let match =  matches.first {
            phoneNumbers.append(match)
            NPPharmacy.getPharmacy(phoneNumber: match) { [unowned self] pharmacy in
                self.pharmacy = pharmacy
            }
        }
    }
    
    func findPharmacyInfo(in block: Block) {
        guard pharmacy == nil else { return }
        
        let string = block.text
        let regex = try! NSRegularExpression(pattern: "^[0-9]+.+\n?.* [0-9]{5}", options: [.anchorsMatchLines])
        let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count)).map {
            String(string[Range($0.range, in: string)!])
        }
        if let match =  matches.first {
            let pharmacyAddress = match
            NPPharmacy.getPharmacy(at: pharmacyAddress) { [unowned self] pharmacies in
                if pharmacies.count == 1 {
                    self.pharmacy = pharmacies.first
                }
                else if !self.phoneNumbers.isEmpty {
                    let numbers = self.phoneNumbers.map { $0.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() }
                    let filtered = pharmacies.filter { item in
                        
                        let itemPhone = item.phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                        return numbers.contains(itemPhone)
                    }
                    
                    if !filtered.isEmpty {
                        self.pharmacy = filtered.first!
                    }
                }
            }
        }
    }
    
    func findPrescriptionNumber(in block: Block) {
        guard prescriptionNumber == nil else { return }
        
        let string = block.text
        let regex = try! NSRegularExpression(pattern: "(?:R?x:? ?#? ?)([A-Z]?[0-9]{6,}-?[0-9]{0,6} ?[A-Z]?)", options: [.caseInsensitive])
        let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count)).map {
            String(string[Range($0.range, in: string)!])
        }
        if let match =  matches.first {
            prescriptionNumber = match
        }
    }
    
    func findDrugQuantity(in block: Block) {
        guard drugQuantity == nil else { return }
        
        let string = block.text
        let regex = try! NSRegularExpression(pattern: "(?:\\bQTY:? ?)([0-9]+)", options: [.caseInsensitive])
        let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
        if let match = matches.first {
            let group = match.range(at: 1)
            let range = Range(group, in: string)!
            drugQuantity = Int(string[range])
        }
    }
    
    func findManufacturer(in block: Block) {
        let string = block.text
        let regex = try! NSRegularExpression(pattern: "(?:(MFR|MFG|MANUFACTURER):? ? )(\\w+)", options: [.caseInsensitive])
        let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
        if let match = matches.first {
            let group = match.range(at: 2)
            let range = Range(group, in: string)!
            manufacturer = String(string[range])
        }
    }
    
    func findDrug(in block: Block) {
        guard drug == nil else { return }
        
        let string = block.text
        let regex = try! NSRegularExpression(pattern: "\\b[1-9]\\.?[0-9]* ?M[A-Z]{1,3}(\\/[A-Z]{0,3})?", options: [.caseInsensitive])
        let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count)).map {
            String(string[Range($0.range, in: string)!])
        }
        if let match = matches.first {
            drugDosage = match
            // Find drug name
            let regex = try! NSRegularExpression(pattern: ".*(?= \(drugDosage!))", options: [])
            let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count)).map {
                String(string[Range($0.range, in: string)!])
            }
            if let match = matches.first {
                drugName = match
                // Find drug form
                let regex = try! NSRegularExpression(pattern: "(?<=\(drugDosage!))(?:\n| )(\\w*)", options: [])
                let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
                
                if let match = matches.first {
                    let group = match.range(at: 1)
                    if group.length > 0 {
                        let range = Range(group, in: string)!
                        drugForm = String(string[range])
                        if manufacturer != nil {
                            NPDrug.getDrug(name: drugName!, dosage: drugDosage!, form: drugForm!, manufacturer: manufacturer!) { (drug) in
                                self.drug = drug
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    func findFillDate(in block: Block) {
        guard fillDate == nil else { return }
        
        let string = block.text
        let regex = try! NSRegularExpression(pattern: "[0-1][0-9]\\/[0-9]{2}\\/[0-9]{2,4}", options: [])
        let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count)).map {
            String(string[Range($0.range, in: string)!])
        }
        if (!matches.isEmpty) {
            var result: Date?
            var difference: TimeInterval = TimeInterval.greatestFiniteMagnitude
            let formatter = DateFormatter()
            for match in matches {
                if match.count == 8 {
                    formatter.dateFormat = "MM/dd/yy"
                }
                else {
                    formatter.dateFormat = "MM/dd/yyyy"
                }
                guard let date = formatter.date(from: matches.first!) else { return }
                if date <= Date() {
                    if date.timeIntervalSinceNow <= difference {
                        result = date
                        difference = date.timeIntervalSinceNow
                    }
                }
            }
            if result != nil {
                fillDate = result!
            }
        }
    }
    
    func findDoctorName(in block: Block) {
        guard doctorName == nil else { return }
        
        let string = block.text
        let regex = try! NSRegularExpression(pattern: "([A-Z]+,? [A-Z]+,? MD)|((?<=Dr. ).*)|((?<=rescriber: ).*)|((?<=rescriber\n).*)|((?<=PBR: ).*)", options: [])
        let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count)).map {
            String(string[Range($0.range, in: string)!])
        }
        if let match = matches.first {
            doctorName = match.capitalized
        }
    }
    
    func findDirections(in block: Block) {
        let string = block.text
        let regex = try! NSRegularExpression(pattern: "TAKE.*(\n.*)*", options: [.caseInsensitive])
        let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count)).map {
            String(string[Range($0.range, in: string)!])
        }
        if let match = matches.first {
            if directions != nil {
                if directions!.count < match.count {
                    directions = match
                }
            }
            else {
                directions = match
            }
        }
    }
    
    func findNDCCode(in block: Block) {
        let string = block.text
        let regex = try! NSRegularExpression(pattern: "(?:NDC:? ?#? ?)(\\b([0-9]{5}-[0-9]{3,4})|([0-9]{4}-[0-9]{4})\\b)|([0-9]{11})", options: [])
        let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
        if let match = matches.first {
            let group = match.range(at: 1).length > 0 ? match.range(at: 1) : match.range(at: 4)
            let range = Range(group, in: string)!
            NDCCode = String(string[range])
        }
    }
    
    func isComplete() -> Bool {
        if patientName == nil || pharmacy == nil || fillDate == nil || prescriptionNumber == nil || doctorName == nil || dose == nil || frequency == nil || drug == nil || drugQuantity == nil {
            print("\(patientName), \(pharmacy), \(fillDate), \(prescriptionNumber), \(doctorName), \(dose), \(frequency), \(drug), \(drugQuantity)")
            return false
        }
        else {
            return true
        }
    }
    
    public func getPrescription() -> NPPrescription {
        let prescription = NPPrescription(patientName: patientName, pharmacy: pharmacy, fillDate: fillDate, prescriptionNumber: prescriptionNumber, doctorName: doctorName, dose: dose, frequency: frequency, drug: drug!, drugQuantity: drugQuantity)
        return prescription
    }
}
