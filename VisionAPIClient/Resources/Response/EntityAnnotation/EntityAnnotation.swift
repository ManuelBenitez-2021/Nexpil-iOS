//
//  EntityAnnotation.swift
//  VisionAPIClient
//
//  Created by Cagri Sahan on 6/18/18.
//  Copyright © 2018 Cagri Sahan. All rights reserved.
//

public struct EntityAnnotation: Codable {
    public let mid: String?
    public let locale: String?
    public let description: String
    public let score: Float?
    public let topicality: Float?
    public let boundingPoly: BoundingPoly?
    public let locations: LocationInfo?
    public let properties: [Property]?
}
