//
//  Feature.swift
//  VisionAPIClient
//
//  Created by Cagri Sahan on 6/18/18.
//  Copyright © 2018 Cagri Sahan. All rights reserved.
//
public enum Type: String, Codable {
    case TYPE_UNSPECIFIED
    case FACE_DETECTION
    case LANDMARK_DETECTION
    case LOGO_DETECTION
    case LABEL_DETECTION
    case TEXT_DETECTION
    case DOCUMENT_TEXT_DETECTION
    case SAFE_SEARCH_DETECTION
    case IMAGE_PROPERTIES
    case CROP_HINTS
    case WEB_DETECTION
}

public struct Feature: Codable {
    public let type: Type
    public let maxResults: Int?
    public let model: String?
    
    public init(type: Type) {
        self.type = type
        self.maxResults = nil
        self.model = nil
    }
}
