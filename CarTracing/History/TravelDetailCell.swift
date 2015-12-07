//
//  TravelDetailCell.swift
//  CarTracing
//
//  Created by li pengxuan on 15/12/7.
//  Copyright © 2015年 li pengxuan. All rights reserved.
//

import UIKit

@objc class TravelDetailCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationStrLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
