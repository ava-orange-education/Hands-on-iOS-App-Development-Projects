//
//  ViewController.swift
//  TableViewExample
//


import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    let progLanguages = ["Ruby", "Python", "Rust", "Swift", "Kotlin", "Java", "Objective – c", "JavaScript", "C", "SQL", "Ruby", "Python", "Rust", "Swift", "Kotlin", "Java", "Objective – c", "JavaScript", "C", "SQL" ] //pearl
    
    let progLangsDict = ["Ruby" : "Ruby is used for building web servers and websites.Can be also used for data processing, automation tools and devOps. ",
                         "Python" : "Python is wonderful for building the IoT applications, software applications and used in data visualisation and in data analysis.",
                         "Rust" : "Rust used to for building operating systems, games and data mining applications.", 
                         "Swift" : "Swift is used for building iOS, Mac, Apple watch and Apple TV applications.", 
                         "Kotlin" : "Kotlin is used for building Android applications, client-side web apps and server-side applications.", 
                         "Java" : "Java is used for building software applications, server-side applications and also mobile applications.",
                         "Objective – c" : "Objective c is used for building applications for iOS and macOS platforms",
                         "JavaScript" : "Javascript is used for building interactive and dynamic web applications.", 
                         "C" : "C is used for building for operating systems, complicated applications, gaming applications and data mining applications.", 
                         "SQL" : "SQL is used for fetching data from databases and for manipulating databases.", 
                         "Pearl" : "Pearl can be used in building graphical user interface development, web development and used for common interface gateway scripts."]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let tableViewFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width-5 , height: 150))
        
        let titleLabel = UILabel(frame: CGRect(x:10,y: 5 ,width:tableViewFooterView.frame.width,height:150))
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
        titleLabel.text  = "The above programming languages are really useful to build awesome applications, websites and wonderful software products."
        tableViewFooterView.addSubview(titleLabel)
        
        tableView.tableFooterView = tableViewFooterView
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        progLanguages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell.init()
    
        var contentConfig = cell.defaultContentConfiguration()
        contentConfig.text =  progLanguages[indexPath.row]
        cell.contentConfiguration = contentConfig
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 5, width: headerView.frame.width , height: headerView.frame.height )
        label.text = "Programming Languages"
        label.font = .systemFont(ofSize: 21, weight: .bold)
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        50.0
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let key = progLanguages[indexPath.row]
        
        let value = progLangsDict[key]
        
        let alert = UIAlertController(title: key, message: value, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        self.present(alert, animated: true, completion: nil)
        
    }
    
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        
//        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
//        footerView.backgroundColor = .gray
//        return footerView
//    }
//    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        50.0
//    }


    
    
    
}



