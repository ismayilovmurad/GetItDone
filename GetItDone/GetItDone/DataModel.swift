//
//  DataModel.swift
//  GetItDone
//
//  Created by Murad Ismayilov on 23.02.23.
//

import Foundation

class DataModel {
    var todos = [ToDo]()
    
    init() {
        loadChecklistItems()
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    // This method takes the contents of the items array, converts it to a block of binary data, and then writes this data to a file.
    func save() {
      // 1
      let encoder = PropertyListEncoder()
      // 2
      do {
        // 3
        let data = try encoder.encode(todos)
        // 4
        try data.write(
          to: dataFilePath(),
          options: Data.WritingOptions.atomic)
        // 5
      } catch {
        // 6
        print("Error encoding item array: \(error.localizedDescription)")
      }
    }
    
    func loadChecklistItems() {
      // 1
      let path = dataFilePath()
      // 2
      if let data = try? Data(contentsOf: path) {
        // 3
        let decoder = PropertyListDecoder()
        do {
          // 4
          todos = try decoder.decode(
            [ToDo].self,
            from: data)
            
            
        } catch {
          print("Error decoding item array: \(error.localizedDescription)")
        }
      }
    }
    
    class func nextChecklistItemID() -> Int {
      let userDefaults = UserDefaults.standard
      let itemID = userDefaults.integer(forKey: "ChecklistItemID")
      userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
      return itemID
    }
}
