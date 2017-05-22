//
//  SelectUserViewController.swift
//  Snapchat
//
//  Created by Sheng Chi Chen on 2017/5/7.
//  Copyright © 2017年 Sheng Chi Chen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SelectUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var users:[User] = []
    var imageURL = ""
    var descrip = ""
    var uuid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        FIRDatabase.database().reference().child("users").observe(FIRDataEventType.childAdded, with: {(snapshot) in
            print(snapshot)
            let user = User()
            user.email = (snapshot.value as! NSDictionary)["email"] as! String
            user.uid = snapshot.key
            self.users.append(user)
            self.tableView.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.email
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let snap = ["from":FIRAuth.auth()!.currentUser!.email!, "description":descrip, "imageURL":imageURL, "uuid":uuid]
        FIRDatabase.database().reference().child("users").child(user.uid).child("snaps").childByAutoId().setValue(snap)
        navigationController!.popToRootViewController(animated: true)
    }
}
