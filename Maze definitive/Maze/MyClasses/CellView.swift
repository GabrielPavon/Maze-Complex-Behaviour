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
    var neighbourUp?
    var attendedUp = false

    var pathRight = false
    var neighbourRight?
    var attendedRight = false

    var pathDown = false
    var neighbourDown?
    var attendedDown = false

    var pathLeft = false
    var neighbourLeft?
    var attendedLeft = false   
    
    //override func draw(_ rect: CGRect) {
     //   <#code#>
    //}
    
    func assignNeighbours (_ subViews: <CellView>) {

        for view in subViews {
            let viewX = view.frame.origin.x
            let viewY = view.frame.origin.y
        
            if view.type == "corridor" { continue }
               

            if self.frame.origin.x == viewX && self.frame.origin.y != viewY {
                if self.pathUp {
                    if neighbourUp == nil {
                        neighbourUp = view.id
                        var neighbourY = viewY
                    } else if viewY > neighbourY && viewY < self.frame.origin.y {
                        neighbourUp = view.id
                        neighbourY = viewY
                    }                         
                } 
                if self.pathDown {
                    if neighbourDown == nil {
                        neighbourDown = view.id
                        var neighbourY = viewY
                    } else if viewY < neighbourY && viewY > self.frame.origin.y  {
                        neighbourDown = view.id
                        neighbourY = viewY
                    } 
                }
            } else if self.frame.origin.x != viewX && self.frame.origin.y == viewY {
                if self.pathRight {
                    if neighbourRight == nil {
                        neighbourRight = view.id
                        var neighbourX = viewX
                    } else if viewX < neighbourX && viewX > self.frame.origin.x {
                        neighbourRight = view.id
                        neighbourX = viewX
                    }                         
                } 
                if self.pathLeft {
                    if neighbourLeft == nil {
                        neighbourLeft = view.id
                        var neighbourX = viewX
                    } else if viewX > neighbourX && viewX < self.frame.origin.x {
                        neighbourLeft = view.id
                        neighbourX = viewX
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
