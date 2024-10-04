//
//  DatabaseUtility.swift
//  SaveUserData
//
//
//

import Foundation
import SQLite3

class DatabaseUtility {
    
    let userDatabase: String = "userDb.sqlite"
    var dbOpaquePointer:OpaquePointer?
    
    init() {
        openUserDatabase()
        createUserTable()
    }

    func openUserDatabase()
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(userDatabase)
        if sqlite3_open(fileURL.path, &dbOpaquePointer) != SQLITE_OK
        {
            print("Unable to open the database")
            
        }
        else
        {
            print("Successfully connected to the database")
            
        }
    }
    
    func createUserTable() {
        let createtabStr = "CREATE TABLE IF NOT EXISTS user(Id INTEGER PRIMARY KEY,name TEXT,age INTEGER,city TEXT);"
        var createTabStmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(dbOpaquePointer, createtabStr, -1, &createTabStmt, nil) == SQLITE_OK
        {
            if sqlite3_step(createTabStmt) == SQLITE_DONE
            {
                print("User table created.")
            } else {
                print("Error creating user table.")
            }
        } else {
            print("CREATE statement can't be prepared.")
        }
        sqlite3_finalize(createTabStmt)
    }
    
   // func to insert user data into the user table
    func insert(user: User) {
        let insertStatementString = "INSERT INTO user (id, name, age, city) VALUES (NULL, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(dbOpaquePointer, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            let name: NSString = user.userName as NSString
            let age: Int32 = Int32(user.age)
            let city: NSString = user.city as NSString
            sqlite3_bind_text(insertStatement, 1, name.utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 2, age)
            sqlite3_bind_text(insertStatement, 3, city.utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row with name - \(name), age - \(age) and city - \(city).")
                
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    
    func read() -> [User] {
        let queryStatementString = "SELECT * FROM user;"
        var queryStatement: OpaquePointer? = nil
        var users : [User] = []
        if sqlite3_prepare_v2(dbOpaquePointer, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let age = sqlite3_column_int(queryStatement, 2)
                let city = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                
                users.append(User(userID: Int(id), userName: name, age: Int(age), city: city))
                print("Query Result:")
                print("\(name)) | \(age) | \(city)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return users
    }
    
    func deleteByID(id: Int) {
        let deleteStatementStirng = "DELETE FROM user WHERE id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(dbOpaquePointer, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted user .")
            } else {
                print("Could not delete user.")
            }
        } else {
            print("Can't prepare DELETE statement.")
        }
        sqlite3_finalize(deleteStatement)
    }
    
}
