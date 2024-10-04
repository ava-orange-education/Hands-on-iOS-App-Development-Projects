//
//  TableViewController.swift
//  TODO List
//
// 
//

import UIKit

protocol TODOListDelagate {
    func detailsButtonGotClicked(cell: TODOListCell)
    func taskDoneButtonGotClicked(cell: TODOListCell)
}

protocol TODOTableViewControllerDelegate {
    func modifiedToDoListItem(upatedItem: TODOListItem?)
}

class TODOListCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var checkMarkButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var detailsButton: UIButton!
   
    var toDoListItem: TODOListItem?
    var cellDelegate: TODOListDelagate? 
    
    
    func configureCell() {
        
        checkMarkButton.layer.cornerRadius = 15
        detailsButton.layer.cornerRadius = 5
        
        checkMarkButton.backgroundColor = .clear
        textField.textColor = .black
    }
    
    @IBAction func detailsButtonTapped(_ sender: UIButton) { 
        cellDelegate?.detailsButtonGotClicked(cell: self)
    }
    
    @IBAction func taskDoneButtonClicked(_ sender: Any) {
        checkMarkButton.backgroundColor = .systemYellow
        textField.textColor = .lightGray
        cellDelegate?.taskDoneButtonGotClicked(cell: self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text: NSString = (textField.text ?? "") as NSString
        let resultString = text.replacingCharacters(in: range, with: string)
        toDoListItem?.item = resultString
        
        return true
    }
    
    
}
class TableViewController: UITableViewController, UITextFieldDelegate, TODOListDelagate, TODOTableViewControllerDelegate {
    
    var noOfRows = 0
    var toDoListItemsArray: [TODOListItem] = []
    var theToDoItemString: String?
    var selectedItem: TODOListItem?
    var cellIsEditing: Bool = false
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonTapped(sender:)))
       
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.rightBarButtonItem?.isHidden = true
        self.navigationController?.navigationBar.tintColor = .systemYellow
        
        
        let tapOnTableView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        tableView.addGestureRecognizer(tapOnTableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.endEditing(true)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        if cellIsEditing == false {
            noOfRows += 1
            tableView.reloadData()
        } else {
            cellIsEditing = false
            view.endEditing(true)
        }
        
    }
    
    @objc func doneButtonTapped(sender: UIBarButtonItem) {
        if cellIsEditing == true {
            cellIsEditing = false
            view.endEditing(true)
        } 
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath) as! TODOListCell 
        cell.textField.delegate = self
        cell.cellDelegate = self
        cell.configureCell()
       
        if indexPath.row <= toDoListItemsArray.count - 1 {
            
            // Existing item

            let todoListItem = toDoListItemsArray[indexPath.row]
            cell.textField.text = todoListItem.item
            cell.textField.endEditing(true)
           
            DispatchQueue.main.async {
                self.view.endEditing(true)
            }

            
        } else if indexPath.row == noOfRows - 1 {
            
            cell.textField.text = nil
            self.navigationItem.rightBarButtonItem?.isHidden = false
            
            // making the new item as selected item
            let id: Int = toDoListItemsArray.count + 1
            let todoListItem = TODOListItem(id: id)
            selectedItem = todoListItem
            DispatchQueue.main.async {
                cell.textField.becomeFirstResponder()
            }
            
        }
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row selected")
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         true 
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.tableView.beginUpdates()
            self.toDoListItemsArray.remove(at: indexPath.row)
            noOfRows -= 1
            self.tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            self.tableView.endUpdates()
        }
        
    }
    
    // MARK: - TextField delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxStringCount = 25
        let textFieldtext: NSString = (textField.text ?? "") as NSString
        let endToDOString = textFieldtext.replacingCharacters(in: range, with: string)
        print("the end string is", endToDOString)
        
        theToDoItemString = endToDOString
        selectedItem?.item = theToDoItemString
        cellIsEditing = true
        
        if textField.text?.count != 0 {
                        
            if let itemIntheArray = toDoListItemsArray.first(where: { $0.item == textField.text}) {
                print("the item is", itemIntheArray)

                var editingItem = itemIntheArray
                editingItem.item = theToDoItemString
                //array = array.map { $0.eventID == id ? newValue : $0 }
                toDoListItemsArray = toDoListItemsArray.map { $0.item == textField.text ? editingItem : $0 }
                print("the array",toDoListItemsArray)
            } 
           
        }
        
        return endToDOString.count <= maxStringCount
    }
    
    func detailsButtonGotClicked(cell: TODOListCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            print("the indexpath", indexPath.row)
            if indexPath.row <= toDoListItemsArray.count - 1 {
                
                selectedItem = toDoListItemsArray[indexPath.row]
            }
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let secondVc = storyboard.instantiateViewController(withIdentifier: "DetailsTableViewController") as! DetailsTableViewController
            secondVc.detailsTableViewControllerDelgate = self
            if let toDoListItem = selectedItem {
                secondVc.todoListItem = toDoListItem
            }
            self.view.resignFirstResponder()
            self.navigationController?.present(secondVc, animated: true)
        }
    }
    
    
    func taskDoneButtonGotClicked(cell: TODOListCell) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { 
            if let indexPath = self.tableView.indexPath(for: cell) {
                if indexPath.row == self.toDoListItemsArray.count - 1 {
                    self.tableView.beginUpdates()
                    self.toDoListItemsArray.remove(at: indexPath.row)
                    self.noOfRows -= 1
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.tableView.endUpdates()
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.navigationItem.rightBarButtonItem?.isHidden = false
        cellIsEditing = true
    }
    
    func modifiedToDoListItem(upatedItem: TODOListItem?) {
        print(upatedItem?.item)
        
        if let updatedToDoListItem = upatedItem {
            
            // if item exist in the array then modify it
            if let itemIntheArray = toDoListItemsArray.first(where: { $0.id == updatedToDoListItem.id }) {
                toDoListItemsArray = toDoListItemsArray.map { $0.id == updatedToDoListItem.id ? updatedToDoListItem : $0 }
            } else {
                // if item doesnot exist in the array then add it to the array
                toDoListItemsArray.append(updatedToDoListItem)
                print(toDoListItemsArray.count)
                selectedItem = nil
                noOfRows = toDoListItemsArray.count
                self.tableView.reloadData()
            }
           
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        if selectedItem?.item != nil {
            if let itemIntheArray = toDoListItemsArray.first(where: { $0.item == textField.text}) {
                toDoListItemsArray = toDoListItemsArray.map { $0.item == theToDoItemString ? itemIntheArray : $0 }
                print("the array",toDoListItemsArray)
            } else {
                if let theNewItem = selectedItem {
                    toDoListItemsArray.append(theNewItem)
                    selectedItem = nil
                }
            }
        } 
        self.navigationItem.rightBarButtonItem?.isHidden = true
    }
    
}
