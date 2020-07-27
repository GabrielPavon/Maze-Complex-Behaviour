//
//  CellView.swift
//  Maze
//
//  Created by G. Pavon Barrero on 10/03/2020.
//  Copyright © 2020 G. Pavon Barrero. All rights reserved.
//

import UIKit


class CellView: UIView {
    var id = "-1"
    var type = "none"
    // Like a clock starting at 12
    // Up Right Down Left
    var pathUp = false
    var neighbourUp: String?

    var pathRight = false
    var neighbourRight: String?

    var pathDown = false
    var neighbourDown: String?

    var pathLeft = false
    var neighbourLeft: String? 
    
    //override func draw(_ rect: CGRect) {
     //   <#code#>
    //}
    
    func assignNeighbours (_ subViews: [UIView]) {
        var neighbourY1: CGFloat = 0.0
        var neighbourY2: CGFloat = 0.0
        var neighbourX1: CGFloat = 0.0
        var neighbourX2: CGFloat = 0.0
        
        for uiView in subViews {
            if let view = uiView as? CellView {
                let viewX = view.frame.origin.x
                let viewY = view.frame.origin.y
                
            
                if view.type == "corridor" || view.type == "bottleneck" { continue }
                   
                if self.frame.origin.x == viewX && self.frame.origin.y != viewY {
                    if self.pathUp {
                        if neighbourUp == nil && viewY < self.frame.origin.y {
                            neighbourUp = view.id
                            neighbourY1 = viewY
                        } else if viewY > neighbourY1 && viewY < self.frame.origin.y {
                            neighbourUp = view.id
                            neighbourY1 = viewY
                        }
                    }
                    if self.pathDown {
                        if neighbourDown == nil && viewY > self.frame.origin.y {
                            neighbourDown = view.id
                            neighbourY2 = viewY
                        } else if viewY < neighbourY2 && viewY > self.frame.origin.y  {
                            neighbourDown = view.id
                            neighbourY2 = viewY
                        }
                    }
                } else if self.frame.origin.x != viewX && self.frame.origin.y == viewY {
                    if self.pathRight {
                        if neighbourRight == nil && viewX > self.frame.origin.x {
                            neighbourRight = view.id
                            neighbourX1 = viewX
                        } else if viewX < neighbourX1 && viewX > self.frame.origin.x {
                            neighbourRight = view.id
                            neighbourX1 = viewX
                        }
                    }
                    if self.pathLeft {
                        if neighbourLeft == nil && viewX < self.frame.origin.x {
                            neighbourLeft = view.id
                            neighbourX2 = viewX
                        } else if viewX > neighbourX2 && viewX < self.frame.origin.x {
                            neighbourLeft = view.id
                            neighbourX2 = viewX
                        }
                    }
                }
            }
        }
    }

    func drawOpenings(_ cellsize: CGFloat){
        let path = UIBezierPath()
        path.move(to: self.center)
        if neighbourUp != nil {
            path.addLine(to: self.center.moved(dx: 0, dy: -cellsize))
            path.addLine(to: self.center)
        }
        if neighbourRight != nil {
            path.addLine(to: self.center.moved(dx: cellsize, dy: 0))
            path.addLine(to: self.center)
        }
        if neighbourDown != nil {
            path.addLine(to: self.center.moved(dx: 0, dy: cellsize))
            path.addLine(to: self.center)
        }
        if neighbourLeft != nil {
            path.addLine(to: self.center.moved(dx: -cellsize, dy: 0))
            path.addLine(to: self.center)
        }
        
        path.lineWidth = 2
        UIColor.yellow.setStroke()
        path.stroke()
    }
    
    
    
}
