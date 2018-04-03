//
//  profileCollectionCell.swift
//  EpitechEisenhower
//
//  Created by Vincent Augrain on 23/03/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//

import UIKit

class profileCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = CGFloat(roundf(Float(self.imageView.frame.size.width/2.0)))
    }
}

