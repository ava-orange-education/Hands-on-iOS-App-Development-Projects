//
//  SecondViewController.swift
//  NavigationExample
//
//  Created by Aish Kodali on 12/9/2023.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Second Screen"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func secondVCButtonClicked(_ sender: Any) {
        
        let thirdVc = self.storyboard?.instantiateViewController(withIdentifier: "ThirdVC") as! ThirdViewController
        
        self.navigationController?.pushViewController(thirdVc, animated: true)
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
