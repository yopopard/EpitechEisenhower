//
//  profileClass.swift
//  EpitechEisenhower
//
//  Created by Vincent Augrain on 23/03/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//

import UIKit

class profile {
    var firstName: String!
    var lastName: String!
    var pic: UIImage!
    var desc: String!
    var email: String!
    
    init(fn: String, ln: String, pic: UIImage, email: String) {
        self.firstName = fn
        self.lastName = ln
        self.desc = Values.strings.defaultDesc
        self.pic = pic
        self.email = email
    }
}

