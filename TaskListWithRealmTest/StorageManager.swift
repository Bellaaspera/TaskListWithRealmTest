//
//  StorageManager.swift
//  TaskListWithRealmTest
//
//  Created by Светлана Сенаторова on 29.04.2023.
//

import Foundation
import RealmSwift

class StorageManager {
    
    static let shared = StorageManager()
    
    let realm = try! Realm()
    
    private init() {}
}

extension StorageManager {
    
//MARK: - TaskLists
    
    func save(_ taskLists: [TaskList]) {
        write {
            realm.add(taskLists)
        }
    }
    
    func save(_ taskList: String, completion: (TaskList) -> Void) {
        write {
            let taskList = TaskList(value: [taskList])
            realm.add(taskList)
            completion(taskList)
        }
    }
    
    func delete(_ taskList: TaskList) {
        write {
            realm.delete(taskList.tasks)
            realm.delete(taskList)
        }
    }
    
    func edit(_ tasklist: TaskList, newValue: String) {
        write {
            tasklist.name = newValue
        }
    }
    
    func done(_ taskList: TaskList) {
        write {
            taskList.tasks.setValue(true, forKey: "isDone")
        }
    }
    
//MARK: - Tasks
    
    func save(_ task: String, withNote note: String, to taskList: TaskList, completion: (Task) -> Void) {
        write {
            let task = Task(value: ["name": task, "note": note])
            taskList.tasks.append(task)
            completion(task)
        }
    }
    
    func delete(_ task: Task) {
        write {
            realm.delete(task)
        }
    }
    
    func edit(_ task: Task, with newName: String, and newNote: String) {
        write {
            task.name = newName
            task.note = newNote
        }
    }
    
    func done(_ task: Task) {
        write {
            task.isDone.toggle()
        }
    }
    
    
//MARK: - Private func
    
    private func write(completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
