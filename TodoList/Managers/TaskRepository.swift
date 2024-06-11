//
//  TaskRepository.swift
//  TodoList
//
//  Created by Zaki on 11.06.2024.
//

import Foundation
import TaskManagerPackage

protocol ITaskRepository {
	func getTasks() -> [Task]
}

final class TaskRepositoryStub: ITaskRepository {
	func getTasks() -> [Task] {
		[
		ImportantTask(title: "Do homework", taskPriority: .high),
		RegularTask(title: "Do Workout", completed: true),
		ImportantTask(title: "Write new tasks", taskPriority: .low, createDate: Date()),
		RegularTask(title: "Solve 3 algorithms"),
		ImportantTask(title: "Go shopping", taskPriority: .medium, createDate: Date())
		]
	}
}
