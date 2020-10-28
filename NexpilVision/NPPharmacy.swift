//
//  NPPharmacy.swift
//  NexpilVision
//
//  Created by Cagri Sahan on 8/23/18.
//  Copyright © 2018 Cagri Sahan. All rights reserved.
//

import Foundation
import MapKit

public class NPPharmacy: CustomStringConvertible {
    let name: String
    let address: String
    let phone: String
    
    public var description: String {
        return name
    }
    
    public init(name: String, address: String, phone: String) {
        self.name = name
        self.address = address
        self.phone = phone
    }
    
    public class func getPharmacy(at address: String, completionHandler: @escaping ([NPPharmacy]) -> Void) -> Void {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: { locations, error in
            guard error == nil else { return }
            guard let locations = locations else { return }
            guard let location = locations.first else { return }
            guard let addressRegion = location.region as? CLCircularRegion else { return }
            
            let region = MKCoordinateRegionMakeWithDistance(addressRegion.center, addressRegion.radius, addressRegion.radius)
            let request = MKLocalSearchRequest()
            request.region = region
            request.naturalLanguageQuery = "pharmacy"
            let search = MKLocalSearch(request: request)
            search.start(completionHandler: { (response, error) in
                guard error == nil else { return }
                guard let response = response else { return }
                
                let pharmacies = response.mapItems.filter { addressRegion.contains($0.placemark.coordinate) && address.components(separatedBy: " ").first == $0.placemark.subThoroughfare }
                
                guard !pharmacies.isEmpty else { return }
                
                let npPharmacies = pharmacies.filter({ (item) -> Bool in
                    return item.name != nil && item.placemark.title != nil && item.phoneNumber != nil
                }).map {
                    return NPPharmacy(name: $0.name!, address: $0.placemark.title!, phone: $0.phoneNumber!)
                }
                completionHandler(npPharmacies)
            }
                
            )
        })
    }
    
    public class func getPharmacy(phoneNumber: String, completionHandler: @escaping (NPPharmacy) -> Void) -> Void {
        let number = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = number
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: { (response, error) in
            guard error == nil else { return }
            guard let response = response else { return }
            let pharmacies = response.mapItems.filter { $0.phoneNumber?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() == "1\(number)" }
            
            guard !pharmacies.isEmpty else { return }
            
            let pharmacy = pharmacies.first!
            
            guard let name = pharmacy.name else { return }
            guard let address = pharmacy.placemark.title else { return }
            guard let phone = pharmacy.phoneNumber else { return }
            
            completionHandler(NPPharmacy(name: name, address: address, phone: phone))
        })
    }
}
