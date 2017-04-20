//
//  FirstVC.swift
//  MyLittleMonster
//
//  Created by Mohammad Hemani on 2/28/17.
//  Copyright © 2017 Mohammad Hemani. All rights reserved.
//

import UIKit

class FirstVC: UIViewController {

    @IBOutlet weak var monsterButton: UIButton!
    @IBOutlet weak var heroButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        monsterButton.setTitle("", for: UIControlState.normal)
        heroButton.setTitle("", for: UIControlState.normal)
    }

    @IBAction func playerTapped(sender: UIButton) {
        
        performSegue(withIdentifier: "StartGame", sender: sender.tag)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "StartGame" {
            
            let gameController = segue.destination as! GameController
            
            let buttonTag = sender as! Int
            
            gameController.petType = (buttonTag == 1 ? "monster" : "hero")
            
            gameController.imageToDisplay = UIImage(named: "bg\(buttonTag)")
        }
        
    }

}
