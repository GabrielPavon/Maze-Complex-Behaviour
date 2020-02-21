//
//  Cell.swift
//  Maze v6
//
//  Created by G. Pavon Barrero on 11/02/2020.
//  Copyright © 2020 G. Pavon Barrero. All rights reserved.
//

import UIKit

protocol MazeViewDataSource: class {
    
    /// Preguntar al Data Source cuantas filas tiene el laberinto a pintar.
    func numberOfRowsFor(_ mazeView: MazeView) -> Int
    
    /// Preguntar al Data Source cuantas columnas tiene el laberinto a pintar.
    func numberOfColumnsFor(_ mazeView: MazeView) -> Int
    
    /// Preguntar al Data Source si una celda del tablero es abierta.
    func isOpenCellFor(_ mazeView: MazeView, at position: Position) -> Bool
    
    /// Preguntar al Data Source por la posicion de la celda de comienzo.
    func startCellFor(_ mazeView: MazeView) -> Position
    
    /// Preguntar al Data Source por la posicion de la celda de finalizacion.
    func finishCellFor(_ mazeView: MazeView) -> Position
    
    // TODO: Implementar Ruta completa no solo ultima posicion
    /// Preguntar al Data Source la trayectoria por la que ha pasado el jugador.
    func playerTrajectoryFor(_ mazeView: MazeView) -> Trajectory
  
    /// Preguntar al Data Source la trayectoria por la que ha pasado el computer.
    func computerTrajectoryFor(_ mazeView: MazeView) -> Trajectory
}

@IBDesignable
class MazeView: UIView {
        
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
    // Fakes usados para pintar el maze en el storyboard
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
    
    override func draw(_ rect: CGRect) {
        calculateCellSize()
        drawBackground()
        drawCells()
        drawPlayers()
    }
    
    // Pinta a los dos jugadores
    private func drawPlayers() {
        drawTrajectory(dataSource.playerTrajectoryFor(self), color: playerColor, offset: 1)
        drawTrajectory(dataSource.computerTrajectoryFor(self), color: computerColor, offset: -1)
    }
       
    // Pinta una trayectoria con el color y el offset dado
    private func drawTrajectory(_ trajectory: Trajectory, color: UIColor, offset: CGFloat) {
     
        // Oval size
        var size = cellSize * 0.2

        let path = UIBezierPath()
        
        // Desplazamiento desde origen de celda hasta donde se pinta la trayectoria
        let mv = cellSize/2 + size/2*offset

        // La linea:
        let pos0 = trajectory.first ?? Position.zero
        path.move(to: position2CGPoint(pos0).moved(dx: mv, dy: mv))
        for pos in trajectory {
            path.addLine(to: position2CGPoint(pos).moved(dx: mv, dy: mv))
        }
        
        // Los puntos:
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
    
    // Pinta el fondo
    private func drawBackground() {
        
        // Tamaño del maze
        let rows = dataSource.numberOfRowsFor(self)
        let columns = dataSource.numberOfColumnsFor(self)
        
        // Rectangulo de la zona de la view donde pintare en puntos.
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
    
    
    // Pinta las celdas del maze
    private func drawCells() {
        
        // Tamaño del maze
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
    
    // Dibuja la celda de la posicion indicada.
    private func drawCellAt(_ pos: Position, with color: UIColor) {
        let path = UIBezierPath(rect: CGRect(origin: position2CGPoint(pos),
                                             size: CGSize(width: cellSize, height: cellSize)))
        color.setFill()
        path.fill()
    }
    
    
    //-------------
    // Conversiones de coordenadas de la cell en el maze, a coordenadas en puntos.
    // La coordenada de una cell es su fila y columna en el maze.
    // La coordenada en puntos son los pixels que se usan para pintar la cell en la UIView.
    //
    // El area donde se dibuja el maze es la mayor posible manteniendo una relacion de
    // aspecto que hace que los rectangulos de las cells sean cuadrados y ajustando a los bordes
    // de la UIView.
    //-------------
    
    // Cuantos puntos ocupa una celda
    private var cellSize: CGFloat = 0
    
    // Margenes alrededor de la zona de dibujo.
    private var horizontalMargin: CGFloat = 0
    private var verticalMargin: CGFloat = 0
    
    // Actualiza el valor de cellSize
    private func calculateCellSize() {
        
        // Tamaño del tablero
        let rows = dataSource.numberOfRowsFor(self)
        let columns = dataSource.numberOfColumnsFor(self)
        
        // Tamaño en puntos de la zona de la view donde voy a dibujar.
        let width = bounds.size.width - 2*CGFloat(lineWidth)
        let height = bounds.size.height - 2*CGFloat(lineWidth)
        
        // Tamaño de una celda en puntos
        let cellWidth = width / CGFloat(columns)
        let cellHeight = height / CGFloat(rows)
        
        cellSize = min(cellWidth,cellHeight)
        
        horizontalMargin = (width - cellSize * CGFloat(columns) + 2*CGFloat(lineWidth)) / 2
        verticalMargin = (height - cellSize * CGFloat(rows) + 2*CGFloat(lineWidth)) / 2
    }
    
    
    // Calcula las coordenadas (x,y) donde empieza la posicion dada.
    private func position2CGPoint(_ pos: Position) -> CGPoint {
        let x = CGFloat(pos.column) * cellSize + horizontalMargin
        let y = CGFloat(pos.row) * cellSize + verticalMargin
        return CGPoint(x:x, y:y)
    }
}

// Añadir nuevos metodos al tipo CGPoint
extension CGPoint {
    
    func moved(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
