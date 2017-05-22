//
//  PictureViewController.swift
//  Snapchat
//
//  Created by Sheng Chi Chen on 2017/5/7.
//  Copyright © 2017年 Sheng Chi Chen. All rights reserved.
//

import UIKit
import FirebaseStorage

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    var uuid = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        nextButton.isEnabled = false
        descriptionTextField.delegate = self
    }
    
    @IBAction func photos(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func camera(_ sender: Any) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        nextButton.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func next(_ sender: Any) {
        nextButton.isEnabled = false
        let imagesFolder = FIRStorage.storage().reference().child("images")
        let imagesData = UIImageJPEGRepresentation(imageView.image!, 0.1)!
        
        imagesFolder.child("\(uuid).jpg").put(imagesData, metadata: nil, completion: {(metadata, error) in
            print("We tried to upload!")
            if error != nil{
                print(error.debugDescription)
            }else{
                print(metadata!.downloadURL()!)
                self.performSegue(withIdentifier: "selectUsersegue", sender: metadata!.downloadURL()!.absoluteString)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! SelectUserViewController
        nextVC.imageURL = sender as! String
        nextVC.descrip = descriptionTextField.text!
        nextVC.uuid = uuid
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
