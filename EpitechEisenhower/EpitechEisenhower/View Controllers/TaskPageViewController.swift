//
//  taskPageViewController.swift
//  EpitechEisenhower
//
//  Created by Vincent Augrain on 08/03/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//

import UIKit

class taskPageViewController: UICollectionViewController {
    
    @IBOutlet var collection: UICollectionView!
    var profileButton: UIButton!
    var allTasks: [task]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let profileImage = UIImage(named: "ProfileIcon")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(goToProfile))
        
        // test
        allTasks = [
            task(title: "test1", date: "March 12th 2017", important: true, urgent: true),
            task(title: "test2", date: "March 13th 2017", important: true, urgent: false),
            task(title: "test3", date: "March 14th 2017", important: false, urgent: true),
            task(title: "test4", date: "March 15th 2017", important: false, urgent: false)
        ]
    }
    
    @objc func goToProfile() {
        performSegue(withIdentifier: "profileSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let nextScene =  segue.destination as! taskDetailsEdit
            if let indexPath = self.collection.indexPath(for: sender as! collectionCellView) {
                print(indexPath.row)
                nextScene.ta = self.allTasks[indexPath.row]
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
        
        return allTasks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath as IndexPath) as! collectionCellView
        
        cell.backgroundColor = allTasks[indexPath.row].getColor()
        cell.importantIndicator.image = UIImage(named: "ImportantIcon")!.alpha(allTasks[indexPath.row].imp ? 1 : 0.3)
        cell.urgentIndicator.image = UIImage(named: "UrgentIcon")!.alpha(allTasks[indexPath.row].urg ? 1 : 0.3)
        cell.urgentIndicator.contentMode = UIViewContentMode.scaleAspectFit
        cell.importantIndicator.contentMode = UIViewContentMode.scaleAspectFit
        cell.layer.cornerRadius = 5
        cell.taskTitle.text = allTasks[indexPath.row].title
        cell.taskDate.text = allTasks[indexPath.row].date
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        
    }
}

