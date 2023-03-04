//
//  NewTodoViewController.swift
//  GetItDone
//
//  Created by Murad Ismayilov on 22.02.23.
//

import UIKit

/// The AnyObject keyword identifies that we want the NewTodoViewControllerDelegate protocol to be limited to all class types.
protocol NewTodoViewControllerDelegate: AnyObject {
    func newTodoViewController(didFinishAdding item: ToDo)
    func newTodoViewController(didFinishEditing item: ToDo)
}

class NewTodoViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // Delegates are usually declared as being weak
    weak var delegate: NewTodoViewControllerDelegate?
    
    var todoEdit: ToDo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let todo = todoEdit {
            title = "Edit Todo"
            textField.text = todo.text
            doneBarButton.isEnabled = true
            
            shouldRemindSwitch.isOn = todo.shouldRemind
            datePicker.date = todo.dueDate
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func done(_ sender: Any) {
        if let item = todoEdit {
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            item.scheduleNotification()
            
            
            
            delegate?.newTodoViewController(didFinishEditing: item)
        } else {
            let item = ToDo()
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            item.scheduleNotification()
            delegate?.newTodoViewController(didFinishAdding: item)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        // NS = Next Step = Objective-C
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(
            in: stringRange,
            with: string)
        
        doneBarButton.isEnabled = !newText.isEmpty
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
    
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
      textField.resignFirstResponder()

      if switchControl.isOn {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) {_, _ in
          // do nothing
        }
      }
    }
}

// MARK: - If the keyboard does not appear in the Simulator, press ⌘K or use the I/O ▸ Keyboard ▸ Toggle Software Keyboard menu option. You can also use your normal Mac keyboard to type into the text field, even if the on-screen keyboard is not visible. If that doesn't work, also select I/O ▸ Keyboard ▸ Connect Hardware Keyboard from the menu.

// MARK: - @IBAction methods never return a value

// MARK: - Compare files: Xcode ▸ Open Developer Tool ▸ FileMerge
