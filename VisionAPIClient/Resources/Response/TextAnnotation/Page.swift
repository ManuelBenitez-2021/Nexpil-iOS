//
//  Page.swift
//  VisionAPIClient
//
//  Created by Cagri Sahan on 6/19/18.
//  Copyright © 2018 Cagri Sahan. All rights reserved.
//

public struct Page: Codable {
    public let property: TextProperty
    public let width: Int
    public let height: Int
    public var blocks: [Block]
    public let confidence: Float?
    
    public func getBlock(leftOf poly: BoundingPoly) -> Block? {
        var distance: Double = Double.greatestFiniteMagnitude
        var neighbor: Block? = nil
        
        for block in blocks {
            
            let poly2 = block.boundingBox
            let left = poly.minX > poly2.maxX
            let top = poly.minY > poly2.maxY
            let bottom = poly.maxY < poly2.minY
            
            if bottom && left {
                let bottomLeft = Vertex(x: poly.minX, y: poly.maxY)
                let topRight = Vertex(x: poly2.maxX, y: poly2.minY)
                
                if topRight.distance(from: bottomLeft) < distance {
                    distance = topRight.distance(from: bottomLeft)
                    neighbor = block
                }
                continue
            }
            
            if top && left {
                let topLeft = Vertex(x: poly.minX, y: poly.minY)
                let bottomRight = Vertex(x: poly2.maxX, y: poly2.maxY)
                
                if topLeft.distance(from: bottomRight) < distance {
                    distance = topLeft.distance(from: bottomRight)
                    neighbor = block
                }
                continue
            }
            
            if left {
                if Double(poly.minX - poly2.maxX) < distance {
                    distance = Double(poly.minX - poly2.maxX)
                    neighbor = block
                }
                continue
            }
        }
        return neighbor
    }
    
    public func getBlock(under poly: BoundingPoly) -> Block? {
        var distance: Double = Double.greatestFiniteMagnitude
        var neighbor: Block? = nil
        
        for block in blocks {
            
            let poly2 = block.boundingBox
            let left = poly.minX > poly2.maxX
            let right = poly.maxX < poly2.minX
            let bottom = poly.maxY < poly2.minY
            
            if bottom && left {
                let bottomLeft = Vertex(x: poly.minX, y: poly.maxY)
                let topRight = Vertex(x: poly2.maxX, y: poly2.minY)
                
                if topRight.distance(from: bottomLeft) < distance {
                    distance = topRight.distance(from: bottomLeft)
                    neighbor = block
                }
                continue
            }
            
            if bottom && right {
                let bottomRight = Vertex(x: poly.maxX, y: poly.maxY)
                let topLeft = Vertex(x: poly2.minX, y: poly2.minY)
                
                if topLeft.distance(from: bottomRight) < distance {
                    distance = topLeft.distance(from: bottomRight)
                    neighbor = block
                }
                continue
            }
            
            if bottom {
                if Double(poly2.minY - poly.maxY) < distance {
                    distance = Double(poly2.minY - poly.maxY)
                    neighbor = block
                }
                continue
            }
        }
        return neighbor
    }
    
    public func getBlock(rightOf poly: BoundingPoly) -> Block? {
        var distance: Double = Double.greatestFiniteMagnitude
        var neighbor: Block? = nil
        
        for block in blocks {
            
            let poly2 = block.boundingBox
            let right = poly.maxX < poly2.minX
            let top = poly.minY > poly2.maxY
            let bottom = poly.maxY < poly2.minY
            
            if bottom && right {
                let bottomRight = Vertex(x: poly.maxX, y: poly.maxY)
                let topLeft = Vertex(x: poly2.minX, y: poly2.minY)
                
                if topLeft.distance(from: bottomRight) < distance {
                    distance = topLeft.distance(from: bottomRight)
                    neighbor = block
                }
                continue
            }
            
            if top && right {
                let topRight = Vertex(x: poly.maxX, y: poly.minY)
                let bottomLeft = Vertex(x: poly2.minX, y: poly2.maxY)
                
                if topRight.distance(from: bottomLeft) < distance {
                    distance = topRight.distance(from: bottomLeft)
                    neighbor = block
                }
                continue
            }
            
            if right {
                if Double(poly2.minX - poly.maxX) < distance {
                    distance = Double(poly2.minX - poly.maxX)
                    neighbor = block
                }
                continue
            }
        }
        return neighbor
    }
    
    public func getBlock(above poly: BoundingPoly) -> Block? {
        var distance: Double = Double.greatestFiniteMagnitude
        var neighbor: Block? = nil
        
        for block in blocks {
            
            let poly2 = block.boundingBox
            let right = poly.maxX < poly2.minX
            let top = poly.minY > poly2.maxY
            let left = poly.minX > poly2.maxX
            
            if top && left {
                let topLeft = Vertex(x: poly.minX, y: poly.minY)
                let bottomRight = Vertex(x: poly2.maxX, y: poly2.maxY)
                
                if topLeft.distance(from: bottomRight) < distance {
                    distance = topLeft.distance(from: bottomRight)
                    neighbor = block
                }
                continue
            }
            
            if top && right {
                let topRight = Vertex(x: poly.maxX, y: poly.minY)
                let bottomLeft = Vertex(x: poly2.minX, y: poly2.maxY)
                
                if topRight.distance(from: bottomLeft) < distance {
                    distance = topRight.distance(from: bottomLeft)
                    neighbor = block
                }
                continue
            }
            
            if top {
                if Double(poly.minY - poly2.maxY) < distance {
                    distance = Double(poly.minY - poly2.maxY)
                    neighbor = block
                }
                continue
            }
        }
        return neighbor
    }
    
    public var topLeftBlock: Block? {
        var distance: Double = Double.greatestFiniteMagnitude
        var result: Block?
        let origin = Vertex(x: 0, y: 0)
        
        for block in blocks {
            let poly = block.boundingBox
            let topLeft = Vertex(x: poly.minX, y: poly.minY)
            
            if topLeft.distance(from: origin) < distance {
                distance = topLeft.distance(from: origin)
                result = block
            }
        }
        return result
    }
}
