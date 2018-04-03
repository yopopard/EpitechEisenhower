//
//  taskPageViewController.swift
//  EpitechEisenhower
//
//  Created by Vincent Augrain on 08/03/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//

import UIKit
import Firebase

class taskPageViewController: UICollectionViewController {
    
    @IBOutlet var collection: UICollectionView!
    var profileButton: UIButton!
    var activityView = UIActivityIndicatorView ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.activityView)
        self.activityView.frame = self.view.frame
        self.activityView.startAnimating()
        profile.getProfileFrom(uid: (Auth.auth().currentUser?.uid)!) {
            self.activityView.stopAnimating()
            self.collection.reloadData()
        }
        let profileImage = UIImage(named: "ProfileIcon")
        navigationItem.hidesBackButton = true 
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(goToProfile))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        profile.getProfileFrom(uid: (Auth.auth().currentUser?.uid)!) {
            self.collection.reloadData()
        }
    }
    
    @objc func goToProfile() {
        performSegue(withIdentifier: "profileSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let nextScene =  segue.destination as! taskDetailsEdit
            if let indexPath = self.collection.indexPath(for: sender as! collectionCellView) {
                if (indexPath.row == 0) {
                    nextScene.isNew = true
                }
                else {
                    nextScene.ta = fetchedData.user?.tasks[indexPath.row - 1]
                }
                
            }
        }
    }
    
    //UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        
        return 8;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        
        return 8;
    }
    
    
    //UICollectionViewDatasource methods
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (fetchedData.user != nil && fetchedData.user?.tasks != nil) {
            return (fetchedData.user?.tasks.count)! + 1
        }
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath as IndexPath) as! collectionCellView
        
        if (indexPath.row == 0) {
            cell.backgroundColor = .clear
            cell.importantIndicator.isHidden = true
            cell.urgentIndicator.isHidden = true
            cell.taskTitle.isHidden = true
            cell.taskDate.isHidden = true
            cell.addButton.isHidden = false
            cell.addButton.isUserInteractionEnabled = false
        }
        else {
            cell.importantIndicator.isHidden = false
            cell.urgentIndicator.isHidden = false
            cell.taskTitle.isHidden = false
            cell.taskDate.isHidden = false
            cell.addButton.isHidden = true
            cell.backgroundColor = fetchedData.user?.tasks[indexPath.row - 1].getColor()
            cell.importantIndicator.image = UIImage(named: "ImportantIcon")!.alpha((fetchedData.user?.tasks[indexPath.row - 1].imp)! ? 1 : 0.3)
            cell.urgentIndicator.image = UIImage(named: "UrgentIcon")!.alpha((fetchedData.user?.tasks[indexPath.row - 1].urg)! ? 1 : 0.3)
            cell.urgentIndicator.contentMode = UIViewContentMode.scaleAspectFit
            cell.importantIndicator.contentMode = UIViewContentMode.scaleAspectFit
            cell.layer.cornerRadius = 5
            cell.taskTitle.text = fetchedData.user?.tasks[indexPath.row - 1].title
            cell.taskDate.text = fetchedData.user?.tasks[indexPath.row - 1].date
        }
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        
    }
}

