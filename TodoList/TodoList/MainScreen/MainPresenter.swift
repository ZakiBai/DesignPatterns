//
//  MainPresenter.swift
//  TodoList
//
//  Created by Kirill Leonov on 24.11.2023.
//

import Foundation
import TaskManagerPackage

/// Протокол презентера для отображения главного экрана.
protocol IMainPresenter {

	/// Экран готов для отображения информации.
	func viewIsReady()

	/// Пользователь выбрал строку  в таблице.
	/// - Parameter indexPath: Индекс выбранной строки.
	func didTaskSelected(at indexPath: IndexPath)
}

/// Презентер для главного экрана
class MainPresenter: IMainPresenter {

	private var sectionManager: ISectionForTaskManagerAdapter
	private weak var view: IMainViewController! // swiftlint:disable:this implicitly_unwrapped_optional

	/// Инициализатор презентера
	/// - Parameters:
	///   - view: Необходимая вьюха, на которой будет выводиться информация;
	///   - taskManager: Источник информации для заданий.
	init(view: IMainViewController, sectionManager: ISectionForTaskManagerAdapter) {
		self.view = view
		self.sectionManager = sectionManager
	}

	/// Обработка готовности экрана для отображения информации.
	func viewIsReady() {
		view.render(viewData: mapViewData())
	}

	/// Обработка выбранной пользователем строки таблицы.
	/// - Parameter indexPath: Индекс, который выбрал пользователь.
	func didTaskSelected(at indexPath: IndexPath) {
		let section = sectionManager.getSection(forIndex: indexPath.section)
		let task = sectionManager.getTasksForSection(section: section)[indexPath.row]
		task.completed.toggle()
		view.render(viewData: mapViewData())
	}

	/// Мапинг бизнес-моделей в модель для отображения.
	/// - Returns: Возвращает модель для отображения.
	private func mapViewData() -> MainModel.ViewData {
		var sections = [MainModel.ViewData.Section]()

		for section in sectionManager.getSections() {
			let sectionData = MainModel.ViewData.Section(
				title: section.title,
				tasks: mapTasksData(tasks: sectionManager.getTasksForSection(section: section))
			)
			sections.append(sectionData)
		}

		return MainModel.ViewData(tasksBySections: sections)
	}

	private func mapTasksData(tasks: [Task]) -> [MainModel.ViewData.Task] {
		tasks.map { mapTaskData(task: $0) }
	}

	/// Мапинг одной задачи из бизнес-модели в задачу для отображения
	/// - Parameter task: Задача для преобразования.
	/// - Returns: Преобразованный результат.
	private func mapTaskData(task: Task) -> MainModel.ViewData.Task {
		if let task = task as? ImportantTask {
			let result = MainModel.ViewData.ImportantTask(
				title: task.title,
				completed: task.completed,
				deadLine: "Deadline: \(task.deadLine)",
				priority: "\(task.taskPriority)"
			)
			return .importantTask(result)
		} else {
			return .regularTask(
				MainModel.ViewData.RegularTask(
					title: task.title,
					completed: task.completed
				)
			)
		}
	}
}
