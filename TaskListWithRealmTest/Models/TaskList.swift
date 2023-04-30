//
//  TaskList.swift
//  TaskListWithRealmTest
//
//  Created by Светлана Сенаторова on 28.04.2023.
//

import Foundation
import RealmSwift

class TaskList: Object {
    @Persisted var name = ""
    @Persisted var date = Date()
    @Persisted var tasks = List<Task>()
}

class Task: Object {
    @Persisted var name = ""
    @Persisted var note = ""
    @Persisted var date = Date()
    @Persisted var isDone = false
}
