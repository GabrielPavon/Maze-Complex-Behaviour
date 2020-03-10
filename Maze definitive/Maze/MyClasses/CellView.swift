//
//  CellView.swift
//  Maze
//
//  Created by G. Pavon Barrero on 10/03/2020.
//  Copyright © 2020 G. Pavon Barrero. All rights reserved.
//

import UIKit


class CellView: UIView {
    
    
    
    
    // Like a clock starting at 12
    // Up Right Down Left
    var pathUP = false
    var pathRight = false
    var pathDown = false
    var pathLeft = false
    
    //override func draw(_ rect: CGRect) {
     //   <#code#>
    //}
    
    func drawOpenings(_ cellsize: CGFloat){
        let path = UIBezierPath()
        path.move(to: self.center)
        if pathUP {
            path.addLine(to: self.center.moved(dx: 0, dy: -cellsize))
            path.addLine(to: self.center)
        }
        if pathRight {
            path.addLine(to: self.center.moved(dx: cellsize, dy: 0))
            path.addLine(to: self.center)
        }
        if pathDown {
            path.addLine(to: self.center.moved(dx: 0, dy: cellsize))
            path.addLine(to: self.center)
        }
        if pathLeft{
            path.addLine(to: self.center.moved(dx: -cellsize, dy: 0))
            path.addLine(to: self.center)
        }
        
        path.lineWidth = 2
        UIColor.yellow.setStroke()
        path.stroke()
    }
    
}
