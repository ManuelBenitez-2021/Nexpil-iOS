//
//  Response.swift
//  VisionAPIClient
//
//  Created by Cagri Sahan on 6/19/18.
//  Copyright © 2018 Cagri Sahan. All rights reserved.
//

public struct Response: Codable {
    public let responses: [AnnotateImageResponse]
}
