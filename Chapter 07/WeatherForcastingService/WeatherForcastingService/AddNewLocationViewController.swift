//
//  AddNewLocationViewController.swift
//  WeatherForcastingService
//
//  
//

import UIKit
import CoreLocation
import WeatherKit

class AddNewLocationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var submitLocationButton: UIButton!
    
    @IBOutlet weak var weatherDetailView: UIView!
    
    @IBOutlet weak var locationName: UILabel!
    
    @IBOutlet weak var weatherCondition: UILabel!
    
    @IBOutlet weak var weatherTemp: UILabel!
    
    @IBOutlet weak var addToTheListButton: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var weatherKitManager = WeatherForecastingManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        spinner.isHidden = true
        weatherDetailView.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.locationTextField.delegate = self
        self.locationTextField.clearButtonMode = .whileEditing
    }
    

    @IBAction func submitLocation(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        
        if let locationEntered = locationTextField.text {
            
            // coverting the name to coords
            getCoords(from: locationEntered) { [self] coord in
                
                Task { 
                    if let coordinates = coord {
                        await self.weatherKitManager.getWeather(for: coordinates.latitude, longitude: coordinates.longitude)
                        self.spinner.stopAnimating()
                        self.weatherDetailView.isHidden = false
                        self.spinner.hidesWhenStopped = true
                        self.locationName.text = locationEntered
                        self.weatherCondition.text = weatherKitManager.condition
                        self.weatherTemp.text = weatherKitManager.temp
                    } else {
                        // Alertview 
                        let alert = UIAlertController(title: "Error", message: "Something Went Wrong", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
        
    }
    
    
    @IBAction func addLocationToTheList(_ sender: Any) {
        
        // popping to list vc with new location data
        let weatherListViewController = self.navigationController?.viewControllers[0] as? WeatherListTableViewController
        weatherListViewController?.newlyAddedLocationName = locationName.text
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func getCoords(from place:String, completion: @escaping (CLLocationCoordinate2D?) -> ()) {
        
        let geocoder = CLGeocoder()
        var coord: CLLocationCoordinate2D?
        
        geocoder.geocodeAddressString(place) { placemarks, error in
            
            guard error == nil else {
                          print("*** Error in \(#function): \(error!.localizedDescription)")
                          return
                      }
            
            guard let placemark = placemarks?[0] else {
                            print("*** Error in \(#function): placemark is nil")
                            return
                        }
            
            coord = placemark.location?.coordinate ?? CLLocationCoordinate2D(latitude:
                                                                                CLLocationDegrees(0), longitude: CLLocationDegrees(0)) 
            completion(coord)
        }
    }

}

extension AddNewLocationViewController {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[A-Za-z].*", options: [])
            if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
                return true
            }
        }
        catch {
            print("ERROR")
        }
        return false
    }
}
