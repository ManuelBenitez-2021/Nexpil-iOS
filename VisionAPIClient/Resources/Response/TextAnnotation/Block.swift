//
//  Block.swift
//  VisionAPIClient
//
//  Created by Cagri Sahan on 6/19/18.
//  Copyright © 2018 Cagri Sahan. All rights reserved.
//

public enum BlockType: String, Codable {
    case UNKNOWN
    case TEXT
    case TABLE
    case PICTURE
    case RULER
    case BARCODE
}

public struct Block: Codable {
    public let property: TextProperty?
    public let boundingBox: BoundingPoly
    public var paragraphs: [Paragraph]
    public let blockType: BlockType
    public let confidence: Float?
    
    public var text: String {
        get {
            let block = paragraphs.map { $0.text }
            return block.joined(separator: "")
        }
    }
    
    public mutating func complete(from page: Page) {
        for i in 0..<self.paragraphs.count {
            for block in page.blocks {
                for rightParagraph in block.paragraphs {
                    paragraphs[i].complete(from: rightParagraph)
                }
            }
        }
    }
}
