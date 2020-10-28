//
//  DetectedLanguage.swift
//  VisionAPIClient
//
//  Created by Cagri Sahan on 6/19/18.
//  Copyright © 2018 Cagri Sahan. All rights reserved.
//

public struct DetectedLanguage: Codable {
    public let languageCode: String
    public let confidence: Float?
}
