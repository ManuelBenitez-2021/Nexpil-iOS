//
//  BoundingPoly.swift
//  VisionAPIClient
//
//  Created by Cagri Sahan on 6/18/18.
//  Copyright © 2018 Cagri Sahan. All rights reserved.
//

public struct BoundingPoly: Codable {
    public let vertices: [Vertex]
    
    public var center: Vertex {
        get {
            let x = (vertices[0].x + vertices[2].x) / 2
            let y = (vertices[0].y + vertices[2].y) / 2
            return Vertex(x: x, y: y)
        }
    }
    
    public var maxX: Int {
        var bound: Int = 0
        for vertex in vertices {
            if vertex.x > bound {
                bound = vertex.x
            }
        }
        return bound
    }
    
    public var minX: Int {
        var bound: Int = Int.max
        for vertex in vertices {
            if vertex.x < bound {
                bound = vertex.x
            }
        }
        return bound
    }
    
    public var maxY: Int {
        var bound: Int = 0
        for vertex in vertices {
            if vertex.y > bound {
                bound = vertex.y
            }
        }
        return bound
    }
    
    public var minY: Int {
        var bound: Int = Int.max
        for vertex in vertices {
            if vertex.y < bound {
                bound = vertex.y
            }
        }
        return bound
    }
    
    public var height: Int {
        return maxY - minY
    }
    
    public var width: Int {
        return maxX - minX
    }
}
