//
//  ViewSnapViewController.swift
//  Snapchat
//
//  Created by Sheng Chi Chen on 2017/5/8.
//  Copyright © 2017年 Sheng Chi Chen. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseDatabase
import FirebaseStorage

class ViewSnapViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var snap = Snap()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = snap.descrip
        imageView.sd_setImage(with: URL(string: snap.imageURL))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").child(snap.key).removeValue()
        FIRStorage.storage().reference().child("images").child("\(snap.uuid).jpg").delete { (error) in
            if error != nil{
                print(error.debugDescription)
            }else{
                print("We delete the pic")
            }
        }
        
    }
    
}
