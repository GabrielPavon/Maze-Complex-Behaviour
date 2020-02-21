//
//  ViewController.swift
//  mazev3
//
//  Created by G. Pavon Barrero on 07/02/2020.
//  Copyright © 2020 G. Pavon Barrero. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MazeViewDataSource {
    
    static let MAZE_SIDE = 5
    
    @IBOutlet weak var mazeView: MazeView!
    
    var maze = Maze(withSize: MAZE_SIDE)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mazeView.dataSource = self
        mazeView.setNeedsDisplay()
    }
    
    
    @IBAction func handlerPanGesture(_ sender: UIPanGestureRecognizer) {
        let p = sender.translation(in: sender.view)
        let delta: CGFloat = 15  // Sensibilidad - Aumentar para que sea mas lento
        print("*", p.x, p.y)
        
        if p.x > delta {
            maze.movePlayer(maze.computer, to: maze.computer.getPos().moved(columns: 2))
            sender.setTranslation(CGPoint.zero, in: sender.view)
            mazeView.setNeedsDisplay()
        } else if p.x < -delta {
            maze.movePlayer(maze.computer, to: maze.computer.getPos().moved(columns: -2))
            sender.setTranslation(CGPoint.zero, in: sender.view)
            mazeView.setNeedsDisplay()
        } else if p.y > delta {
            maze.movePlayer(maze.computer, to: maze.computer.getPos().moved(rows: 2))
            sender.setTranslation(CGPoint.zero, in: sender.view)
            mazeView.setNeedsDisplay()
        } else if p.y < -delta {
            maze.movePlayer(maze.computer, to: maze.computer.getPos().moved(rows: -2))
            sender.setTranslation(CGPoint.zero, in: sender.view)
            mazeView.setNeedsDisplay()
        }
        
        checkIfWin()
        
    }
    
    @IBAction func handlerSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        
        switch sender.direction {
        case .down:
            maze.movePlayer(maze.player, to: maze.player.getPos().moved(rows:2))
        case .left:
            maze.movePlayer(maze.player, to: maze.player.getPos().moved(columns: -2))
        case .up:
            maze.movePlayer(maze.player, to: maze.player.getPos().moved(rows: -2))
        case .right:
            maze.movePlayer(maze.player, to: maze.player.getPos().moved(columns: 2))
        default:
            print("Swipe None")
        }
        
        mazeView.setNeedsDisplay()
        
        checkIfWin()
    }
    
    @IBAction func shuffle(_ sender: UIButton) {
        newMaze()
    }
    
    func newMaze() {
        maze = Maze(withSize: ViewController.MAZE_SIDE)
        
        mazeView.setNeedsDisplay()
    }
    
    func checkIfWin() {
        
        if maze.player.getPos() == maze.finishPosition {
            
            performSegue(withIdentifier: "Show Win VC", sender: self)
            newMaze()
        } else if maze.computer.getPos() == maze.finishPosition {
            performSegue(withIdentifier: "Show Lose VC", sender: self)
            newMaze()
        }
        
    }
    
    // MARK: - MazeView DataSource
    
    func numberOfRowsFor(_ mazeView: MazeView) -> Int {
        return maze.size
    }
    
    func numberOfColumnsFor(_ mazeView: MazeView) -> Int {
        return maze.size
    }
    
    func isOpenCellFor(_ mazeView: MazeView, at position: Position) -> Bool {
        return !maze[position]
    }
    
    func startCellFor(_ mazeView: MazeView) -> Position {
        return maze.startPosition
    }
    
    func finishCellFor(_ mazeView: MazeView) -> Position {
        return maze.finishPosition
    }
    
    func playerTrajectoryFor(_ mazeView: MazeView) -> Trajectory {
        return maze.player.route
    }
    
    func computerTrajectoryFor(_ mazeView: MazeView) -> Trajectory {
        return maze.computer.route
    }
}

