//
//  ProfileViewController.swift
//  EpitechEisenhower
//
//  Created by Vincent Augrain on 25/03/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    var yourProfile: profile!
    var isSignup = false
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var imagePicker : UIImagePickerController!
    var photoChanged = false
    
    @IBOutlet var profileName: UITextView!
    @IBOutlet var profileDescription: UITextView!
    @IBOutlet var profileEmail: UITextView!
    @IBOutlet var profilePassword: UITextField!
    @IBOutlet var renewPasswordButton: UIButton!
    @IBOutlet var saveChangesButton: UIButton!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initStyles()
        if (isSignup) {
            initSignup()
        }
        else {
            yourProfile = fetchedData.user
            initFields()
        }
        self.view.addSubview(activityView)
        addImageButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    func initSignup() {
        profileName.placeholder = Values.preFilled.signup.name
        profileDescription.placeholder = Values.preFilled.signup.desc
        profileEmail.placeholder = Values.preFilled.signup.email
        renewPasswordButton.isHidden = true
        saveChangesButton.setTitle(Values.strings.signUp, for: .normal)
        logoutButton.isHidden = true
        saveChangesButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    @IBAction func renewPassword(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: (fetchedData.user?.email)!) { (error) in
            self.alert(message: Values.preFilled.signup.renewPwd, title: (fetchedData.user?.email)!) {
                self.logoutClick(self)
            }
        }
    }
    
    @IBAction func logoutClick(_ sender: Any) {
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    
    func initStyles() {
        profileName.layer.cornerRadius = Values.radius.small
        profileDescription.layer.cornerRadius = Values.radius.small
        profileEmail.layer.cornerRadius = Values.radius.small
        renewPasswordButton.layer.cornerRadius = Values.radius.small
        saveChangesButton.layer.cornerRadius = Values.radius.small
        logoutButton.layer.cornerRadius = Values.radius.small
        addImageButton.layer.masksToBounds = false
        addImageButton.layer.cornerRadius = addImageButton.frame.height/2
        addImageButton.clipsToBounds = true
    }
    
    func initFields() {
        addImageButton.imageView?.image = nil
        profileName.text = yourProfile.name
        profileDescription.text = yourProfile.desc
        profileEmail.text = yourProfile.email
        if (yourProfile.pic != nil) {
            print("Already loaded")
            addImageButton.imageView?.image = yourProfile.pic
        }
        else {
            addImageButton.imageFromServerURL(urlString: yourProfile.picUrl) {
                self.yourProfile.pic = self.addImageButton.imageView?.image
                fetchedData.user?.pic = self.addImageButton.imageView?.image
                print("image loaded set")
            }
        }
        profilePassword.isHidden = true
        saveChangesButton.addTarget(self, action: #selector(modifyProfile), for: .touchUpInside)
    }
    
    @objc func openImagePicker(){
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func uploadPP(_ image:UIImage, completion: @escaping ((_ url: URL?)->())) {
        if let uid = Auth.auth().currentUser?.uid {
            let storage = Storage.storage().reference().child(Values.firebaseData.storagePath + "\(uid)")
            if let imageData = UIImageJPEGRepresentation(image, 0.75) {
                let md = StorageMetadata()
                md.contentType = Values.firebaseData.metaDataContentType
                storage.putData(imageData, metadata: md) { metaData, error in
                    if (error == nil && metaData != nil) {
                        if let picUrl = metaData?.downloadURL() { completion(picUrl) }
                        else { completion(nil)}
                    }
                    else {
                        self.saveChangesButton.isEnabled = true
                        self.activityView.stopAnimating()
                        self.saveChangesButton.setTitle(Values.strings.signUp, for: .normal)
                        self.alert(message: Values.preFilled.upload.error + (error?.localizedDescription)!, title: Values.strings.error)
                        completion(nil)
                    }
                }
            }
            else { return }
        }
        else { return }
    }
    
    func handleMailChanged(success: Bool, reset: Bool) {
        self.alert(message: success ? Values.preFilled.upload.success : Values.preFilled.upload.baseError) {
            if (success && reset) {
                self.alert(message: Values.preFilled.signup.renewMail, title: Values.strings.success) {
                    self.logoutClick(self)
                }
            }
        }
    }
    
    @objc func modifyProfile() {
        if photoChanged {
            if (isIncorrectUpdateForm()) {
                self.alert(message: Values.preFilled.signup.error, title: Values.strings.error)
            }
            else {
                if (addImageButton.imageView != nil && addImageButton.imageView?.image != nil) {
                    uploadPP((addImageButton.imageView?.image)!){ url in
                        guard let Url = url else { return }
                        self.yourProfile.updateProfileInfo(username: self.profileName.text, description: self.profileDescription.text, ppUrl: Url, email: self.profileEmail.text) { success, reset in
                            self.handleMailChanged(success: success, reset: reset)
                        }
                    }
                }
                else { self.alert(message: Values.preFilled.upload.picNil, title: Values.strings.error) }
                }
            }
            else {
                if (isIncorrectUpdateForm())
                {
                self.alert(message: Values.preFilled.signup.error, title: Values.strings.error)
                }
                else {
                    self.yourProfile.updateProfileInfo(username: self.profileName.text, description: self.profileDescription.text, ppUrl: URL(string: self.yourProfile.picUrl)!, email: self.profileEmail.text) { success, reset in
                        self.alert(message: success ? Values.preFilled.upload.success : Values.preFilled.upload.baseError) {
                            self.handleMailChanged(success: success, reset: reset)
                        }
                    }
                }
            }
    }
    
    @objc func signUp() {
        if isIncorrectForm() {
            self.alert(message: Values.preFilled.signup.error, title: Values.strings.error) }
        else {
            saveChangesButton.isEnabled = false
            saveChangesButton.setTitle("", for: .normal)
            activityView.frame = saveChangesButton.frame
            activityView.startAnimating()
            Auth.auth().createUser(withEmail: profileEmail.text, password: profilePassword.text!) { user, error in
                if error == nil && user != nil && self.addImageButton.imageView != nil && self.addImageButton.imageView?.image != nil {
                    self.uploadPP((self.addImageButton.imageView?.image)!) { url in
                        if url != nil {
                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            changeRequest?.displayName = self.profileName.text
                            changeRequest?.photoURL = url
                            changeRequest?.commitChanges{ (error) in
                                if error == nil {
                                    self.yourProfile = profile(name: "", pic: "", email: "")
                                    self.yourProfile.updateProfileInfo(username: self.profileName.text, description: self.profileDescription.text, ppUrl: url!, email: self.profileEmail.text) { success, _ in
                                        self.saveChangesButton.isEnabled = true
                                        self.activityView.stopAnimating()
                                        self.saveChangesButton.setTitle(Values.strings.signUp, for: .normal)
                                        if success { self.alert(message: Values.preFilled.signup.success, title: Values.strings.success) }
                                    }
                                }
                                else { self.alert(message: (error?.localizedDescription)!, title: Values.strings.error) }
                            }
                        }
                        else { return }
                    }
                }
                else {
                    self.saveChangesButton.isEnabled = true
                    self.activityView.stopAnimating()
                    self.saveChangesButton.setTitle(Values.strings.signUp, for: .normal)
                    self.alert(message: (error?.localizedDescription)!, title: Values.strings.error)
                }
            }
        }
    }
    
    func isIncorrectUpdateForm() -> Bool {
        return profileName.text == "" || profileDescription.text == "" || profileEmail.text == ""
    }
    
    func isIncorrectForm() -> Bool {
        return profileName.text == "" || profileDescription.text == "" || profileEmail.text == "" || profilePassword.text == ""
    }
}



extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage =  info[UIImagePickerControllerEditedImage] as? UIImage {
            self.addImageButton.setImage(pickedImage, for: .normal)
            self.photoChanged = true
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
}
