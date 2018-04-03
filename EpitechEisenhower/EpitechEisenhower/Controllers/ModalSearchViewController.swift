//
//  ModalSearchView.swift
//  EpitechEisenhower
//
//  Created by Vincent Augrain on 25/03/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//

import UIKit
import Firebase

class ModalSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var myProtocol : addProfileDelegate?
    
    var filtredProfiles = [profile]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadAllProfiles {
            self.filtredProfiles = fetchedData.allProfiles
            self.tableView.reloadData()
        }
        tableView.backgroundColor = UIColor.clear
    }
    
    func loadAllProfiles(completion: @escaping(()->())) {
        let usersRef = Database.database().reference().child(Values.firebaseObjson.USERS)
        fetchedData.allProfiles = [profile]()
        usersRef.observe(.value) { data in
            if let mainDict = data.value as? [String:Any] {
                for key in mainDict.keys {
                    guard let subdict = mainDict[key] as? [String:Any] else {print("Error loadAllProfiles for subdict"); return}
                    guard let fetchedProfile = profile.firObjToProfile(uid: key, sub: subdict) else {print("Error loadAllProfiles for fetchedProfile");  return}
                    fetchedData.allProfiles.append(fetchedProfile)
                }
                completion()
            }
            else {
                print("Error cannot retieve the users dictionnary")
                return
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !((searchBar.text?.isEmpty)!) else { filtredProfiles = fetchedData.allProfiles; tableView.reloadData(); return }
        filtredProfiles = fetchedData.allProfiles.filter({ profile -> Bool in
            guard let text = searchBar.text?.lowercased() else { return false }
            return profile.name.lowercased().contains(text)
        })
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myProtocol?.updateAddedProfile(profile: filtredProfiles[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        if ( filtredProfiles[indexPath.row].pic != nil)
        {
            cell.profileImage.image = filtredProfiles[indexPath.row].pic
        }
        else {
            cell.profileImage.imageFromServerURL(urlString: filtredProfiles[indexPath.row].picUrl) {
                fetchedData.allProfiles[indexPath.row].pic = cell.profileImage.image
            }
        }
        cell.profileTitle.text = filtredProfiles[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtredProfiles.count
    }
    
}

protocol addProfileDelegate {
    func updateAddedProfile(profile: profile)
}
