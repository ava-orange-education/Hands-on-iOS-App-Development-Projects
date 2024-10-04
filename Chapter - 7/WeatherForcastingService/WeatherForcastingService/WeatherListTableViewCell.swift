//
//  WeatherListTableViewCell.swift
//  WeatherForcastingService
//


import UIKit

class WeatherListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var weatherCondition: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBInspectable
    var borderWidth: CGFloat {
        
        get {
            return layer.borderWidth
        }
        
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        
        get {
            
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        
        set {
            
            if let color = newValue {
                layer.borderColor = color.cgColor
                
            } else {
                layer.borderColor = nil
            }
        }
    }
}


