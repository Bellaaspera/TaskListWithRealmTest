//
//  DataManager.swift
//  TaskListWithRealmTest
//
//  Created by Светлана Сенаторова on 29.04.2023.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    private init() {}
    
    func createTempData(completion: @escaping() -> Void) {
        if !UserDefaults.standard.bool(forKey: "done") {
            let shopingList = TaskList()
            shopingList.name = "Shoping List"
            let bread = Task(value: ["Bread", "", Date(), true] as [Any])
            let apples = Task(value: ["name":"Apples", "note":"2kg"])
            let milk = Task(value: ["name": "Milk", "note": "3l"])
            shopingList.tasks.insert(contentsOf: [bread, apples, milk], at: 0)
            
            let mooviesList = TaskList()
            mooviesList.name = "Movies List"
            let firstFilm = Task(value: ["name": "Best film ever", "note": "watch asap"])
            let secondFilm = Task(value: ["name": "The best from the best film"])
            mooviesList.tasks.insert(contentsOf: [firstFilm, secondFilm], at: 0)
            
            DispatchQueue.main.async {
                StorageManager.shared.save([shopingList, mooviesList])
                UserDefaults.standard.set(true, forKey: "done")
                completion()
            }
        }
    }
}
