//
//  HomeViewController.swift
//  MamaGram
//
//  Created by reu2 on 6/22/18.
//  Copyright © 2018 reu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let newHttp = Http()
        newHttp.makeGetCall()
        let newTodo: [String: Any] = ["title": "My First todo", "completed": false, "userId": 1]
        newHttp.makePostCall(body: newTodo)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
