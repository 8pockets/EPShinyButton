//
//  ViewController.swift
//  EPShinyButtonDEMO
//
//  Created by 8pockets on 2017/11/27.
//  Copyright © 2017年 8pockets. All rights reserved.
//
import UIKit
//import EPShinyButton

class ViewController: UIViewController {

    @IBOutlet weak var button: EPShinyButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        button.touchUpInside {
            print("Hello World")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
