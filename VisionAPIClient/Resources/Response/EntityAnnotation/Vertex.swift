//
//  Vertex.swift
//  VisionAPIClient
//
//  Created by Cagri Sahan on 6/18/18.
//  Copyright © 2018 Cagri Sahan. All rights reserved.
//

import Foundation

public struct Vertex: Codable {
    public let x: Int
    public let y: Int
    
    public func taxiDistance(from origin: Vertex) -> Int {
        return abs(self.x - origin.x) + abs(self.y - origin.y)
    }
    
    public func distance(from origin: Vertex) -> Double {
        return sqrt(pow(Double(origin.x - self.x), 2) + pow(Double(origin.y - self.y), 2))
    }
}
