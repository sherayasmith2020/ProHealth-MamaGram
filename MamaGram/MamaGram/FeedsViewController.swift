//
//  FeedsViewController.swift
//  MamaGram
//
//  Created by reu2 on 6/22/18.
//  Copyright © 2018 reu. All rights reserved.
//

import UIKit

class FeedsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let feedNames = ["Facebook", "Twitter", "Instagram"]
    private let status = ["Not Connected", "Not Connected", "Not Connected"]
    private let photoArr = [UIImage(named: "FBLogo"), UIImage(named: "TwitterLogo"), UIImage(named: "InstagramLogo")]
    let identifier = "FeedsIdentifier"
    let segueIdentifiers = ["A", "B", "C"]
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(FeedsCell.self, forCellReuseIdentifier: identifier)
        let xib = UINib(nibName: "FeedsCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: identifier)
        tableView.rowHeight = 65
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableViewHeightConstraint.constant = tableView.contentSize.height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! FeedsCell
        //let rowData = feedList[indexPath.row]
        cell.nameLabel.text = feedNames[indexPath.row]
        cell.subtitleLabel.text = status[indexPath.row]
        cell.photo.image = photoArr[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueIdentifiers[indexPath.row], sender: self)
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
