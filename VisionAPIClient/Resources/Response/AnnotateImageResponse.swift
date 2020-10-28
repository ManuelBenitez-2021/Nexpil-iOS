//
//  AnnotateImageResponse.swift
//  VisionAPIClient
//
//  Created by Cagri Sahan on 6/18/18.
//  Copyright © 2018 Cagri Sahan. All rights reserved.
//

public struct AnnotateImageResponse: Codable {
    public let logoAnnotations: [EntityAnnotation]?
    public let textAnnotations: [EntityAnnotation]?
    public let fullTextAnnotation: TextAnnotation?
}
