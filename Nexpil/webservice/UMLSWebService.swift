//
//  UMLSWebService.swift
//  Nexpil
//
//  Created by Admin on 4/13/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

import UIKit

import Alamofire

protocol ReceiveMedicalDelegate {
    func getMedicalData(_: [[String:Any]])
}

public class UMLSWebService {
    var receiveMedicalDelegate: ReceiveMedicalDelegate?
    func callDrugAPI()
    {
        let st = DataUtils.getST()!
        print(st)
        receiveMedicalDelegate?.getMedicalData([[:]] )
    }
    
    func apicall()
    {
        let sttime = DataUtils.getSTTime()
        if sttime != nil {
            let currentDateTime = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var previousDateTime = formatter.date(from: sttime!)
            if currentDateTime.timeIntervalSince(previousDateTime!) > 5 * 60 //5 mins
            {
                let tgttime = DataUtils.getTGTTime()
                if tgttime != nil {
                    previousDateTime = formatter.date(from: tgttime!)
                    if (currentDateTime.timeIntervalSince(previousDateTime!)) < 8 * 60 * 60 //8 hours
                    {
                        getTGT(tgt: DataUtils.getTGT()!)
                        return
                    }
                }
            }
            else{
                callDrugAPI()
                return
            }
        }
        else {
            let currentDateTime = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let tgttime = DataUtils.getTGTTime()
            if tgttime != nil {
                let previousDateTime = formatter.date(from: tgttime!)
                if (currentDateTime.timeIntervalSince(previousDateTime!)) < 8 * 60 * 60 //8 hours
                {
                    getTGT(tgt: DataUtils.getTGT()!)
                    return
                }
                
            }
        }
        
        let params = [
            "apikey" : DataUtils.API_KEY,
            
            ] as [String : Any]
        //DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        
        Alamofire.request(DataUtils.UMLS_AUTH, method: .post, parameters: params, encoding: URLEncoding()).response { response in
            //DataUtils.customActivityIndicatory(self.view,startAnimate: false)
            if let url = response.response?.allHeaderFields["Location"] as? String {
                // use contentType here
                print(url)
                
                if let range = url.range(of: "TGT") {
                    let substring = url[range.lowerBound...]
                    print(substring)  // Prints ab
                    //let tgt = url.substring(index.)
                    DataUtils.setTGT(st: String(substring))
                    let currentDateTime = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let label = formatter.string(from: currentDateTime)
                    DataUtils.setTGTTime(time: label)
                    self.getTGT(tgt:String(substring))
                }
                else {
                    //DataUtils.messageShow(view: self, message: "Did not receive key", title: "")
                    print("did not receive key")
                }
                
            }
            else{
                //DataUtils.messageShow(view: self, message: "There is a problem", title: "")
                print("response error")
            }
        }
    }
    
    func getTGT(tgt:String)
    {
        let params = [
            "service" : DataUtils.UMLS_SERVICE,
            
            ] as [String : Any]
        //DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        
        Alamofire.request(DataUtils.TICKET_URL + tgt, method: .post, parameters: params, encoding: URLEncoding()).responseString { response in
            //DataUtils.customActivityIndicatory(self.view,startAnimate: false)
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    print(data)
                    
                    let currentDateTime = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let label = formatter.string(from: currentDateTime)
                    DataUtils.setSTTime(time: label)
                    
                    DataUtils.setST(st: data)
                    self.callDrugAPI()
                }
                
            case .failure(_):
                //DataUtils.messageShow(view: self, message: (response.result.error?.localizedDescription)!, title: "")
                print(response.result.error?.localizedDescription)
                break
            }
        }
    }
}
