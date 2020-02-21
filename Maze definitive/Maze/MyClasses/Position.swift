//
//  Position.swift
//  Maze v6
//
//  Created by G. Pavon Barrero on 11/02/2020.
//  Copyright © 2020 G. Pavon Barrero. All rights reserved.
//

import Foundation


typealias Trajectory = [Position]


// NOTA PARA GABI:
// Me he inventado un operador nuevo para calcular la posicion intermedia
infix operator +- : AdditionPrecedence

struct Position: Hashable {
    
    var row: Int
    var column: Int

    static let zero = Position(row: 0, column: 0)
    
    static func == (p1: Position, p2: Position) -> Bool {
        return (p1.row == p2.row) && (p1.column == p2.column)
    }

    static func != (p1: Position, p2: Position) -> Bool {
        return !(p1 == p2)
    }

    static func +(p1: Position, p2: Position) -> Position {
        return Position(row: p1.row+p2.row, column: p1.column+p2.column)
    }
      
    // El operador +- devuelve la posicion intermedia entre p1 y p2.
    static func +-(p1: Position, p2: Position) -> Position {
        return Position(row: (p1.row+p2.row)/2, column: (p1.column+p2.column)/2)
    }
    
    // Devuelve una nueva posicion desplazada varias filas y/o columnas
    func moved(rows: Int = 0, columns: Int = 0) -> Position {
        return Position(row: row+rows, column: column+columns)
    }
    
}
