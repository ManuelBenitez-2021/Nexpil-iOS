//
//  DetectedBreak.swift
//  VisionAPIClient
//
//  Created by Cagri Sahan on 6/19/18.
//  Copyright © 2018 Cagri Sahan. All rights reserved.
//

public enum BreakType: String, Codable {
    case UNKNOWN
    case SPACE
    case SURE_SPACE
    case EOL_SURE_SPACE
    case HYPHEN
    case LINE_BREAK
}

public struct DetectedBreak: Codable {
    let type: BreakType
    let isPrefix: Bool?
}
