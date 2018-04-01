//
//  SearchTableViewCell.swift
//  EpitechEisenhower
//
//  Created by Vincent Augrain on 31/03/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//

import UIKit

class SearchTableViewCell : UITableViewCell {
    
    @IBOutlet var profileImage : UIImageView!
    @IBOutlet var profileTitle : UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.profileImage.layer.masksToBounds = true
        self.profileImage.layer.cornerRadius = CGFloat(roundf(Float(self.profileImage.frame.size.width/2.0)))
    }
}
