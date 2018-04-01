//
//  ModalSearchView.swift
//  EpitechEisenhower
//
//  Created by Vincent Augrain on 25/03/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//

import UIKit

class ModalSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var profiles = [
        profile(fn: "Yohan", ln: "Paupardin", pic: UIImage(named: "yohan")!, email: "noisette@gmail.com"),
        profile(fn: "Théo-Paul", ln: "Bodin", pic: UIImage(named: "yohan")!, email: "noisette@gmail.com"),
        profile(fn: "Tony", ln: "Truong", pic: UIImage(named: "yohan")!, email: "noisette@gmail.com"),
        profile(fn: "Walid", ln: "Essiaki", pic: UIImage(named: "yohan")!, email: "noisette@gmail.com"),
        profile(fn: "Adrien", ln: "Seguin", pic: UIImage(named: "yohan")!, email: "noisette@gmail.com")
    ]
    var filtredProfiles = [profile]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.clear
        filtredProfiles = profiles
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !((searchBar.text?.isEmpty)!) else { filtredProfiles = profiles; tableView.reloadData(); return }
        filtredProfiles = profiles.filter({ profile -> Bool in
            guard let text = searchBar.text?.lowercased() else { return false }
            return profile.firstName.lowercased().contains(text) || profile.lastName.lowercased().contains(text)
        })
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        cell.profileImage.image = filtredProfiles[indexPath.row].pic
        cell.profileTitle.text = filtredProfiles[indexPath.row].firstName + " " + filtredProfiles[indexPath.row].lastName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtredProfiles.count
    }
    
}
