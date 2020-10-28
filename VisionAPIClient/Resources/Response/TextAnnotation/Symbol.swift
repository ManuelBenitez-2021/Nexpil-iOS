//
//  Symbol.swift
//  VisionAPIClient
//
//  Created by Cagri Sahan on 6/19/18.
//  Copyright © 2018 Cagri Sahan. All rights reserved.
//

public struct Symbol: Codable {
    public let property: TextProperty?
    public let boundingBox: BoundingPoly
    public let text: String
    public let confidence: Float?
}
