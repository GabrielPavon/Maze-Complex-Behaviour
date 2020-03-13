//
//  ViewController.swift
//  mazev3
//
//  Created by G. Pavon Barrero on 07/02/2020.
//  Copyright © 2020 G. Pavon Barrero. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MazeViewDataSource {
    let model = Global.model
    static let MAZE_SIDE = 9
    
    @IBOutlet weak var mazeView: MazeView!
    
    var maze = Maze(withSize: MAZE_SIDE)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mazeView.dataSource = self
        //mazeView.setNeedsDisplay()
        
        mazeView.draw(mazeView.frame)
        
        if model.loadedModel != "maze" {
            model.loadedModel = "maze"
            model.loadModel(fileName: "maze")
            model.reset()
            model.visual.updateVisicon(items: mazeView.getVisicon())
            model.visual.setWindow(mazeView)
        }
        
        print("Setting listener for Action")
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.receiveAction), name: NSNotification.Name(rawValue: "Action"), object: nil)
        
        model.run()
    }
    
    @objc func receiveAction() {
        switch model.lastAction(slot: "cmd") {
        case "done":
            return
        case "move":
            switch model.lastAction(slot: "direction") {
                case "up":
                    maze.movePlayer(maze.computer, to: maze.computer.getPos().moved(rows: -1))
                case "right":
                    maze.movePlayer(maze.computer, to: maze.computer.getPos().moved(columns: 1))
                case "down":
                    maze.movePlayer(maze.computer, to: maze.computer.getPos().moved(rows:1))
                case "left":
                    maze.movePlayer(maze.computer, to: maze.computer.getPos().moved(columns: -1))
                default:
                    print("why")
            }
        default:
            print("why")
        }

        model.modifyLastAction(
            slot: "current",
            value: maze.computer.getPos().toId()
        )
        
        model.run()
    }
    

    
    @IBAction func handlerSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        
        switch sender.direction {
        case .up:
            maze.movePlayer(maze.player, to: maze.player.getPos().moved(rows: -1))
        case .right:
            maze.movePlayer(maze.player, to: maze.player.getPos().moved(columns: 1))
        case .down:
            maze.movePlayer(maze.player, to: maze.player.getPos().moved(rows:1))
        case .left:
            maze.movePlayer(maze.player, to: maze.player.getPos().moved(columns: -1))
        
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

