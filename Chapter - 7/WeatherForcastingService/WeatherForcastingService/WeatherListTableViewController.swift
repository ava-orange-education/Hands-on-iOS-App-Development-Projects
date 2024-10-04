//
//  WeatherListTableViewController.swift
//  WeatherForcastingService
//
//  
//

import UIKit
import CoreLocation
import WeatherKit
import MapKit

class WeatherListTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var weatherKitManager = WeatherForecastingManager()
    var weatherLocationListArray : [LocationItem] = []
    var newlyAddedLocationName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        locationManager?.requestWhenInUseAuthorization()
        
        locationManager?.requestLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if let newLocation = self.newlyAddedLocationName {
            var newLocationItem = LocationItem()
            newLocationItem.locationName = newLocation
            
            getCoords(from: newLocation) { coords in
                newLocationItem.coord = coords
                self.weatherLocationListArray.append(newLocationItem)
                self.tableView.reloadData()
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if weatherLocationListArray.count == 0 {
            return 2
        } else {
            return weatherLocationListArray.count + 1
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherListTableViewCell", for: indexPath) as! WeatherListTableViewCell
            cell.spinner.hidesWhenStopped = true
            cell.spinner.startAnimating()
            self.locationManager?.requestLocation()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                let currentLocationItem = self.weatherLocationListArray[0]
                
                cell.locationName.text = currentLocationItem.locationName 
                
                if let lat = currentLocationItem.coord?.latitude, let long = currentLocationItem.coord?.longitude {
                    
                    Task {
                        await self.weatherKitManager.getWeather(for: lat, longitude: long)
                        cell.temperature.text = self.weatherKitManager.temp
                        cell.weatherCondition.text = self.weatherKitManager.condition
                        cell.spinner.stopAnimating()
                        
                    }
                } else {
                    cell.temperature.text = "Nil"
                    cell.weatherCondition.text = "Nil"
                    cell.spinner.stopAnimating()
                }
            }
            
            return cell
            
        }  else if (weatherLocationListArray.count == 0 && indexPath.row == 1) || indexPath.row == weatherLocationListArray.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddLocationTableViewCell", for: indexPath) as! AddLocationTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherListTableViewCell", for: indexPath) as! WeatherListTableViewCell
            cell.spinner.hidesWhenStopped = true
            cell.spinner.startAnimating()
            let locationItem = weatherLocationListArray[indexPath.row]
            cell.locationName.text = locationItem.locationName
            
            if let lat = locationItem.coord?.latitude, let long = locationItem.coord?.longitude {
                
                Task {
                    await weatherKitManager.getWeather(for: lat, longitude: long)
                    cell.temperature.text = weatherKitManager.temp
                    cell.weatherCondition.text = weatherKitManager.condition
                    cell.spinner.stopAnimating()
                }
            }
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        110
    }
}

extension WeatherListTableViewController {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("Have not yet determine the location")
        case .restricted:
            print("User's location is restricted")
        case .denied:
            print("User denied to share the location")
        case .authorizedWhenInUse:
            print("User have selected Allow While Using App or Allow Once")
            
            locationManager?.requestLocation()
            
        case .authorizedAlways:
            print("When user select option Change to Always Allow")
            
            locationManager?.requestAlwaysAuthorization()
            
        default:
            print("default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
        
        var currentLocationItem = LocationItem()
        currentLocationItem.coord = location.coordinate
       
        getPlace(from: location.coordinate) { cityName in
            currentLocationItem.locationName = cityName
            
            if self.weatherLocationListArray.count >= 1 {
                self.weatherLocationListArray[0] = currentLocationItem
            } else {
                self.weatherLocationListArray.append(currentLocationItem)
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager?.stopUpdatingLocation()
        
        if let clErr = error as? CLError {
            switch clErr.code {
            case .locationUnknown, .denied, .network:
                print("Location request failed with error: \(clErr.localizedDescription)")
            case .headingFailure:
                print("Heading request failed with error: \(clErr.localizedDescription)")
            case .rangingUnavailable, .rangingFailure:
                print("Ranging request failed with error: \(clErr.localizedDescription)")
            case .regionMonitoringDenied, .regionMonitoringFailure, .regionMonitoringSetupDelayed, .regionMonitoringResponseDelayed:
                print("Region monitoring request failed with error: \(clErr.localizedDescription)")
            default:
                print("Unknown location manager error: \(clErr.localizedDescription)")
            }
        } else {
            print("Unknown error occurred while handling location manager error: \(error.localizedDescription)")
        }
    }
    
}


// converting the Coords to place and place to coords
extension WeatherListTableViewController {
    
    func getCoord(from place: String) -> CLLocationCoordinate2D {
        
        let geocoder = CLGeocoder()
        
        var coordinate = CLLocationCoordinate2D()
        
        geocoder.geocodeAddressString("Hyderabad") { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                return
            }
            
            let coord = placemark.location?.coordinate ?? CLLocationCoordinate2D(latitude:
                                                                                    CLLocationDegrees(0), longitude: CLLocationDegrees(0))
            coordinate = coord
            
        }
        
        return coordinate        
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
    
    func getPlace(from coord: CLLocationCoordinate2D, handler:@escaping(_ cityName: String)-> Void) {
        
        let lat = coord.latitude
        let long = coord.longitude
        
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: lat, longitude: long)) { placemarks, error in
            
            if let placemark = placemarks?.first {
                handler(placemark.locality ?? "No place found")
            }
        }
    }
    
}

struct GeoLocation {
    let name: String
    let streetName: String
    let city: String
    let state: String
    let zipCode: String
    let country: String
    init(with placemark: CLPlacemark) {
        self.name           = placemark.name ?? ""
        self.streetName     = placemark.thoroughfare ?? ""
        self.city           = placemark.locality ?? ""
        self.state          = placemark.administrativeArea ?? ""
        self.zipCode        = placemark.postalCode ?? ""
        self.country        = placemark.country ?? ""
    }
    
}
