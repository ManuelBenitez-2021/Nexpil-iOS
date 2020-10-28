//
//  AnnotateImageRequest.swift
//  VisionAPIClient
//
//  Created by Cagri Sahan on 6/18/18.
//  Copyright © 2018 Cagri Sahan. All rights reserved.
//

import Foundation

public struct AnnotateImageRequest: Codable {
    public let image: Image
    public let features: [Feature]
    public let imageContext: ImageContext?
    
    public init(image: Image, features: [Feature], context: ImageContext?) {
        self.image = image
        self.features = features
        self.imageContext = context
    }
}
