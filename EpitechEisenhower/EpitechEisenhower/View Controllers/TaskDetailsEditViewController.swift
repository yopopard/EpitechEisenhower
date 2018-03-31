//
//  taskDetailsEdit.swift
//  EpitechEisenhower
//
//  Created by Vincent Augrain on 23/03/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//

import UIKit

class taskDetailsEdit: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var ta: task! = nil
    @IBOutlet var titleTextView: UITextView!
    @IBOutlet var profilesView: UIView!
    @IBOutlet var descTextView: UITextView!
    @IBOutlet var dateTextView: UITextView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    @IBOutlet weak var profiles: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFields()
        initStyles()
    }
    
    func initStyles() {
        titleTextView.layer.cornerRadius = Values.radius.small
        profilesView.layer.cornerRadius = Values.radius.small
        descTextView.layer.cornerRadius = Values.radius.small
        dateTextView.layer.cornerRadius = Values.radius.small
        saveButton.layer.cornerRadius = Values.radius.small
        deleteButton.layer.cornerRadius = Values.radius.small
    }
    
    func initFields() {
        titleTextView.text = ta.title
        descTextView.text = ta.desc
        dateTextView.text = ta.date
    }

    override func didReceiveMemoryWarning() {
        
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
        print(ta.assignedProfiles.count)
        return ta.assignedProfiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath as IndexPath) as! profileCollectionCell
        cell.imageView.image = ta.assignedProfiles[indexPath.row].pic
        return cell
    }

}
