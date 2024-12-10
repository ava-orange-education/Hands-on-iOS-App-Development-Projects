//
//  ViewController.swift
//  SaveUserData
//
//
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
        
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    var userName: String = ""
    var userAge: Int = 0
    var userCity: String = ""
    
    var dbUtility: DatabaseUtility = DatabaseUtility()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        self.nameTextField.delegate = self
        self.ageTextField.delegate = self
        self.addressTextField.delegate = self
        
        userImageView.layer.masksToBounds = true
        userImageView.layer.borderWidth = 0.7
        userImageView.layer.borderColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0).cgColor
        userImageView.layer.cornerRadius = 10
        
        userImageView.layer.borderColor

        
        let tapGuestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageViewTapped(_:)))
        self.userImageView.isUserInteractionEnabled = true
        self.userImageView.addGestureRecognizer(tapGuestureRecognizer)
    }
    
    @IBAction func submitUserDetails(_ sender: Any)  {
        
        let user = User(userID: 0, userName: userName, age: userAge, city: userCity)
        dbUtility.insert(user: user)
        
        nameTextField.text = ""
        ageTextField.text = ""
        addressTextField.text = ""
        userImageView.image = nil
        userImageView.setNeedsDisplay()
        
        let userDataBase = DatabaseUtility()
        let usersFromDatabase = userDataBase.read()
        
        let users = usersFromDatabase
        print("users count \(users.count)")
        
    }
    
 @objc func imageViewTapped(_ sender: UITapGestureRecognizer) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // UITextFieldDelegate methods
     
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let updatedString = textFieldText.replacingCharacters(in: range, with: string)
        
        if textField == nameTextField {
            userName = updatedString
        } else if textField == ageTextField {
            userAge = Int(updatedString) ?? 0
        } else if textField == addressTextField {
            userCity = updatedString
        }
        
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getTheAWSBucket() {
        Task {
            do {
                let util = AWSUtility()
                let names = try await util.getS3BucketNames()
                
                print("Found \(names.count) buckets:")
                for name in names {
                    print("  \(name)")
                }
            } catch  {
                print("An Amazon S3 service error occurrede")
            }
        }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userImageView.image = image
            
            let userDataBase = DatabaseUtility()
            let usersFromDatabase = userDataBase.read()
            let usersCount = usersFromDatabase.count
            
            let userIDKey = userName + String(usersCount + 1)
            
            Task {
                do {
                    let util = AWSUtility()
                    //convert the image to the Data
                    if  let data = image.pngData() {
                        
                        try await util.uploadImage(key: userIDKey, withData: data )
                    }
                    
                } catch  {
                    print("An AWS S3 service error ")
                }
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func getImage(_ sender: Any) {
        Task {
           
            let util = AWSUtility()
            if let userImage = try await util.getImage(with: "Lakku2") {
                
                print("got the image")
            }
        }
    }
    
    
    
    
}

