//
//  SectionForTaskManagerAdapter.swift
//  TodoList
//
//  Created by Zaki on 11.06.2024.
//

import Foundation
import TaskManagerPackage

protocol ISectionForTaskManagerAdapter {
	func getSections() -> [Section]
	func getSection(forIndex index: Int) -> Section
	func getTasksForSection(section: Section) -> [Task]
}

enum Section {
	case completed
	case uncompleted
	case allTasks

	var title: String {
		switch self {
		case .completed:
			return "Completed"
		case .uncompleted:
			return "Uncompleted"
		case .allTasks:
			return "All tasks"
		}
	}
}

final class SectionForTaskManagerAdapter: ISectionForTaskManagerAdapter {

	// MARK: - Dependencies

	private let taskManager: ITaskManager

	// MARK: - Private properties

	private let sections: [Section]

	// MARK: - Initialization

	init(taskManager: ITaskManager, sections: [Section] = [.uncompleted, .completed]) {
		self.taskManager = taskManager
		self.sections = sections
	}

	// MARK: - Public methods

	func getSections() -> [Section] {
		sections
	}

	func getSection(forIndex index: Int) -> Section {
		let correctIndex = min(index, sections.count - 1)
		return sections[correctIndex]
	}

	func getTasksForSection(section: Section) -> [TaskManagerPackage.Task] {
		switch section {
		case .completed:
			return taskManager.completedTasks()
		case .uncompleted:
			return taskManager.uncompletedTasks()
		case .allTasks:
			return taskManager.allTasks()
		}
	}
}
