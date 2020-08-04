//
//  Position.swift
//  Maze v6
//
//  Created by G. Pavon Barrero on 20/02/2020.
//  Copyright © 2020 G. Pavon Barrero. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let smallSize = 7
    let mediumSize = 15
    let bigSize = 25
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    @IBAction func changeSize(_ sender: UISegmentedControl) {
        
        switch (sender.selectedSegmentIndex) {
        case 0:
            ViewController.MAZE_SIDE = smallSize
        case 1:
            ViewController.MAZE_SIDE = mediumSize
        case 2:
            ViewController.MAZE_SIDE = bigSize
        default:
            print("Error, no size selected")
        }
        
    }
    
}
