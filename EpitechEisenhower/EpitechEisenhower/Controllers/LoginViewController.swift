//
//  ViewController.swift
//  EpitechEisenhower
//
//  Created by fauquette fred on 25/09/17.
//  Copyright © 2017 Epitech. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var gPlusButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(activityView)
        activityView.frame = connectButton.frame
        connectButton.layer.cornerRadius = Values.radius.small
        signInButton.layer.cornerRadius = Values.radius.small
        gPlusButton.layer.cornerRadius = Values.radius.small
        fbButton.layer.cornerRadius = Values.radius.small
        navigationItem.hidesBackButton = true 
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signupSegue" {
            let destiation = segue.destination as! ProfileViewController
            destiation.isSignup = true
        }
    }

    @IBAction func connect(_ sender: Any) {
        let tmpTitle = connectButton.title(for: .normal)
        connectButton.setTitle("", for: .normal)
        activityView.startAnimating()
        connectButton.isEnabled = false
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            self.activityView.stopAnimating()
            self.connectButton.setTitle(tmpTitle, for: .normal)
            self.connectButton.isEnabled = true
            if (error == nil && user != nil) {
                self.performSegue(withIdentifier: "showHome", sender: nil)
            }
            else {
                self.alert(message: "Connection Failed", title: "Error")
            }
        }
    }
}

