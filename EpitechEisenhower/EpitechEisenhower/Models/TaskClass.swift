//
//  taskClass.swift
//  EpitechEisenhower
//
//  Created by Vincent Augrain on 09/03/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//

import UIKit
import Firebase

class task {
    var id: String!
    var title: String!
    var date: String!
    var desc: String!
    var imp: Bool! // Si c'est important
    var urg: Bool! // Si c'est urgent
    var assignedProfiles: [profile]! // Les profiles des utilisateurs assignés à la tache
    
    init(id: String, title: String, date: String, important: Bool, urgent: Bool) {
        self.id = id
        self.title = title
        self.date = date
        self.desc = ""
        self.imp = important
        self.urg = urgent
        self.assignedProfiles = []
    }
    
    init(id: String, title: String, date: String, desc: String, important: Bool, urgent: Bool) {
        self.id = id
        self.title = title
        self.date = date
        self.desc = desc
        self.imp = important
        self.urg = urgent
        self.assignedProfiles = []
    }
    
    init(title: String, date: String, desc: String, important: Bool, urgent: Bool) {
        self.id = nil
        self.title = title
        self.date = date
        self.desc = desc
        self.imp = important
        self.urg = urgent
        self.assignedProfiles = []
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
    
    func ToFirObj() -> [String:Any] {
        var assignedProfiles = [String:Any]()
        for user in self.assignedProfiles {
            assignedProfiles[user.uid] = user.ToSimpleFirObj()
        }
        return [
            Values.firebaseObjson.TITLE: self.title,
            Values.firebaseObjson.DATE: self.date,
            Values.firebaseObjson.TASK_DESC: self.desc,
            Values.firebaseObjson.IMP: self.imp,
            Values.firebaseObjson.URG: self.urg,
            Values.firebaseObjson.ASSIGNED_PROFILES: assignedProfiles
            ] as [String:Any]
    }
    
    func ToSimpleFirObj() -> [String:Any] {
        return [
            Values.firebaseObjson.TITLE: self.title,
            Values.firebaseObjson.DATE: self.date,
            Values.firebaseObjson.TASK_DESC: self.desc,
            Values.firebaseObjson.IMP: self.imp,
            Values.firebaseObjson.URG: self.urg,
            ] as [String:Any]
    }
    
    func assignUser(user: profile) {
        self.assignedProfiles.append(user)
        user.assignTask(task: self)
    }
    
    static func getTaskFrom(tid: String, completion: @escaping (()->())){
        let taskRef = Database.database().reference().child(Values.firebaseObjson.TASKS).child(tid)
        var retTask: task?
        taskRef.observe(.value, with: { snapshot in
            if let dict = snapshot.value as? [String:Any] {
                retTask = firObjToTask(tid: tid, data: dict)
                if (retTask != nil)
                {
                    fetchedData.currentTask = retTask
                    completion()
                }
            }
        })
    }
    
    static func firObjToTask(tid: String, data: [String:Any]) -> task? {
        var retTask: task?
        guard let title = data[Values.firebaseObjson.TITLE] as? String else { print("Error firObjToTask title"); return nil }
        guard let date = data[Values.firebaseObjson.DATE] as? String else { print("Error firObjToTask date"); return nil }
        guard let imp = data[Values.firebaseObjson.IMP] as? Bool else { print("Error firObjToTask imp"); return nil }
        guard let urg = data[Values.firebaseObjson.URG] as? Bool else { print("Error firObjToTask urg"); return nil }
        
        if let desc = data[Values.firebaseObjson.TASK_DESC] as? String {
            retTask = task(id: tid, title: title, date: date, desc: desc, important: imp, urgent: urg)
            if let notNil = retTask {
                if let assigned = data[Values.firebaseObjson.ASSIGNED_PROFILES] as? [String:Any]{
                    notNil.assignedProfiles = [profile]()
                    for val in assigned.keys {
                        guard let subDict = assigned[val] as? [String:Any] else { print("error: firObjToTask subDict"); return nil}
                        guard let toAddProfile = profile.firObjToProfile(uid: val, sub: subDict) else { print("error: firObjToTask toAddProfile"); return nil}
                        notNil.assignedProfiles.append(toAddProfile)
                    }
                    return retTask
                }
            }
            else {
                print("firObjToTask Error nil task")
            }
        }
        else {
            retTask = task(id: tid, title: title, date: date, important: imp, urgent: urg)
        }
        
        return retTask
    }
}

