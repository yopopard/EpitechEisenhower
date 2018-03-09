//
//  taskClass.swift
//  EpitechEisenhower
//
//  Created by Vincent Augrain on 09/03/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//

import UIKit

class task {
    var title: String!
    var date: String!
    var imp: Bool!
    var urg: Bool!
    
    init(title: String, date: String, important: Bool, urgent: Bool) {
        self.title = title
        self.date = date
        self.imp = important
        self.urg = urgent
    }
    
    func getColor() -> UIColor {
        if (imp) {
            if (urg) {
                return Values.colors.imp_urg
            }
            else {
                return Values.colors.imp
            }
        }
        else {
            if (urg) {
                return Values.colors.urg
            }
            else {
                return Values.colors.none
            }
        }
    }
}
