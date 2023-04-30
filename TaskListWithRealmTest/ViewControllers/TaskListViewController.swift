//
//  TaskListTableViewController.swift
//  TaskListWithRealmTest
//
//  Created by Светлана Сенаторова on 28.04.2023.
//

import UIKit
import RealmSwift

class TaskListViewController: UIViewController {
    
    @IBOutlet var taskListTableView: UITableView!
    
    var taskLists: Results<TaskList>!
    var undoneTasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonPressed)
        )
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = editButtonItem
    
        createTempData()
        taskLists = StorageManager.shared.realm.objects(TaskList.self)
//        UserDefaults.standard.removeObject(forKey: "done")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskListTableView.reloadData()
    }
    
    @IBAction func sortedAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            taskLists = taskLists.sorted(byKeyPath: "date")
        } else {
            taskLists = taskLists.sorted(byKeyPath: "name")
        }
        taskListTableView.reloadData()
    }
}

// MARK: - Table view data source, Table view delegate
    
extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskListCell", for: indexPath) as? TaskListTableViewCell else { return UITableViewCell()  }
        cell.configure(with: taskLists[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTasks", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let taskList = taskLists[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.shared.delete(taskList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [unowned self] _, _, isDone in
            showAlert(with: taskList) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        
        let doneAction = UIContextualAction(style: .normal, title: "Done") { _, _, isDone in
            StorageManager.shared.done(taskList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            isDone(true)
        }
        
        doneAction.backgroundColor = .green
        editAction.backgroundColor = .orange
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction, doneAction])
    }
    
}
    
// MARK: - Navigation

extension TaskListViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = taskListTableView.indexPathForSelectedRow else { return }
        guard let taskVC = segue.destination as? TaskTableViewController else { return }
        taskVC.taskList = taskLists[indexPath.row]
    }
    
}

// MARK: - UIAlertController

extension TaskListViewController {
    
    private func showAlert(with taskList: TaskList? = nil, completion: (() -> Void)? = nil) {
        let title = taskList != nil ? "Edit Task List" : "New Task List"
        let alert = UIAlertController.createAlertController(witTitle: title)
        
        alert.action(taskList: taskList) { [unowned self] newValue in
            if let taskList = taskList, let completion = completion {
                StorageManager.shared.edit(taskList, newValue: newValue)
                completion()
            } else {
                save(tasklist: newValue)
            }
        }
        present(alert, animated: true)
    }
}

//MARK: - Private Funcs

extension TaskListViewController {
    
    @objc private func addButtonPressed() {
        showAlert()
    }
    
    private func save(tasklist: String) {
        StorageManager.shared.save(tasklist) { [unowned self] taskList in
            let rowIndex = IndexPath(row: taskLists.index(of: taskList) ?? 0, section: 0)
            taskListTableView.insertRows(at: [rowIndex], with: .automatic)
        }
    }
    
    private func createTempData() {
        DataManager.shared.createTempData { [unowned self] in
            taskListTableView.reloadData()
        }
    }
}
    
