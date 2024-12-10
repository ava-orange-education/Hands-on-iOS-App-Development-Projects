//
//  ViewController.swift
//  AuthenticateUser
//
//  Created by Aish kodali on 14/4/2024.
//

import UIKit
import Auth0
import JWTDecode

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        statusLabel.isHidden = true
    }
    
    
    
    @IBAction func loginTapped(_ sender: Any)  {
        Auth0
            .webAuth()
            .useHTTPS()
            .start { result in
                switch result {
                case .success(let credentials):
                    print("Obtained credentials: \(credentials)")
                    
                    self.statusLabel.isHidden = false
                    self.statusLabel.text = "Logged in"
                    
                    //Access the user info
                    print("The jwt", credentials.idToken)
                    guard let jwt = try? decode(jwt: credentials.idToken),
                          let name = jwt["name"].string
                    else { return }
                    print("Name: \(name)")
                    
                case .failure(let error):
                    self.statusLabel.isHidden = false
                    self.statusLabel.text = "Failed with error"
                    print("Failed with: \(error)")
                }
            }
    }
    
   @IBAction func logoutTapped() {
        Auth0
            .webAuth()
            .clearSession(federated: true) { result in
                switch result {
                case .success:
                    self.statusLabel.isHidden = false
                    self.statusLabel.text = "Logged out"
                case .failure(let error):
                    self.statusLabel.isHidden = false
                    self.statusLabel.text = "Failed with error"
                    print("Failed with: \(error)")
                }
            }
    }
}

