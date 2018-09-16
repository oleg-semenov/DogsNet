//
//  ViewController.swift
//  Dogs
//
//  Created by Oleg Semenov on 9/16/18.
//  Copyright © 2018 Ole. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let model = mobilenet_1_0_224_dogs_1()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

