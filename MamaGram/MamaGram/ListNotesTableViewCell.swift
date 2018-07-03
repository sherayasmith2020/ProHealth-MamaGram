//
//  ListNotesTableViewCell.swift
//  MamaGram
//
//  Created by reu2 on 7/2/18.
//  Copyright © 2018 reu. All rights reserved.
//

import UIKit

class ListNotesTableViewCell: UITableViewCell {

    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteModificationTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
