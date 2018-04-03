//
//  values.swift
//  EpitechEisenhower
//
//  Created by Vincent Augrain on 09/03/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//
import UIKit
import Foundation

struct Values {
    struct colors {
        static let imp_urg = UIColor(hex: "#ff3a07").withAlphaComponent(0.8)
        static let urg = UIColor(hex: "#7ed321").withAlphaComponent(0.8)
        static let imp = UIColor(hex: "#0da0b2").withAlphaComponent(0.8)
        static let none = UIColor(hex: "#f8e81c").withAlphaComponent(0.4)
    }
    
    struct radius{
        static let small = CGFloat(5.0)
    }
    
    struct strings {
        static let defaultDesc = "Quick description with details and specs Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tristique nisl ornare velit fermentum lobortis. Pellentesque eget sagittis nulla. Suspendisse congue efficitur mollis. Nunc ut ultrices felis. Morbi lorem turpis, gravida in ultrices non, eleifend et felis. Suspendisse non nunc"
        static let error = "Error"
        static let success = "Success"
        static let signUp = "Sign Up"
        static let oops = "Oops"
    }
    
    struct preFilled {
        struct signup {
            static let name = "Enter your names or nickname"
            static let desc = "Enter your description here"
            static let email = "Enter your email here"
            static let error = "Please fill all the required fields"
            static let success = "Your profile has correctly been created"
            static let renewPwd = "An email to reset you password has been sent to your email.\nA link in this mail will allow you to change it"
            static let renewMail = "Your email has been reset.\nYou will have to log back again"
        }
        struct upload {
            static let error = "An error occured while attempting to upload you picture : "
            static let picNil = "Your profile could'nt have been updated because we can not open your picture"
            static let baseError = "An error occured and your profil has not been updated"
            static let success = "Your profile has correctly been updated"
        }
        struct addingNewTask {
            static let formError = "Please check and fill all the required fields"
            static let upError = "An error occured and your task could not have been created :\n"
            static let title = "Enter your task title here"
            static let date = "Enter the deadline date here"
            static let desc = "Enter the task description here"
            static let deleteNew = "You can't delete this task because it has'nt been created yet"
            static let deleteError = "An error occured and your task could not have been deleted :\n"
        }
    }
    
    struct firebaseObjson {
        static let USERS = "users"
        static let NAME = "name"
        static let PICTURE = "ppUrl"
        static let USER_DESC = "desc"
        static let EMAIL = "email"
        
        static let TASKS = "tasks"
        static let TITLE = "title"
        static let DATE = "date"
        static let TASK_DESC = "desc"
        static let IMP = "imp"
        static let URG = "urg"
        static let ASSIGNED_PROFILES = "assignedUsers"
    }
    
    struct firebaseData {
        static let storagePath = "userPictures/"
        static let imageCompression = CGFloat(0.5)
        static let metaDataContentType = "image/jpg/"
        static let userProfilePath = firebaseObjson.USERS + "/"
        static let taskDataPath = firebaseObjson.TASKS + "/"
    }
}

