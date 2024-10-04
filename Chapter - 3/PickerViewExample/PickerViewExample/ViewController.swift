//
//  ViewController.swift
//  PickerViewExample
//
//  Created by Aiswarya Kodali on 2/9/2023.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    let colours = ["Red", "Blue", "Green", "Gray"]
    let data = [["1" ,"2","3","4"], ["A", "B","C","D"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
       2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
        data[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        data[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if row == 0 {
            self.view.backgroundColor = .red
        } else if row == 1 {
            self.view.backgroundColor = .blue
        } else if row == 2 {
            self.view.backgroundColor = .green
        } else {
            self.view.backgroundColor = .gray
        }
        
    }
}

