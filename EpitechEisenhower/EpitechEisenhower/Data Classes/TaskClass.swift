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
    var desc: String!
    var imp: Bool! // Si c'est important
    var urg: Bool! // Si c'est urgent
    var assignedProfiles: [profile]! // Les profiles des utilisateurs assignés à la tache
    
    init(title: String, date: String, important: Bool, urgent: Bool) {
        self.title = title
        self.date = date
        self.desc = Values.strings.defaultDesc
        self.imp = important
        self.urg = urgent
        self.assignedProfiles = [
            profile(fn: "Yohan", ln: "Paupardin", pic: UIImage(named: "yohan")!, email: "noisette@gmail.com"),
            profile(fn: "Yohan", ln: "Paupardin", pic: UIImage(named: "yohan")!, email: "noisette@gmail.com"),
            profile(fn: "Yohan", ln: "Paupardin", pic: UIImage(named: "yohan")!, email: "noisette@gmail.com"),
            profile(fn: "Yohan", ln: "Paupardin", pic: UIImage(named: "yohan")!, email: "noisette@gmail.com"),
            profile(fn: "Yohan", ln: "Paupardin", pic: UIImage(named: "yohan")!, email: "noisette@gmail.com")
        ]
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
