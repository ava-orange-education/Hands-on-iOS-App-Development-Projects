//
//  ThirdViewController.swift
//  NavigationExample
//
//  Created by Aiswarya Kodali on 15/9/2023.
//

import UIKit

class ThirdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Third Screen"
    }
    
    
    
    @IBAction func thirdButtonClicked(_ sender: Any) {
        
        let fourthVc = self.storyboard?.instantiateViewController(withIdentifier: "FourthVc") as! FourthViewController
        
        self.navigationController?.pushViewController(fourthVc, animated: true)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
