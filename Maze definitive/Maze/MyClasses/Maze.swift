//
//  Maze.swift
//  Maze v1
//
//  Created by G. Pavon Barrero on 07/02/2020.
//  Copyright © 2020 G. Pavon Barrero. All rights reserved.
//

import Foundation

class Maze {
    
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
    
    // Returns wether that position is a wall or not
    private(set) subscript(_ row: Int, _ column:Int) -> Bool {
        get { return walls[row][column] }
        set { walls[row][column] = newValue }
    }
    
    private(set) subscript(_ position: Position) -> Bool {
        get { return walls[position.row][position.column] }
        set { walls[position.row][position.column] = newValue }
    }
    
    
    func movePlayer (_ player: Player, to destine: Position ) {
        if inBounds(destine),!self[destine] {
            player.add(destine)
        } else {
            print("Invalid Movement. OOB or Wall")
        }
    }
    
    func inBounds(_ pos: Position ) -> Bool {
        return pos.row < size && pos.row >= 0 && pos.column < size && pos.column >= 0
    }
       
    
    private func generateWalls() {
         
        // Set of the visited positions. Used for the maze generation
        var visited = Set<Position>()
        
        var prevPos = Position.zero
        var newPos = Position.zero
        
        let positionsToVisit = Int(pow((Double(size)+1)/2, 2))
        while visited.count < positionsToVisit {
            if !visited.contains(newPos) {
                visited.insert(newPos)
                self[newPos] = false
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
