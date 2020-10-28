//
//  LatLongRect.swift
//  VisionAPIClient
//
//  Created by Cagri Sahan on 6/18/18.
//  Copyright © 2018 Cagri Sahan. All rights reserved.
//

public struct LatLongRect: Codable {
    public let minLatLng: LatLng
    public let maxLatLng: LatLng
}
