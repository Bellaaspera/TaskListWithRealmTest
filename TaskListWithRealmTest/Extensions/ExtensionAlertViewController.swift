//
//  ExtensionAlertViewController.swift
//  TaskListWithRealmTest
//
//  Created by Светлана Сенаторова on 28.04.2023.
//

import UIKit

extension UIAlertController {
    
    static func createAlertController(witTitle title: String) -> UIAlertController {
        UIAlertController(title: title, message: "What do you want to do?", preferredStyle: .alert)
    }
    
    func action(taskList: TaskList?, completion: @escaping(String) -> Void) {
        let doneButton = taskList == nil ? "Save" : "Edit"
        let saveAction = UIAlertAction(title: doneButton, style: .default) { [weak self] _ in
            guard let newText = self?.textFields?.first?.text, !newText.isEmpty else { return }
            completion(newText)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        addTextField() { textField in
            textField.placeholder = "TaskList"
            textField.text = taskList?.name
        }
    }
    
    func action(task: Task?, completion: @escaping(String, String) -> Void) {
        let doneButton = task == nil ? "Save" : "Edit"
        let saveAction = UIAlertAction(title: doneButton, style: .default) { [weak self] _ in
            guard let newTask = self?.textFields?.first?.text, !newTask.isEmpty else { return }
            
            if let newNote = self?.textFields?.last?.text, !newNote.isEmpty {
                completion(newTask, newNote)
            } else {
                completion(newTask, "")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        addTextField() { [weak self] textField in
            let nameTextField = self?.textFields?.first
            nameTextField?.placeholder = "Task"
            nameTextField?.text = task?.name
        }
        addTextField() { [weak self] textField in
            let noteTextField = self?.textFields?.last
            noteTextField?.placeholder = "Note"
            noteTextField?.text = task?.note
        }
    }
}

