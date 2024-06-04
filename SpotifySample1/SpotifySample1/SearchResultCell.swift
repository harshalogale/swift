//
//  SearchResultCell.swift
//  SpotifySample1
//
//  Created by Harshal Ogale
//

import Foundation
import UIKit

class SearchResultCell: MGSwipeTableCell {
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var favIcon: UIImageView!
    
    var searchResultId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
