//
//  Paragraph.swift
//  VisionAPIClient
//
//  Created by Cagri Sahan on 6/19/18.
//  Copyright © 2018 Cagri Sahan. All rights reserved.
//

public struct Paragraph: Codable {
    public let property: TextProperty?
    public let boundingBox: BoundingPoly
    public let words: [Word]
    public let confidence: Float?
    
    public var _text: String? = nil
    
    public var text: String {
        get {
            if let content = _text {
                return content
            }
            else {
                let paragraph = words.reduce("") { chunk, word in
                    let br: String
                    if let textBreak = word.symbols.last?.property?.detectedBreak?.type {
                        switch textBreak {
                        case .UNKNOWN, .SPACE:
                            br = " "
                        case .SURE_SPACE:
                            br = "\t"
                        case .HYPHEN:
                            br = "-"
                        case .LINE_BREAK, .EOL_SURE_SPACE:
                            br = "\n"
                        }
                    }
                    else {
                        br = ""
                    }
                    return chunk + word.text + br
                }
                return paragraph
            }
        }
    }
    
    public mutating func complete(from paragraph: Paragraph) {
        
        let leftLines = self.text.split(separator: "\n")
        let leftLinesTrimmed = leftLines.map { line -> String in
            // Don't take last character - might be distorted
            let index = line.index(before: line.endIndex)
            return String(line[..<index])
            }.filter({$0.count > 1})
        
        
        let rightLines = paragraph.text.split(separator: "\n")
        let rightLinesTrimmed = rightLines.map { line -> String in
            // Don't take first character - might be distorted
            let index = line.index(after: line.startIndex)
            return String(line[index...])
            }.filter({$0.count > 1})
        
        for rightLine in rightLinesTrimmed {
            // Offset these by 1 so it's a match only if the more than the last and first two characters match
            if rightLine.count > 2 {
                for leftLine in leftLinesTrimmed {
                    if leftLine.count > 2 {
                        var startIndex = rightLine.startIndex
                        var endIndex = leftLine.endIndex
                        
                        
                        for _ in 1...(leftLine.count<rightLine.count ? leftLine.count : rightLine.count) {
                            startIndex = rightLine.index(startIndex, offsetBy: 1)
                            endIndex = leftLine.index(endIndex, offsetBy: -1)
                            if rightLine[..<startIndex] == leftLine[endIndex...] && startIndex.encodedOffset > 2 {
                                let newLines = leftLinesTrimmed.map { string -> String in
                                    if leftLine != string {
                                        return String(leftLines[leftLinesTrimmed.index(of: string)!])
                                    }
                                    else {
                                        return String(leftLine[..<endIndex] + rightLine)
                                    }
                                }
                                _text = newLines.joined(separator: "\n")
                                print(_text)
                            }
                        }
                    }
                }
            }
        }
    }
}
