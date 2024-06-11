//
//  SceneDelegate.swift

import UIKit
import TaskManagerPackage

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let scene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: scene)

		window.rootViewController = UINavigationController(rootViewController: assemblyLogin())
		window.makeKeyAndVisible()

		self.window = window
	}

	func assemblyTodoList() -> UIViewController {
		let viewController = MainViewController()
		let presenter = MainPresenter(view: viewController, taskManager: buildTaskManager())
		viewController.presenter = presenter
		return viewController
	}

	func assemblyLogin() -> UIViewController {
		let viewController = LoginViewController()
		let presenter = LoginPresenter(view: viewController, nextScreen: assemblyTodoList())
		viewController.presenter = presenter
		return viewController
	}

	func buildTaskManager() -> ITaskManager {
		let taskManager = OrderedTaskManager(taskManager: TaskManager())
		let tasks = [
			ImportantTask(title: "Do homework", taskPriority: .high),
			RegularTask(title: "Do Workout", completed: true),
			ImportantTask(title: "Write new tasks", taskPriority: .low, createDate: Date()),
			RegularTask(title: "Solve 3 algorithms"),
			ImportantTask(title: "Go shopping", taskPriority: .medium, createDate: Date())
		]
		taskManager.addTasks(tasks: tasks)

		return taskManager
	}
}
