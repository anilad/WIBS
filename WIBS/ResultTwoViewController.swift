//
//  ResultTwoViewController.swift
//  WIBS
//
//  Created by Team-Uno on 1/19/18.
//  Copyright © 2018 Team-Uno. All rights reserved.
//

import UIKit

class ResultTwoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBackToOneButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToBrendan", sender: self)
    }
    
}
