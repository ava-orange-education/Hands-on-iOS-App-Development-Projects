//
//  ViewController.swift
//  TextFieldExample
//
//
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var aboutMeTextView: UITextView!
    
    var username: String?
    var email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextfield.delegate = self
        emailTextField.delegate = self
        
        aboutMeTextView.delegate = self
        
        aboutMeTextView.layer.borderWidth = 0.2
        aboutMeTextView.layer.borderColor = UIColor.gray.cgColor
        aboutMeTextView.layer.cornerRadius = 5.0
        
        
        emailTextField.keyboardType = .numberPad
 
        
        nameTextfield.becomeFirstResponder()
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        let textFieldText = (textField.text ?? "") as NSString
        let wholeString = textFieldText.replacingCharacters(in: range, with: string)
        print(wholeString)
        
        if textField == nameTextfield {
            username = wholeString
        } else if textField == emailTextField {
            email = wholeString
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          return true
      }
    
    func textViewDidChange(_ textView: UITextView) {
        
        print(textView.text ?? "jhk")
    }

    

}

