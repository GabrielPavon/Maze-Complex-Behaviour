//
//  Cell.swift
//  Maze v6
//
//  Created by G. Pavon Barrero on 11/02/2020.
//  Copyright © 2020 G. Pavon Barrero. All rights reserved.
//

import UIKit

protocol MazeViewDataSource: class {
    
    /// Ask DataSource for the number of rows
    func numberOfRowsFor(_ mazeView: MazeView) -> Int
    
    /// Asks DataSource for the number of columns
    func numberOfColumnsFor(_ mazeView: MazeView) -> Int
    
    /// Asks DataSource if the cell at specified position is Open
    func isOpenCellFor(_ mazeView: MazeView, at position: Position) -> Bool
    
    /// Asks DataSource at which position de start cell is
    func startCellFor(_ mazeView: MazeView) -> Position
    
    /// Asks DataSource at which position de finish cell is
    func finishCellFor(_ mazeView: MazeView) -> Position
    
    /// Asks DataSource for the trajectory of the player
    func playerTrajectoryFor(_ mazeView: MazeView) -> Trajectory
  
    /// Asks DataSource for the trajectory of the computer
    func computerTrajectoryFor(_ mazeView: MazeView) -> Trajectory
}

@IBDesignable
class MazeView: ACTRWindowView {
        
    @IBInspectable
    var openColor: UIColor! = UIColor.gray
    
    @IBInspectable
    var closedColor: UIColor! = UIColor.black
    
    @IBInspectable
    var startColor: UIColor! = UIColor.green
    
    @IBInspectable
    var finishColor: UIColor! = UIColor.blue
    
    @IBInspectable
    var borderColor: UIColor! = UIColor.red
    
    @IBInspectable
    var playerColor: UIColor! = UIColor.yellow
   
    @IBInspectable
    var computerColor: UIColor! = UIColor.cyan
      
    @IBInspectable
    var lineWidth: Float = 5
    
    weak var dataSource: MazeViewDataSource!

    #if TARGET_INTERFACE_BUILDER
    // Fakes data used only for the interface builder
    var fakeDataSource = FakeDataSource()
    
    class FakeDataSource: MazeViewDataSource {
        func numberOfRowsFor(_ mazeView: MazeView) -> Int { return 6}
        func numberOfColumnsFor(_ mazeView: MazeView) -> Int { return 6}
        func isOpenCellFor(_ mazeView: MazeView, at position: Position) -> Bool {return true}
        func startCellFor(_ mazeView: MazeView) -> Position { return Position.zero}
        func finishCellFor(_ mazeView: MazeView) -> Position { return Position(row:5,column:5)}
        func playerTrajectoryFor(_ mazeView: MazeView) -> Trajectory {return []}
        func computerTrajectoryFor(_ mazeView: MazeView) -> Trajectory {return []}
    }
    
    override func prepareForInterfaceBuilder() {
        dataSource = fakeDataSource
    }
    #endif
    
    // Set to false to check the visual objects that Act/R is looking at.
    @IBInspectable
    var hiddenActRViews = true
    
    override func draw(_ rect: CGRect) {
        for view in self.subviews {
            view.removeFromSuperview()
        }

        calculateCellSize()
        drawBackground()
        drawCells() // Also draws the necessary sub-UIViews for Act-R
        drawPlayers()

        for view in self.subviews {
            if let cellView = view as? CellView {
                cellView.assignNeighbours(self.subviews)
            }
        }
    }
    
    // Draws both players
    private func drawPlayers() {
        drawTrajectory(dataSource.playerTrajectoryFor(self), color: playerColor, offset: 1)
        drawTrajectory(dataSource.computerTrajectoryFor(self), color: computerColor, offset: -1)
    }
       
    // Draws the trajectory with the given offset
    private func drawTrajectory(_ trajectory: Trajectory, color: UIColor, offset: CGFloat) {
     
        // Oval size
        var size = cellSize * 0.2

        let path = UIBezierPath()
        
        // Delta movement
        let mv = cellSize/2 + size/2*offset

        // The line of the trajectory
        let pos0 = trajectory.first ?? Position.zero
        path.move(to: position2CGPoint(pos0).moved(dx: mv, dy: mv))
        for pos in trajectory {
            path.addLine(to: position2CGPoint(pos).moved(dx: mv, dy: mv))
        }
        
        // The dots of the trajectory
        for pos in trajectory {
            if pos == trajectory.last! { size *= 2 }
            let p = position2CGPoint(pos).moved(dx: mv-size/2, dy: mv-size/2)
            let pathOval = UIBezierPath(ovalIn: CGRect(origin: p, size: CGSize(width: size, height: size)))
            path.append(pathOval)
        }
        
        path.lineWidth = 1
        color.setStroke()
        path.stroke()
    }
    
    // Draws background
    private func drawBackground() {
        
        // Maze size
        let rows = dataSource.numberOfRowsFor(self)
        let columns = dataSource.numberOfColumnsFor(self)
        
        // Rectangle determining the area to draw in
        let origin = position2CGPoint(Position.zero).moved(dx: CGFloat(-lineWidth/2), dy: CGFloat(-lineWidth/2))
        let size = CGSize(width: cellSize*CGFloat(columns) + CGFloat(lineWidth),
                          height: cellSize*CGFloat(rows) + CGFloat(lineWidth))
        let path = UIBezierPath(rect: CGRect(origin: origin, size: size))
            
        path.lineWidth = CGFloat(lineWidth)
        borderColor.setStroke()
        closedColor.setFill()
        path.fill()
        path.stroke()
    }
    
    
    // Draws Maze Cells
    private func drawCells() {
        
        // Maze Size
        let rows = dataSource.numberOfRowsFor(self)
        let columns = dataSource.numberOfColumnsFor(self)
        
        for r in 0..<rows {
            for c in 0..<columns {
                let p = Position(row: r, column:c)
                if dataSource.isOpenCellFor(self, at: p) {
                    drawCellAt(p, with: openColor)
                } else {
                    drawCellAt(p, with: closedColor)
                }
            }
        }
        
        drawCellAt(dataSource.startCellFor(self), with: startColor)
        drawCellAt(dataSource.finishCellFor(self), with: finishColor)
    }
    
    
    
    
    // Draws the cell at the indicated position
    // Crates the Act-R sub-UIviews used as input
    private func drawCellAt(_ pos: Position, with color: UIColor) {
        
        let path = UIBezierPath(rect: CGRect(origin: position2CGPoint(pos), size: CGSize(width: cellSize, height: cellSize)))
        color.setFill()
        path.fill()
        
        // Only draws the open cells (including start and finish)
        if color != closedColor {
            createCellView(pos, with: UIColor.purple)
        }
    }
    
    // Draws the necessary sub-UIviews for Act-R
    private func createCellView(_ pos: Position,with color:UIColor){
        
        let view = CellView()
        
        updateCellViewPaths(view, pos)
        
        view.id = pos.toId()

        view.frame = CGRect(origin: position2CGPoint(pos).moved(dx: cellSize*0.375, dy: cellSize*0.375), size: CGSize(width: cellSize/4, height: cellSize/4))
        view.backgroundColor = color
       
        // Troubleshooting -  Set to false above to see the Act-r sub-UIviews
        if hiddenActRViews {
            view.isHidden = true
        } else {
            view.isHidden = false
            view.drawOpenings(cellSize/4)
        }
        
        self.addSubview(view)
    }
    
    // checks and stores the adjacent paths
    // assign the type of cell it is (corridor, deadend, corner, intersection)
    private func updateCellViewPaths (_ view: CellView,_ pos:Position) {
        
        var n_openings = 0

        if pos.row > 0,dataSource.isOpenCellFor(self, at: pos.moved(rows: -1, columns: 0)) {
            view.pathUp = true
            n_openings += 1
        }
        
        if pos.column < dataSource.numberOfColumnsFor(self)-1,dataSource.isOpenCellFor(self, at: pos.moved(rows: 0, columns: 1)) {
            view.pathRight = true
            n_openings += 1
        }
        
        if pos.row < dataSource.numberOfRowsFor(self)-1,dataSource.isOpenCellFor(self, at: pos.moved(rows: 1, columns: 0)) {
            view.pathDown = true
            n_openings += 1
        }
        
        if pos.column > 0,dataSource.isOpenCellFor(self, at: pos.moved(rows: 0, columns: -1)) {
            view.pathLeft = true
            n_openings += 1
        }

        // Assign the type
        // TODO: Assign an enum to the types?
        if n_openings == 1 {
            view.type = "deadend"
        } else if n_openings == 2 {
            if (view.pathUp && view.pathDown)||(view.pathLeft && view.pathRight) {
                    view.type = "corridor"
                } else {
                    view.type = "corner"
                }
        } else if n_openings > 2 {
            view.type = "intersection"
        } else {
            view.type = "bad call: no openings?"
        }
        
        if pos == dataSource.startCellFor(self) {
            view.type = "start"
        } else if pos == dataSource.finishCellFor(self) {
            view.type = "finish"
        }
    }
    
    
    //------------
    //Conversion from cell coordinates to pixel coordinates
    //Cell coordinates are based on row & column
    //Pixel coordinates are what UI view uses to draw the cells
    //
    //The are where the maze is drawn is the biggest possible, while maintining a aspect ratio that makes 
    //cells be squared and being adjusted to the UIView edges
    //-------------
    
    // Pixel length of a cell
    private var cellSize: CGFloat = 0
    
    // Margins surrounding the drawing (inside the UIView still)
    private var horizontalMargin: CGFloat = 0
    private var verticalMargin: CGFloat = 0
    
    // Updates cellSize
    private func calculateCellSize() {
        
        // Board size
        let rows = dataSource.numberOfRowsFor(self)
        let columns = dataSource.numberOfColumnsFor(self)
        
        // Size of the board in terms of pixels
        let width = bounds.size.width - 2*CGFloat(lineWidth)
        let height = bounds.size.height - 2*CGFloat(lineWidth)
        
        // Size of the cell in pixels
        let cellWidth = width / CGFloat(columns)
        let cellHeight = height / CGFloat(rows)
        
        cellSize = min(cellWidth,cellHeight)
        
        horizontalMargin = (width - cellSize * CGFloat(columns) + 2*CGFloat(lineWidth)) / 2
        verticalMargin = (height - cellSize * CGFloat(rows) + 2*CGFloat(lineWidth)) / 2
    }
    
    // Returns the coordinates (x,y) where a cell starts
    // i.e. translates from row column to pixel
    private func position2CGPoint(_ pos: Position) -> CGPoint {
        let x = CGFloat(pos.column) * cellSize + horizontalMargin
        let y = CGFloat(pos.row) * cellSize + verticalMargin
        return CGPoint(x:x, y:y)
    }
}

// Adding new method to CGPoint class
extension CGPoint {
    
    func moved(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
