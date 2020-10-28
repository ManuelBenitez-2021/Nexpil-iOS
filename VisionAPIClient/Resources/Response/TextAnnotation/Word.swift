//
//  Word.swift
//  VisionAPIClient
//
//  Created by Cagri Sahan on 6/19/18.
//  Copyright © 2018 Cagri Sahan. All rights reserved.
//

public struct Word: Codable {
    public let property: TextProperty?
    public let boundingBox: BoundingPoly
    public var symbols: [Symbol]
    public let confidence: Float?
    
    public var text: String {
        get {
            var word = ""
            for symbol in self.symbols {
                word += symbol.text
            }
            return word
        }
    }
}
