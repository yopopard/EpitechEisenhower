//
//  profileClass.swift
//  EpitechEisenhower
//
//  Created by Vincent Augrain on 23/03/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//

import UIKit
import Firebase

class profile {
    var uid: String!
    var name: String!
    var picUrl: String!
    var pic: UIImage?
    var desc: String!
    var email: String!
    var tasks: [task]!
    
    init(name: String, pic: String, email: String) {
        self.uid = ""
        self.name = name
        self.desc = Values.strings.defaultDesc
        self.picUrl = pic
        self.email = email
        self.tasks = []
    }
    
    init(name: String, desc: String, pic: String, email: String) {
        self.uid = ""
        self.name = name
        self.desc = desc
        self.picUrl = pic
        self.email = email
        self.tasks = []
    }
    
    init(uid: String, name: String, desc: String, pic: String, email: String) {
        self.uid = uid
        self.name = name
        self.desc = desc
        self.picUrl = pic
        self.email = email
        self.tasks = []
    }
    
    static func firObjToProfile(uid: String, sub: [String:Any]) -> profile? {
        
        guard let name = sub[Values.firebaseObjson.NAME] as? String else { print("Error parse name"); return nil }
        guard let desc = sub[Values.firebaseObjson.USER_DESC] as? String else { print("Error parse desc"); return nil }
        guard let pic = sub[Values.firebaseObjson.PICTURE] as? String else { print("Error parse pic"); return nil }
        guard let email = sub[Values.firebaseObjson.EMAIL] as? String else { print("Error parse mail"); return nil }
        
        let retProfile = profile(uid: uid, name: name, desc: desc, pic: pic, email: email)
        return retProfile
    }
    
    func ToFirObj() -> [String:Any] {
        let sub = [
            Values.firebaseObjson.USER_DESC: self.desc,
            Values.firebaseObjson.EMAIL: self.email,
            Values.firebaseObjson.NAME: self.name,
            Values.firebaseObjson.PICTURE: self.picUrl
        ] as [String:Any]
        let whole = [self.uid: sub] as [String: Any]

        return whole
    }
    
    func ToSimpleFirObj() -> [String:Any] {
        return [
            Values.firebaseObjson.USER_DESC: self.desc,
            Values.firebaseObjson.EMAIL: self.email,
            Values.firebaseObjson.NAME: self.name,
            Values.firebaseObjson.PICTURE: self.picUrl
            ] as [String:Any]
    }
    
    func getPicUrl(completion: @escaping (()->())) {
        let userRef = Database.database().reference().child(Values.firebaseObjson.USERS).child(self.uid)
        userRef.observe(.value) { data in
            if let mainDict = data.value as? [String:Any] {
                guard let sub = mainDict[Values.firebaseObjson.PICTURE] as? String else {print("Error getting getPicUrl"); return}
                self.picUrl = sub
                completion()
            }
        }
    }
    
    func assignTask(task: task) {
        let taskRef = Database.database().reference().child(Values.firebaseObjson.USERS).child(self.uid).child(Values.firebaseObjson.TASKS).child(task.id)
            taskRef.setValue(task.ToSimpleFirObj())
    }
    
    func deassignTask(task: task) {
        let taskRef = Database.database().reference().child(Values.firebaseObjson.USERS).child(self.uid).child(Values.firebaseObjson.TASKS).child(task.id)
        taskRef.removeValue()
    }
    
    func updateProfileInfo(username: String, description: String, ppUrl: URL, email: String, completion: @escaping ((_ success: Bool,_ emailReset: Bool)->())){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var tasks = [String:Any]()
        
        if (self.tasks != nil && !self.tasks.isEmpty) {
            for t in self.tasks {
                tasks[t.id] = t.ToSimpleFirObj()
            }
        }
        else { tasks = [:] }
        let dbRef = Database.database().reference().child(Values.firebaseData.userProfilePath + "\(uid)")
        let objson = [
            Values.firebaseObjson.NAME: username,
            Values.firebaseObjson.PICTURE: ppUrl.absoluteString,
            Values.firebaseObjson.USER_DESC: description,
            Values.firebaseObjson.EMAIL: email,
            Values.firebaseObjson.TASKS: tasks
            ] as [String:Any]
        dbRef.setValue(objson) { error, ref in
            if (self.email != nil && self.email != "" && self.email != email) {
                Auth.auth().currentUser?.updateEmail(to: email) { (error) in
                    completion(error == nil, true)
                }
            }
            else {
                completion(error == nil, false)
            }
        }
    }
    
    func taskSorter() {
        var urgimp = [task]()
        var urg = [task]()
        var imp = [task]()
        var none = [task]()

        if self.tasks != nil && self.tasks.count > 0
        {
            for t in self.tasks {
                if (t.imp) {
                    if (t.urg) {
                        urgimp.append(t)
                    }
                    else {
                        imp.append(t)
                    }
                }
                else {
                    if (t.urg) {
                        urg.append(t)
                    }
                    else {
                        none.append(t)
                    }
                }
            }
            
            self.tasks.removeAll()
            for t in urgimp { self.tasks.append(t) }
            for t in urg { self.tasks.append(t) }
            for t in imp { self.tasks.append(t) }
            for t in none { self.tasks.append(t) }
        }
    }
    
    static func getProfileFrom(uid: String, completion: @escaping (()->())){
        let userRef = Database.database().reference().child(Values.firebaseObjson.USERS).child(uid)
        var retProfile: profile?
        userRef.observe(.value, with: { snapshot in
            if let dict = snapshot.value as? [String:Any],
                let name = dict[Values.firebaseObjson.NAME] as? String,
                let pic = dict[Values.firebaseObjson.PICTURE] as? String,
                let desc = dict[Values.firebaseObjson.USER_DESC] as? String,
                let email = Auth.auth().currentUser?.email
            {
                retProfile = profile(uid: uid, name: name, desc: desc, pic: pic, email: email)
                retProfile?.tasks = [task]()
                if let tasks = dict[Values.firebaseObjson.TASKS] as? [String:Any] {
                    for val in tasks.keys {
                        guard let subDict = tasks[val] as? [String:Any] else { print("error: getProfileFrom subDict"); return}
                        guard let toAddTask = task.firObjToTask(tid: val, data: subDict) else { print("error: getProfileFrom toAddTask"); return}
                        retProfile?.tasks.append(toAddTask)
                    }
                }
                else {
                    print("Ok new profile with no assigned task")
                }
                fetchedData.user = retProfile
                if (fetchedData.user != nil ) {
                    fetchedData.user?.taskSorter()
                    completion()
                }
                else {
                    print("Error cannot fetch profile 1")
                }
            }
            else {
                print("Error cannot fetch profile 2: One of the fields cannot be found")
            }
        })
    }
}

