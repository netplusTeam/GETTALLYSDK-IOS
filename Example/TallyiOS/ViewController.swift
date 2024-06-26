//
//  ViewController.swift
//  TallyiOS
//
//  Created by 50696559 on 04/30/2024.
//  Copyright (c) 2024 50696559. All rights reserved.
//

import UIKit
import TallyiOS

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openFromExample(){
        let param = TallyParam(userId: "userId", userFullName: "userFullName", userEmail: "userEmail@gmail.com", userPhone: "userPhone", bankName: "bankName", staging: true, apiKey: "apiKey", activationKey: "activationKey")
        param.openTallySdk(controller: self)
    }

}

