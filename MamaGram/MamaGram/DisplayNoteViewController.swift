//
//  DisplayNoteViewController.swift
//  MamaGram
//
//  Created by reu2 on 7/2/18.
//  Copyright © 2018 reu. All rights reserved.
//

import UIKit

class DisplayNoteViewController: UIViewController {
    
    //MARK: - Properties
    
    var note: Note?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let note = note {
            titleTextField.text = note.title
            contentTextView.text = note.content
        } else {
            titleTextField.text = ""
            contentTextView.text = ""
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "save" where note != nil:
            note?.title = titleTextField.text ?? ""
            note?.content = contentTextView.text ?? ""
            note?.modificationTime = Date()
            //TODO: make a call to PUT method in Http
            CoreDataHelper.saveNote()
            
        case "save" where note == nil:
            let note = CoreDataHelper.newNote()
            note.title = titleTextField.text ?? ""
            note.content = contentTextView.text ?? ""
            note.modificationTime = Date()
            
            CoreDataHelper.saveNote()
            let httpNote = ["type": "note", "title": note.title, "body": note.content, "date created": note.modificationTime?.convertToString()]
            let newHttp = Http()
            newHttp.makePostCall(body: httpNote)
            
        case "cancel":
            print("cancel bar button item tapped")
            
        default:
            print("unexpected segue identifier")
        }
    }


}
