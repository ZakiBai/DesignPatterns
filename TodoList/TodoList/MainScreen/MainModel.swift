//
//  MainModel.swift
//  TodoList
//
//  Created by Kirill Leonov on 24.11.2023.
//

import Foundation

/// MainModel является NameSpace для отделения ViewData различных экранов друг отдруга
enum MainModel {

	/// Структура описывающая главный экран приложения TodoList
	struct ViewData {
		/// Содержит в себе список задач для отображения
		let tasks: [Task]

		/// Перечисление представляющее наши задачи для отображения на экране
		enum Task {
			case regularTask(RegularTask)
			case importantTask(ImportantTask)
		}

		/// Обычное задание, содержит только то, что отображается на экране
		struct RegularTask {
			let title: String
			let completed: Bool
		}

		/// Важное задание, содержит только то, что отображается на экране
		struct ImportantTask {
			let title: String
			let completed: Bool
			let deadLine: String
			let priority: String
		}
	}
}
