//
//  PreviewViewController.swift
//  MamaGram
//
//  Created by Smith, Sheraya on 2/5/19.
//  Copyright © 2019 reu. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    var image: UIImage!
    
    @IBOutlet weak var photo: UIImageView!
    @IBAction func cancelButton_TouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
  
    @IBAction func saveButton_TouchUpInside(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = self.image
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
