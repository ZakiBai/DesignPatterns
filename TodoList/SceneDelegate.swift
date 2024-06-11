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

	func assemblyLogin() -> UIViewController {
		let viewController = LoginViewController()
		let todoListAssembler = TodoListAssembler(repository: TaskRepositoryStub())
		let presenter = LoginPresenter(view: viewController, nextScreen: todoListAssembler.assemblyTodoList())
		viewController.presenter = presenter
		return viewController
	}
}

final class TodoListAssembler {
	private let repository: ITaskRepository

	init(repository: ITaskRepository) {
		self.repository = repository
	}

	func assemblyTodoList() -> UIViewController {
		let viewController = MainViewController()
		let sectionManager = SectionForTaskManagerAdapter(
			taskManager: buildTaskManager(),
			sections: [.uncompleted, .completed, .allTasks]
		)
		let presenter = MainPresenter(view: viewController, sectionManager: sectionManager)
		viewController.presenter = presenter
		return viewController
	}

	func buildTaskManager() -> ITaskManager {
		let taskManager = OrderedTaskManager(taskManager: TaskManager())
		taskManager.addTasks(tasks: repository.getTasks())

		return taskManager
	}
}
