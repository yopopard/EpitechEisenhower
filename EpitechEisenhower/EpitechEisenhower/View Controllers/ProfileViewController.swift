//
//  ProfileViewController.swift
//  EpitechEisenhower
//
//  Created by Vincent Augrain on 25/03/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var yourProfile: profile!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var profileName: UITextView!
    @IBOutlet var profileDescription: UITextView!
    @IBOutlet var profileEmail: UITextView!
    @IBOutlet var renewPasswordButton: UIButton!
    @IBOutlet var saveChangesButton: UIButton!
    @IBOutlet var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yourProfile = profile(fn: "Yohan", ln: "Paupardin", pic: UIImage(named: "yohan")!, email: "noisette@gmail.com")
        initFields()
        initStyles()
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    func initStyles() {
        profileName.layer.cornerRadius = Values.radius.small
        profileDescription.layer.cornerRadius = Values.radius.small
        profileEmail.layer.cornerRadius = Values.radius.small
        renewPasswordButton.layer.cornerRadius = Values.radius.small
        saveChangesButton.layer.cornerRadius = Values.radius.small
        logoutButton.layer.cornerRadius = Values.radius.small
        
        profilePic.layer.masksToBounds = false
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
    }
    
    func initFields() {
        profileName.text = yourProfile.firstName + " " + yourProfile.lastName
        profileDescription.text = yourProfile.desc
        profileEmail.text = yourProfile.email
    }
}
