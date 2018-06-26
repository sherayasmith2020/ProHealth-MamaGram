//
//  FeedsCell.swift
//  MamaGram
//
//  Created by reu2 on 6/26/18.
//  Copyright © 2018 reu. All rights reserved.
//

import UIKit

class FeedsCell: UITableViewCell {
   // var name: String = ""
   // var subtitle: String = ""
    // var thing: UIImageView?
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var photo: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
