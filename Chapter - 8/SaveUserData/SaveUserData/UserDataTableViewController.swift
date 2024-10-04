//
//  UserDataTableViewController.swift
//  SaveUserData
//
//
//

import UIKit

class UserDataTableViewController: UITableViewController {
    
    var users: [User] = []
    var imagesArray: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDataBase = DatabaseUtility()
        let usersFromDatabase = userDataBase.read()
        users = usersFromDatabase
        print("users count \(users.count)")
        
        sleep(4)
        tableView.reloadData()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserDataTableViewCell", for: indexPath) as! UserDataTableViewCell
        
        let user = users[indexPath.row]
        
        cell.userImageView.layer.borderWidth = 0.5
        cell.userImageView.layer.borderColor =  UIColor.black.cgColor
        cell.userImageView.contentMode = .scaleToFill
        cell.userImageView.layer.cornerRadius = 5.0
        cell.userImageView.clipsToBounds = true
        
        Task {
            do {
                let awsUtil = AWSUtility()
                let key = user.userName + String(indexPath.row + 1)
                if let userImage = try await awsUtil.getImage(with: key) {
                    cell.userImageView.image = userImage
                    
                }
            } catch {
                print("An Amazon S3 error")
            }
        }
        
        cell.name.text = user.userName
        cell.age.text = String(user.age)
        cell.city.text = user.city
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100.0
    }

}
