//
//  taskDetailsEdit.swift
//  EpitechEisenhower
//
//  Created by Vincent Augrain on 23/03/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//

import UIKit
import Firebase

class taskDetailsEdit: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, addProfileDelegate {
    
    var isNew = false
    var ta: task! = nil
    @IBOutlet var titleTextView: UITextView!
    @IBOutlet var profilesView: UIView!
    @IBOutlet var descTextView: UITextView!
    @IBOutlet var dateTextView: UITextView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet weak var importantIndicator: UIButton!
    @IBOutlet weak var urgentIndicator: UIButton!
    @IBOutlet weak var addInstructionLabel: UILabel!
    @IBOutlet weak var profiles: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isNew {
            initFieldsWithNew()
        }
        else {
            initFields()
        }
        initStyles()
    }
    
    func updateAddedProfile(profile: profile) {
        var isAlreadyAssigned = false
        var cpt = 0
        
        while (cpt < ta.assignedProfiles.count && !isAlreadyAssigned)
        {
            isAlreadyAssigned = ta.assignedProfiles[cpt].uid == profile.uid
            cpt = cpt + 1
        }
        if (!isAlreadyAssigned) {
            ta.assignedProfiles.append(profile)
            profiles.reloadData()
            addInstructionLabel.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowModalView") {
            let destination = segue.destination as! ModalSearchViewController
            destination.myProtocol = self
        }
    }
    
    func initFieldsWithNew() {
        titleTextView.placeholder = Values.preFilled.addingNewTask.title
        descTextView.placeholder = Values.preFilled.addingNewTask.desc
        dateTextView.placeholder = Values.preFilled.addingNewTask.date
        self.ta = task(title: "", date: "", desc: "", important: false, urgent: false)
        updateIndicators()
    }
    
    func initStyles() {
        titleTextView.layer.cornerRadius = Values.radius.small
        profilesView.layer.cornerRadius = Values.radius.small
        descTextView.layer.cornerRadius = Values.radius.small
        dateTextView.layer.cornerRadius = Values.radius.small
        saveButton.layer.cornerRadius = Values.radius.small
        deleteButton.layer.cornerRadius = Values.radius.small
        if (ta.assignedProfiles.isEmpty) {
            addInstructionLabel.isHidden = false
        }
    }
    
    func initFields() {
        titleTextView.text = ta.title
        descTextView.text = ta.desc
        dateTextView.text = ta.date
        task.getTaskFrom(tid: ta.id) {
            if (fetchedData.currentTask != nil)
            {
                self.ta = fetchedData.currentTask
                self.descTextView.text = self.ta.desc
                self.profiles.reloadData()
            }
        }
        updateIndicators()
    }
    
    func updateIndicators() {
        importantIndicator.alpha = (ta.imp ? 1 : 0.3)
        urgentIndicator.alpha = (ta.urg ? 1 : 0.3)
    }
    @IBAction func importantClick(_ sender: Any) {
        self.ta.imp = !ta.imp
        updateIndicators()
    }
    
    @IBAction func urgentClick(_ sender: Any) {
        self.ta.urg = !ta.urg
        updateIndicators()
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    @IBAction func deleteTask(_ sender: Any) {
        if !isNew {
            deleteTaskFromFirebase() { state, errorDesc in
                if (!state || errorDesc != nil) {
                    self.alert(message: Values.preFilled.addingNewTask.deleteError + errorDesc!)
                }
                else {_ = self.navigationController?.popViewController(animated: true) }
            }
        }
        else {
            alert(message: Values.preFilled.addingNewTask.deleteNew, title: Values.strings.oops)
        }
    }
    
    
    @IBAction func saveChanges(_ sender: Any) {
        if (!isIncorrectForm()) {
            self.ta.title = titleTextView.text
            self.ta.desc = descTextView.text
            self.ta.date = dateTextView.text
            
            updateTaskToFirebase() { state, errorDesc in
                if (!state || errorDesc != nil) {
                    self.alert(message: Values.preFilled.addingNewTask.upError + errorDesc!)
                }
                else {_ = self.navigationController?.popViewController(animated: true) }
            }
        }
        else {
            alert(message: Values.preFilled.addingNewTask.formError, title: Values.strings.error)
        }
    }
    
    func deleteTaskFromFirebase(completion: @escaping ((_ success: Bool, _ errorDesc: String?)->())){
        let taskRef = Database.database().reference().child(Values.firebaseObjson.TASKS).child(self.ta.id)
        
        taskRef.removeValue(){ error, _ in
            if let errorTag = error?.localizedDescription {
                completion(false, errorTag)
            }
            else {
                for user in self.ta.assignedProfiles {
                    user.deassignTask(task: self.ta)
                }
                completion(true, nil)
            }
        }
    }
    
    
    func updateTaskToFirebase(completion: @escaping ((_ success: Bool, _ errorDesc: String?)->())){
        var taskRef = Database.database().reference().child(Values.firebaseObjson.TASKS)
        if isNew {
            taskRef = taskRef.childByAutoId()
        }
        else {
            taskRef = taskRef.child(self.ta.id)
        }
        taskRef.setValue(self.ta.ToFirObj()){ error, ref in
            if let errorTag = error?.localizedDescription {
                completion(false, errorTag)
            }
            else {
                self.ta.id = ref.key
                for user in self.ta.assignedProfiles {
                    user.assignTask(task: self.ta)
                }
                self.isNew = false
                completion(true, nil)
            }
        }
    }
    
    func isIncorrectForm() -> Bool {
        return (titleTextView.text == "" || titleTextView.text == nil) ||
            (descTextView.text == "" || descTextView.text == nil) ||
            (dateTextView.text == "" || dateTextView.text == nil)
    }
    
    //UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 8
    }
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.addInstructionLabel.isHidden = ta.assignedProfiles.count > 0
        return ta.assignedProfiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath as IndexPath) as! profileCollectionCell
        if (ta.assignedProfiles[indexPath.row].pic != nil)
        {
            cell.imageView.image = ta.assignedProfiles[indexPath.row].pic
        }
        else {
            ta.assignedProfiles[indexPath.row].getPicUrl() {
                cell.imageView.imageFromServerURL(urlString: self.ta.assignedProfiles[indexPath.row].picUrl) {
                    self.ta.assignedProfiles[indexPath.row].pic = cell.imageView.image
                }
            }
        }
        return cell
    }

}
