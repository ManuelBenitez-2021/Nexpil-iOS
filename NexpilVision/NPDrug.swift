//
//  NPDrug.swift
//  NexpilVision
//
//  Created by Cagri Sahan on 8/23/18.
//  Copyright © 2018 Cagri Sahan. All rights reserved.
//

import Foundation

public class NPDrug: Codable, CustomStringConvertible {
    var name: String
    var dosage: String
    var form: String
    var manufacturer: String?
    var ndc: String?
    
    public var description: String {
        return "\(name) \(dosage) \(form)"
    }
    
    public init(name: String, dosage: String, form: String, manufacturer: String, ndc: String) {
        self.name = name
        self.dosage = dosage
        self.form = form
        self.manufacturer = manufacturer
        self.ndc = ndc
    }
    
    public class func getDrug(by ndc: String, completionHandler: @escaping (NPDrug) -> Void) {
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: NPVisionDataUtils.NDC_URL)!)
        request.httpMethod = "POST"
        request.httpBody = "NDCNumber=\(ndc)".data(using: .utf8)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            do {
                let drug = try decoder.decode(NPDrug.self, from: data)
                completionHandler(drug)
            }
            catch { return }
        }
        task.resume()
    }
    
    public class func getDrug(name: String, dosage: String, form: String, manufacturer: String, completionHandler: @escaping (NPDrug) -> Void) {
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: NPVisionDataUtils.NDC_URL)!)
        request.httpMethod = "POST"
        request.httpBody = "DrugName=\(name)&Dosage=\(dosage)&DrugForm=\(form)&Manufacturer=\(manufacturer)".data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            print(data)
            let decoder = JSONDecoder()
            do {
                let drug = try decoder.decode(NPDrug.self, from: data)
                completionHandler(drug)
            }
            catch { print("error: \(error)"); return }
        }
        task.resume()
    }
}
