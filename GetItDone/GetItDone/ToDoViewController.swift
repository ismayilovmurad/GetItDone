//
//  ViewController.swift
//  GetItDone
//
//  Created by Murad Ismayilov on 22.02.23.
//

import UIKit

class ToDoViewController: UITableViewController, NewTodoViewControllerDelegate {
    
    /// The data model which holds the todo list and handles saving and loading
    var dataModel: DataModel!
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /// Open Finder, press ⌘+Shift+G — or, select Go ▸ Go to Folder… from the menu, don’t include the file://
        /// Press ⌘+↑ to navigate one level up in Finder, or select Go ▸ Enclosing Folder menu option
        /// If you can't see the Library folder, hold down the Alt/Option key and click on Finder’s Go menu, or hold down the Alt key while the Go menu is open.
        //print("The Documents folder is \(dataModel.documentsDirectory())")
        //print("The Data file path is \(dataModel.dataFilePath())")
        
        setTitle()
    }
    
    func newTodoViewController(didFinishAdding item: ToDo) {
        let newRowIndex = dataModel.todos.count
        dataModel.todos.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        navigationController?.popViewController(animated: true)
        
        setTitle()
    }
    
    func newTodoViewController(didFinishEditing item: ToDo) {
        if let index = dataModel.todos.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                
                let label = cell.viewWithTag(1000) as! UILabel
                label.text = item.text
            }
        }
        navigationController?.popViewController(animated: true)
        
        setTitle()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItem", for: indexPath)
        
        let item = dataModel.todos[indexPath.row]
        
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        // TODO: - toggle
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if let currentCell = cell {
            currentCell.backgroundColor = .systemCyan
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                currentCell.backgroundColor = nil
                self.deleteThatShit(indexPath)
                self.setTitle()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.todos.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        setTitle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewTodo" {
            let controller = segue.destination as! NewTodoViewController
            controller.delegate = self
        } else if segue.identifier == "EditTodo" {
            let controller = segue.destination as! NewTodoViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.todoEdit = dataModel.todos[indexPath.row]
            }
        }
    }
    
    func deleteThatShit(_ indexPath: IndexPath) {
        dataModel.todos.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func setTitle() {
        if dataModel.todos.isEmpty {
            title = "All clear!"
        } else {
            title = "\(dataModel.todos.count) remaining"
        }
    }
    
    
}

// MARK: - Special comments
// If you put in a hyphen (-), you get a separator line followed by any text after the hyphen as the section title.
// TODO: another comment tag
// FIXME: another comment tag

// MARK: - Separation of concerns - delegation - objects doing something on behalf of other objects.

// MARK: - Usually, components will have just one delegate. But the table view splits up its delegate duties into two separate helpers: the UITableViewDataSource for putting rows into the table, and the UITableViewDelegate for handling taps on the rows and several other tasks.

// MARK: - You can see that the table view’s data source and delegate are both connected to the view controller. That is standard practice for a UITableViewController. (You can also use table views in a basic UIViewController but then you’ll have to connect the data source and delegate manually.)

// MARK: - The cool thing about the delegate pattern is that screen B doesn’t really know anything about screen A. It just knows that some object is its delegate, but doesn’t really care who that is. Just like how UITableView doesn’t really care about your view controller, only that it delivers table view cells when the table view asks for them.

// MARK: - iOS apps live in a sheltered environment known as the sandbox.

// MARK: - Each app has its own folder for storing files but cannot access the directories or files belonging to any other app.

// MARK: - Your apps can store files in the “Documents” folder in the app’s sandbox.

// MARK: - The contents of the Documents folder are backed up when the user syncs their device with iTunes or iCloud.

// MARK: - When you release a new version of your app and users install the update, the Documents folder is left untouched.

// MARK: - iOS uses URLs to refer to files in its filesystem. Where websites use http:// or https:// URLs, to refer to a file you use a file:// URL.

// MARK: - The Documents folder where the app will put its data files. Currently the Documents folder is empty.

// MARK: - The Library folder has cache files and preferences files. The contents of this folder are managed by the operating system.

// MARK: - The SystemData folder, as the name implies, is for use by the operating system to store any system level information relevant to the app.

// MARK: - The tmp folder is for temporary files. Sometimes apps need to create files for temporary usage. You don’t want these to clutter up your Documents folder, so tmp is a good place to put them. iOS will clear out this folder from time to time.

// MARK: - "plist” stands for Property List and it is an XML file format that stores structured data.

// MARK: - Incidentally, you have already used Codable's' Objective-C cousin, NSCoder, behind the scenes in storyboards. When you add a view controller to a storyboard, Xcode uses the NSCoder system to write this object to a file – encoding. Then when your application starts up, it uses NSCoder again to read the objects from the storyboard file – decoding. The Codable protocol works similarly.

// MARK: - The process of converting objects to files and back again is also known as serialization.

// MARK: - Swift arrays — as well as most other standard Swift objects and structures — conform to the Codable protocol. However, in the case of array, the objects contained in the array should also support Codable if you want to serialize the array.

// MARK: - Sometimes when working with code dealing with Codable support, you will see error messages or references to Encodable or Decodable protocols. So, it might be good to know that Codable is actually a protocol which combines these two other protocols, Encodable and Decodable — one for each side of the serialization process.

// MARK: - You can use Finder’s Quick Look feature to view the file. Simply select the file in Finder and press the space bar.

// MARK: - Objects whose name start with the “NS” prefix, like NSObject, NSString, or NSCoder, are provided by the Foundation framework. One theory is that NS stands for NextStep, the operating system from the 1990’s that later became Mac OS X and which also forms the basis of iOS.

// MARK: - Important note: When you press Xcode’s Stop button, the scene delegate will not receive the sceneDidDisconnect(_:) notification. Xcode kills the app immediately, without mercy. Therefore, to test the saving behavior, always simulate a tap on the home button to make the app go into the background before you press Stop. If you don’t to that, you’ll lose your data.

// MARK: - UIWindow is the top-level container for all your app’s views. There is only one UIWindow object per scene in your iOS app.

// MARK: - UserDefaults is an iOS mechanism which allows you to store small bits of information relevant to your application

// MARK: - When you insert new values into UserDefaults, they are saved somewhere in your app’s sandbox. So, these values persist even after the app terminates.

// MARK: - UserDefaults.standard.set(indexPath.row, forKey: "SomeData")
// MARK: UserDefaults.standard.integer(forKey: "SomeData")

// MARK: - Every view controller has a built-in navigationController property. To access its delegate property you use the notation navigationController?.delegate because the navigation controller is optional.

// MARK: - Use State Preservation and Restoration iOS API for somethings like remembering which screen was open

// MARK: - If you are moving files and folders around, do note that if you do move the Info.plist file into a folder, the next time you try to compile your project you'll get an error. This is because the Info.plist file contains information about your project and Xcode expects it to be in the root folder. You can change the location of the Info.plist file under Build Settings by searching for Info.plist if you do run into this issue, but you would have to know how to specify the new location for the file.

// MARK: - In case you're wondering why some values are shown as <redacted> in the console, that's due to privacy constraints in iOS which stops possibly sensitive information, such as the contents of a notification message, being captured/logged by an application.
