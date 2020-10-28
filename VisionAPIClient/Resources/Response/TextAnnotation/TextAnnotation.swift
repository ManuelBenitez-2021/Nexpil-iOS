//
//  TextAnnotation.swift
//  VisionAPIClient
//
//  Created by Cagri Sahan on 6/19/18.
//  Copyright © 2018 Cagri Sahan. All rights reserved.
//

public struct TextAnnotation: Codable {
    public let pages: [Page]
    public let text: String
}
