//
//  TaskTableViewController.swift
//  TaskListWithRealmTest
//
//  Created by Светлана Сенаторова on 28.04.2023.
//

import UIKit
import RealmSwift

class TaskTableViewController: UITableViewController {
    
    var taskList: TaskList!
    private var currentTasks: Results<Task>!
    private var completedTasks: Results<Task>!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = taskList.name
    
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonPressed)
        )
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
        currentTasks = taskList.tasks.filter("isDone = false")
        completedTasks = taskList.tasks.filter("isDone = true")
    
    }
    
    @objc private func addButtonPressed() {
        showAlert()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? currentTasks.count : completedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "CURRENT TASKS" : "COMPLETED TASKS"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        content.text = task.name
        content.secondaryText = task.note
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.shared.delete(task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [unowned self] _, _, isDone in
            showAlert(with: task) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        
        let doneAction = UIContextualAction(style: .normal, title: indexPath.section == 0 ? "Done" : "Undone") { _, _, isDone in
            StorageManager.shared.done(task)
            let currentTaskIndex = IndexPath(row: self.currentTasks.index(of: task) ?? 0, section: 0)
            let completedTaskIndex = IndexPath(row: self.completedTasks.index(of: task) ?? 0, section: 1)
            let targetIndexPathRow = indexPath.section == 0 ? completedTaskIndex : currentTaskIndex
            tableView.moveRow(at: indexPath, to: targetIndexPathRow)
            isDone(true)
        }
        
        doneAction.backgroundColor = .green
        editAction.backgroundColor = .orange
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction, doneAction])
    }

}

extension TaskTableViewController {
    
    private func showAlert(with task: Task? = nil, completion: (() -> Void)? = nil) {
        let title = task != nil ? "Edit Task" : "New Task"
        let alert = UIAlertController.createAlertController(witTitle: title)
        
        alert.action(task: task) { [unowned self] newName, newNote in
            if let task = task, let completion = completion {
                StorageManager.shared.edit(task, with: newName, and: newNote)
                completion()
            } else {
               save(task: newName, withNote: newNote, to: taskList)
            }

        }
        present(alert, animated: true)
    }
    
    private func save(task: String, withNote note: String, to taskList: TaskList) {
        StorageManager.shared.save(task, withNote: note, to: taskList) { task in
            let rowIndex = IndexPath(row: currentTasks.index(of: task) ?? 0, section: 0)
            tableView.insertRows(at: [rowIndex], with: .automatic)
        }
    }
}


