//
//  WeatherForecastingManager.swift
//  WeatherForecast
//
// 
//

import Foundation
import WeatherKit
import CoreLocation

class WeatherForecastingManager: ObservableObject { 
    
    @Published var weather: Weather?
    
    
    var temp: String {
        
            let temp = weather?.currentWeather.temperature
            
           if let convertedTemp = temp?.converted(to: .fahrenheit) {
               
               let numFormatter = NumberFormatter()
               numFormatter.maximumFractionDigits = 2
               let measureFormatter = MeasurementFormatter()
               measureFormatter.numberFormatter = numFormatter
               let fah = measureFormatter.string(from: convertedTemp)
               return fah
              
           }
            return "Not found"
        }
    
    var condition: String {
        let condition = weather?.currentWeather.condition
        return condition?.description ?? "Not Found"
    }
    
    func getWeather(for latitude: CLLocationDegrees, longitude: CLLocationDegrees) async {
          do {
              weather = try await Task.detached(priority: .userInitiated) {
                  return try await WeatherService.shared.weather(for: .init(latitude: latitude, longitude: longitude))
              }.value
          } catch {
              fatalError("\(error)")
          }
      }
}
