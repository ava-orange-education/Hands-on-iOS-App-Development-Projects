//
//  ViewController.swift
//  NavigationExample
//
// 
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "First Screen"
    }


    @IBAction func buttonClicked(_ sender: Any) {
        
        let secondVc = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        self.navigationController?.pushViewController(secondVc, animated: true)
    }
    
    
}

