//
//  ViewController.swift
//  DQModoki1
//
//  Created by hiroto takashima on 2016/11/03.
//  Copyright © 2016年 hiroto takashima. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bkFImage: UIImageView!
    
    var soundManager = SEManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.sendSubviewToBack(bkFImage)
        
        soundManager.sePlay("opening.mp3")

    }
    
    @IBAction func startGame(sender: AnyObject) {
        soundManager.seStop()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

