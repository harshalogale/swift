//
//  QuakeTableViewCell.swift
//  SampleQuake
//
//  Created by Harshal Ogale on 2/23/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

final class QuakeTableViewCell: UITableViewCell {
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var magnitudeLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        iconView.isAccessibilityElement = true
        iconView.accessibilityHint = "icon representation of earthquake magnitude"
        
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityHint = "title of earthquake"
        
        dateLabel.isAccessibilityElement = true
        dateLabel.accessibilityHint = "date of earthquake"
        
        magnitudeLabel.isAccessibilityElement = true
        magnitudeLabel.accessibilityHint = "magnitude of earthquake"
        
        if #available(iOS 11.0, *) {
            iconView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        } else {
            // Fallback on earlier versions
        }
        titleLabel.adjustsFontForContentSizeCategory = true
        dateLabel.adjustsFontForContentSizeCategory = true
        magnitudeLabel.adjustsFontForContentSizeCategory = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate(with quake: Quake) {
        titleLabel.text = quake.title
        let mag = quake.magnitude == nil ? "": "\(quake.magnitude!.rounded(toPlaces: quake.magnitude! < 0 ? 3 : 2))"
        let magType = quake.magnitudeType ?? ""
        magnitudeLabel.text = mag + "\n" + magType
        
        var dtText: String?
        if let dt = quake.datetime {
            let dtQuake = Date.init(timeIntervalSince1970: dt)
            dtText = "\(QuakeListViewController.dateFormatter.string(from: dtQuake)) UTC"
        }
        dateLabel.text = dtText ?? ""
        iconView?.contentMode = UIView.ContentMode.scaleAspectFit
        iconView?.image = imageForQuakeMagnitude(quake.magnitude)
    }
}


extension QuakeTableViewCell {
    func imageForQuakeMagnitude(_ magnitude:Double?) -> UIImage {
        var suffix = ""
        
        if let mag = magnitude {
            if mag < 1 {
                suffix = "_0"
            } else if mag < 2 {
                suffix = "_1"
            } else if mag < 3 {
                suffix = "_2"
            } else if mag < 5 {
                suffix = "_3"
            } else if mag < 6 {
                suffix = "_4"
            } else {
                suffix = "_5"
            }
        }
        
        return UIImage(named: "quake\(suffix)")!
    }
}


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
