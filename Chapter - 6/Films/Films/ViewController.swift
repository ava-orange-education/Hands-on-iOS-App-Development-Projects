//
//  ViewController.swift
//  Films
//
//  Created by Aiswarya Kodali on 26/10/2023.
//

import UIKit

class ViewController: UIViewController {
    
    var cubeClosure: ((Int) -> Void)?
    var identityClosure: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var goodDayGreet = {
            print("Have a good day")
        }

        
       // goodDayGreet()
       // fetchData()
        
        var add = { (num1: Int, num2: Int) -> (Int) in
          var sum = num1 * num2
          return sum
        }
        
        cube(num: 3) { (cubeOfNum) in
            print(cubeOfNum)
        }
        
        print(cubeClosure)
        
        var findSum = add(3,2)
        
        let multipy: (Int, Int) -> Int = { (a: Int, b: Int) -> Int in
            return a * b 
        }
        
//        let multiplication = {(Int, Int) -> Int in 
//            return $0 * $1
//        }
        
        let addition: (Int, Int) -> Int  = {
            return $0 + $1
        }
        
        let square: (Int) -> (Int) = {
            print($0)
          return  $0 * $0
        }
        
        
        
        func calculate(a: Int, b: Int, calculationType: (Int, Int) -> Int) -> Int { 
            return calculationType(a, b) 
        }
        
        func findIdentitytoken(completeionHandler: @escaping (Bool) -> Void) {
            identityClosure = completeionHandler
        }
        
       // let perCal = calculate(a: 2, b: 3, calculationType: multiplication)
        
       // print("the calculation", perCal)
        
        
        
    }
    
    func cube(num:Int, clos: @escaping(Int)->Void) {
       clos(num * num * num)
       print(num * num * num) 
       cubeClosure = clos
    }
    
    
    
    func fetchData() {
        
        let url = URL(string: "https://swapi.dev/api/films/1/")!
        
        var request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                self.parseData(json: data)
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
            
        }
        task.resume()
    }
    
    
       
    func parseData(json: Data) {
        
        let decoder = JSONDecoder()
        
        if let film = try? decoder.decode(Film.self, from: json) {
            print(film.title)
            print(film.director)
        }
    }
    
    func sendCustomerDetails() {
        
        let customer = Customer(name: "Kate Hill", 
                                dateOfBirth: "23/05/1995", 
                                address: "10600 N Tantau Ave, Cupertino, CA 95014, USA")
        
        let data = try! JSONEncoder().encode(customer)
        
        let url = URL(string: "Sample URL here")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") 
        
        var goodDay = {
            print("Have a crazy wonderful day")
        }
        
        goodDay()
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            let responseCode = (response as! HTTPURLResponse).statusCode
            if responseCode == 200 {
                print("SUCCESS")
            } else {
                print("FAILURE")
            }
        }
        
        task.resume()
        
    }
    
    
    
    func fetchData123() {
        
        let url = URL(string: "https://swapi.dev/api/films/1/")!
        
        var request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print(data)
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        
        task.resume()
    }

    func parseJsonData() {
        
    }

}

struct Film: Codable {
    
    var title:String
    var episodeId: Int
    var openingcrawl: String
    var director: String
    var producer: String
    var releaseDate: String
    var characters: [String]
    var planets: [String]
    var starships: [String]
    var vehicles: [String]
    var species: [String]
    
    enum CodingKeys: String, CodingKey {
        case title
        case episodeId = "episode_id"
        case openingcrawl = "opening_crawl"
        case director
        case producer
        case releaseDate = "release_date"
        case characters
        case planets
        case starships
        case vehicles
        case species
    }

}

struct Customer: Codable{
    var name: String
    var dateOfBirth: String
    var address: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case dateOfBirth = "date_of_birth"
        case address
    }
}




