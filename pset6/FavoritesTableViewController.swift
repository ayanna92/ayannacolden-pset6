//
//  FavoritesTableViewController.swift
//  pset6
//
//  Created by Ayanna Colden on 10/12/2016.
//  Copyright © 2016 Ayanna Colden. All rights reserved.
//

import UIKit
import Firebase

class FavoritesTableViewController: UITableViewController {
    
    
    var ref: FIRDatabaseReference?
    let user = FIRAuth.auth()?.currentUser?.uid
    
    var wineName = String()
    var wineNameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wineNameArray.insert(wineName, at: 0)
        
        // Read wine name from Firebase and display in tableview.
        ref = FIRDatabase.database().reference()
        
        ref?.child("Users").child("Favorites").child(self.user!).observeSingleEvent(of: .value, with: {(snapshot) in
            
            let dictionary = snapshot.value as? NSDictionary
            if dictionary != nil {
                self.wineNameArray = dictionary?.allKeys as! [String]
            }
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Tableview
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return wineNameArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "favoritesToSearch", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell", for: indexPath) as! FavoritesTableViewCell

        cell.nameLabel.text = wineNameArray[indexPath.row]

        return cell
    }
    
    // Override to support deleting from tableview.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            let deleteName = self.wineNameArray[indexPath.row]
            self.wineNameArray.remove(at: indexPath.row)
            
            ref?.child("Users").child("Favorites").child(self.user!).child(deleteName).removeValue()
            
            self.tableView.reloadData()
        }
    }
    
    func myDeleteFunction(firstTree: String, secondTree: String, thirdTree: String, childIWantToRemove: String) {
        
        let user =  FIRAuth.auth()?.currentUser?.uid
        
        ref?.child(user!).child(firstTree).child(secondTree).child(thirdTree).child(childIWantToRemove).removeValue { (error, ref) in
                if error != nil {
                    print("error \(error)")
                }
                else{
                    print ("removed")
                }
            }
    }
}
