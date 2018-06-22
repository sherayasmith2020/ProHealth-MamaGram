//
//  ViewController.swift
//  MamaGram
//
//  Created by reu2 on 6/14/18.
//  Copyright © 2018 reu. All rights reserved.
//

import UIKit
import FacebookLogin


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        
        view.addSubview(loginButton)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

