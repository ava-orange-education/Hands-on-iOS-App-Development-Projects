//
//  DetailsTableViewController.swift
//  TODO List
//
// 
//

import UIKit

class DetailsTableViewController: UITableViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar! 
    
    var datePickerView: UIDatePicker = UIDatePicker()
    var timePickerView: UIDatePicker = UIDatePicker()
    
    var todoListItem: TODOListItem?
    
    var modifiedToDoListItem: TODOListItem?
    
    @IBOutlet weak var todoItemTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    
    var detailsTableViewControllerDelgate: TODOTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // adding navigation bar
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
        tableView.addSubview(navigationBar)
        
        let navigationItem = UINavigationItem(title: "Details")
        let doneNavItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonTapped(sender:)))
        navigationItem.rightBarButtonItem = doneNavItem
        
        let cancelNavItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(doneButtonTapped(sender:)))
        navigationItem.leftBarButtonItem = cancelNavItem
        
        navigationBar.setItems([navigationItem], animated: false)
        
        datePickerView.preferredDatePickerStyle = .inline
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        dateTextField.inputView = datePickerView
        
        timePickerView.datePickerMode = .countDownTimer
        timePickerView.preferredDatePickerStyle = .wheels
        timePickerView.addTarget(self, action: #selector(handleHoursPicker(sender:)), for: .valueChanged)
        timeTextField.inputView = timePickerView
        
        todoItemTextField.delegate = self
        notesTextView.delegate = self
        dateTextField.delegate = self
        timeTextField.delegate = self
        
        if let id = todoListItem?.id {
            modifiedToDoListItem = TODOListItem(id: id)
        } else {
            modifiedToDoListItem = TODOListItem(id: 1) //new ID if it is an new item - get the array count from previous view controller
        }
        
        if todoListItem?.item != nil {
            todoItemTextField.text = todoListItem?.item
            modifiedToDoListItem?.item = todoListItem?.item
        } else {
            todoItemTextField.text = "New TodoList item"
            modifiedToDoListItem?.item = "New TodoList item"
        }
        
        if let notes = todoListItem?.notes {
            notesTextView.text = notes
            modifiedToDoListItem?.notes = notes
        } else {
            notesTextView.text = "Notes"
            notesTextView.textColor = UIColor.lightGray
        }
        
        if let date = todoListItem?.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            modifiedToDoListItem?.date = date
            dateTextField.text = dateFormatter.string(from: date)
        }
        
        
        if let time = todoListItem?.time {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            modifiedToDoListItem?.time = time
            timeTextField.text = dateFormatter.string(from: time)
        }
    }
    
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        modifiedToDoListItem?.date = sender.date
        dateTextField.text = dateFormatter.string(from: sender.date)
        
    }
    @objc func handleHoursPicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        modifiedToDoListItem?.time = sender.date
        timeTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func doneButtonTapped(sender: UIBarButtonItem) {
        view.endEditing(true)
        detailsTableViewControllerDelgate?.modifiedToDoListItem(upatedItem: modifiedToDoListItem)
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        view.endEditing(true)
        detailsTableViewControllerDelgate?.modifiedToDoListItem(upatedItem: todoListItem)
    }
    
}

// MARK: - TextField delegate

extension DetailsTableViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text: NSString = (textField.text ?? "") as NSString
        let resultString = text.replacingCharacters(in: range, with: string)
        
        if textField == todoItemTextField {
            self.modifiedToDoListItem?.item = resultString
        } 
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
    }
    
}

// MARK: - TextField delegate

extension DetailsTableViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let textViewText = textView.text ?? ""
        guard let updatedRange = Range(range, in: textViewText) else { return false }
        let resultingUpdatedText = textViewText.replacingCharacters(in: updatedRange, with: text)
        todoListItem?.notes = resultingUpdatedText
        
        return true
    }
}
