//
//  QuakePropertyTableViewCell.swift
//  SampleQuake
//
//  Created by Harshal Ogale on 2/25/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

final class QuakePropertyTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
