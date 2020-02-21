//
//  Player.swift
//  Maze v6
//
//  Created by G. Pavon Barrero on 11/02/2020.
//  Copyright © 2020 G. Pavon Barrero. All rights reserved.
//

import Foundation

class Player {
    
    var route: Trajectory = [Position.zero]
    
    func add(_ pos: Position) {
        if route.count < 2 {
            route.append(pos)
        } else if route[route.count-2] == pos {
            route.removeLast()
        } else {
            route.append(pos)
        }
    }
    
    // Si route no esta vacio, entonces devuelve su ultima posicion.
    // Si route esta vacio, entonces devuelve (0,0).
    func getPos() -> Position {
        return route.last ?? Position.zero
    }
}
