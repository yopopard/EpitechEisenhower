//
//  collectionCellView.swift
//  EpitechEisenhower
//
//  Created by Vincent Augrain on 08/03/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//

import UIKit

class collectionCellView: UICollectionViewCell {
    
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskDate: UILabel!
    @IBOutlet weak var importantIndicator: UIImageView!
    @IBOutlet weak var urgentIndicator: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    
}
