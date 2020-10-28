//
//  Image.swift
//  VisionAPIClient
//
//  Created by Cagri Sahan on 6/18/18.
//  Copyright © 2018 Cagri Sahan. All rights reserved.
//

public struct Image: Codable {
    public let content: String?
    public let source: ImageSource?
    
    public init(fromContent content: String) {
        self.content = content
        self.source = nil
    }
    
    public init(fromSource source: ImageSource?) {
        self.content = nil
        self.source = source
    }
}
