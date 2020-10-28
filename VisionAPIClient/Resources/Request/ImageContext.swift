//
//  ImageContext.swift
//  VisionAPIClient
//
//  Created by Cagri Sahan on 6/18/18.
//  Copyright © 2018 Cagri Sahan. All rights reserved.
//

public struct ImageContext: Codable {
    public let latLongRect: LatLongRect?
    public let languageHints: [String]?
    public let cropHintsPatams: CropHintsParams?
    public let WebDetectionParams: WebDetectionParams?
}
