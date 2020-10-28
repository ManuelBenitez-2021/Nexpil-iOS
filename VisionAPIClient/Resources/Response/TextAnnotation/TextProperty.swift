//
//  TextProperty.swift
//  VisionAPIClient
//
//  Created by Cagri Sahan on 6/19/18.
//  Copyright © 2018 Cagri Sahan. All rights reserved.
//

public struct TextProperty: Codable {
    public let detectedLanguages: [DetectedLanguage]?
    public let detectedBreak: DetectedBreak?
}
