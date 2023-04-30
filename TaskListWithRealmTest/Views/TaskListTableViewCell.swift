//
//  TaskListTableViewCell.swift
//  TaskListWithRealmTest
//
//  Created by Светлана Сенаторова on 30.04.2023.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {

    func configure(with taskList: TaskList) {
        var content = defaultContentConfiguration()
        content.text = taskList.name
        
        let unDoneTasks = taskList.tasks.filter { task in
            task.isDone == false
        }
        
        if taskList.tasks.isEmpty {
            accessoryType = .none
            content.secondaryText = "0"
        } else if unDoneTasks.isEmpty {
            accessoryType = .checkmark
            content.secondaryText = nil
        } else {
            accessoryType = .none
            content.secondaryText = unDoneTasks.count.formatted()
        }
        contentConfiguration = content
    }

}
