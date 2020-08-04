//
//  Position.swift
//  Maze v6
//
//  Created by G. Pavon Barrero on 20/02/2020.
//  Copyright © 2020 G. Pavon Barrero. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {

    @IBOutlet weak var infoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let info = """
Maze Race is a classic maze game with the twist of you racing against the computer.


The objective is to reach the finish tile (orange) first, located at the bottom right. Both the player and the computer start at the most upper-left tile (green).


For input, the player must swipe in the direction they want to move to.


The difficulty can be set through the size of the maze in the main screen.


Enjoy the game and good luck!
"""
      
        infoTextView.text = info
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
