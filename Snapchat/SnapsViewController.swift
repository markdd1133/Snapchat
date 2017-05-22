//
//  SnapsViewController.swift
//  Snapchat
//
//  Created by Sheng Chi Chen on 2017/5/7.
//  Copyright © 2017年 Sheng Chi Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Alamofire

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var snaps:[Snap] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").observe(FIRDataEventType.childAdded, with: {(snapshot) in
            print(snapshot)
            let snap = Snap()
            snap.imageURL = (snapshot.value as! NSDictionary)["imageURL"] as! String
            snap.descrip = (snapshot.value as! NSDictionary)["description"] as! String
            snap.from = (snapshot.value as! NSDictionary)["from"] as! String
            snap.key = snapshot.key
            snap.uuid = (snapshot.value as! NSDictionary)["uuid"] as! String
            self.snaps.append(snap)
            self.tableView.reloadData()
        })
        
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").observe(FIRDataEventType.childRemoved, with: {(snapshot) in
            print(snapshot)
            var index = 0
            for snap in self.snaps{
                if snap.key == snapshot.key{
                    self.snaps.remove(at: index)
                }
                index += 1
            }
            self.tableView.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if snaps.count == 0{
            return 1
        }else{
            return snaps.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if snaps.count == 0{
            cell.textLabel?.text = "You have no snaps 😞"
        }else{
            let snap = snaps[indexPath.row]
            cell.textLabel?.text = snap.from
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if snaps.count == 0{
            return
        }else{
            let snap = snaps[indexPath.row]
            performSegue(withIdentifier: "viewsnapsegue", sender: snap)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewsnapsegue"{
            let nextVC = segue.destination as! ViewSnapViewController
            nextVC.snap = sender as! Snap
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
