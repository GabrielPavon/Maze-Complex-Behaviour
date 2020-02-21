//
//  Maze.swift
//  Maze v1
//
//  Created by G. Pavon Barrero on 07/02/2020.
//  Copyright © 2020 G. Pavon Barrero. All rights reserved.
//

import Foundation

class Maze {
    
    // NOTA PARA GABI:
    // private(set) significa que no pueden cambiar su valor desde fuera de este fichero.
    // Pero desde fuera si se puede leer el valor
    private(set) var size = 0
    
    private(set) var walls: [[Bool]]
    
    private(set) var startPosition: Position!
    private(set) var finishPosition: Position!

    private(set) var computer = Player()
    private(set) var player = Player()
    
    // Assigns the dimensions to the maze
    init(withSize size : Int) {
        self.size = size % 2 == 1 ? size : size+1  // Para que sea impar
        walls = Array(repeating: Array(repeating: true, count: size), count: size)

        startPosition = Position.zero
        finishPosition = Position(row: size-1, column: size-1)
        
        generateWalls()
    }
    
    // NOTA PARA GABI:
    // Estos subscript son para leer y para asignar un nuevo valor.
    
    // es muro esa posicion?
    private(set) subscript(_ row: Int, _ column:Int) -> Bool {
        get { return walls[row][column] }
        set { walls[row][column] = newValue }
    }
    
    private(set) subscript(_ position: Position) -> Bool {
        get { return walls[position.row][position.column] }
        set { walls[position.row][position.column] = newValue }
    }
    
    func movePlayer (_ player: Player, to destine: Position ) {
        if inBounds(destine) {
            let intermediatePos = player.getPos() +- destine
            if !self[intermediatePos] {
                player.add(intermediatePos)
                player.add(destine)
                print("Moving to: \(destine)")
            } else {
                print("There is a wall there! \(intermediatePos)")
            }
        } else {
            print("Invalid Movement, Out of Bounds!")
        }
    }
    
    func inBounds(_ pos: Position ) -> Bool {
        return pos.row <= size && pos.row >= 0 && pos.column <= size && pos.column >= 0
    }
    
    func moveRight(forPlayer player: Player) {
        
//        let playerPos = player.getPos()
//
//        if playerX + 2 > side {
//            print("Out of Bounds!")
//        } else if !walls[playerX+1][playerY] {
//            player.coordinates.append((playerX+2,playerY))
//        } else {
//            print("Invalid movement Right!")
//        }
    }
    
    
    private func generateWalls() {
         
        // Conjunto (Set de Positions) con las posiciones visitadas
        var visited = Set<Position>()
        
        var prevPos = Position.zero
        var newPos = Position.zero
        
        // TODO: Change the 36 for the proper number calculating number of cells
        let positionsToVisit = Int(pow((Double(size)+1)/2, 2))
        while visited.count < positionsToVisit {
            if !visited.contains(newPos) {
                visited.insert(newPos)
                self[newPos] = false   // NOTA PARA GABI: self es para usar los subscripts
                self[prevPos +- newPos] = false
            }
            prevPos = newPos
            newPos = randomNeighbourOf(newPos)
        }
    }
    
    private func randomNeighbourOf(_ pos: Position) -> Position {
        
        let rand = arc4random_uniform(4)
        
        var newPos = pos;
        if rand == 0 {
            newPos = pos.moved(rows:2)
        } else if rand == 1 {
            newPos = pos.moved(rows:-2)
        } else if rand == 2 {
            newPos = pos.moved(columns:2)
        } else if rand == 3 {
            newPos = pos.moved(columns:-2)
        } 
        return inBounds(newPos) ? newPos : pos
    }
    
}
