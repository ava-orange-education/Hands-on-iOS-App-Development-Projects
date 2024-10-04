//
//  ViewController.swift
//  ButtonExample
//
//  
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
        longPressGR.minimumPressDuration = 0.5
        longPressGR.delaysTouchesBegan = true
        
        button.addGestureRecognizer(longPressGR)
        
    }
    
    
    @IBAction func buttonAction(_ sender: Any) {
        
        button.backgroundColor = .lightGray
    }
    
    @objc func longPressAction() {
        
        button.backgroundColor = .red
    }
    

}

