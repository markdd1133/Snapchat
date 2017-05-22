//
//  SignInViewController.swift
//  Snapchat
//
//  Created by Sheng Chi Chen on 2017/5/6.
//  Copyright © 2017年 Sheng Chi Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class SignInViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func turnUp(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            print("We tried to sign in")
            if error != nil{
                print(error.debugDescription)
                FIRAuth.auth()?.createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                    print("We tried to create a user")
                    if error != nil{
                        print(error.debugDescription)
                    }else{
                        print("Created User successfully!")
                        let users = FIRDatabase.database().reference().child("users")
                        users.child(user!.uid).child("email").setValue(user!.email!)
                        self.performSegue(withIdentifier: "signInSegue", sender: nil)
                    }
                })
            }else{
                print("Signed in Successfully")
                self.performSegue(withIdentifier: "signInSegue", sender: nil)
            }
        })
    }
    
    //Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //Presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

