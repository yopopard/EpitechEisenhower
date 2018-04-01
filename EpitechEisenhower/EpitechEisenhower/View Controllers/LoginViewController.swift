//
//  ViewController.swift
//  EpitechEisenhower
//
//  Created by fauquette fred on 25/09/17.
//  Copyright © 2017 Epitech. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var gPlusButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var connectButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        connectButton.layer.cornerRadius = Values.radius.small
        signInButton.layer.cornerRadius = Values.radius.small
        gPlusButton.layer.cornerRadius = Values.radius.small
        fbButton.layer.cornerRadius = Values.radius.small
    
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func connect(_ sender: Any) {
        performSegue(withIdentifier: "showHome", sender: nil)
    }
}

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}


