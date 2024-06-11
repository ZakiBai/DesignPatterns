//
//  TodoListTableViewController.swift

import UIKit
import TaskManagerPackage

/// Протокол для главного экрана приложения.
protocol IMainViewController: AnyObject {

	/// Метод отрисовки информации на экране.
	/// - Parameter viewData: данные для отрисовки на экране.
	func render(viewData: MainModel.ViewData)
}

/// Главный экран приложения.
final class MainViewController: UITableViewController {

	// MARK: - Dependencies
	var presenter: IMainPresenter?

	// MARK: - Private properties
	private var viewData = MainModel.ViewData(tasks: [])

	// MARK: - Initialization

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
		presenter?.viewIsReady()
	}
}

// MARK: - UITableView

extension MainViewController {
	override func numberOfSections(in tableView: UITableView) -> Int {
		2
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewData.tasks.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let task = getTaskForIndex(indexPath)
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		configureCell(cell, with: task)
		return cell
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "Completed tasks"
		} else {
			return "Uncompleted tasks"
		}
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter?.didTaskSelected(at: indexPath)
	}
}

// MARK: - UI setup

private extension MainViewController {

	private func setup() {
		title = "TodoList"
		navigationItem.setHidesBackButton(true, animated: true)
		self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
	}

	func getTaskForIndex(_ indexPath: IndexPath) -> MainModel.ViewData.Task {
		viewData.tasks[indexPath.row]
	}

	func configureCell(_ cell: UITableViewCell, with task: MainModel.ViewData.Task) {
		var contentConfiguration = cell.defaultContentConfiguration()

		cell.tintColor = .red
		cell.selectionStyle = .none

		switch task {
		case .importantTask(let task):
			let redText = [NSAttributedString.Key.foregroundColor: UIColor.red]
			let taskText = NSMutableAttributedString(string: task.priority + " ", attributes: redText )
			taskText.append(NSAttributedString(string: task.title))

			contentConfiguration.attributedText = taskText
			contentConfiguration.secondaryText = task.deadLine
			cell.accessoryType = task.completed ? .checkmark : .none
		case .regularTask(let task):
			contentConfiguration.text = task.title
			cell.accessoryType = task.completed ? .checkmark : .none
		}

		cell.contentConfiguration = contentConfiguration
	}
}

// MARK: - IMainViewController

extension MainViewController: IMainViewController {
	func render(viewData: MainModel.ViewData) {
		self.viewData = viewData
		tableView.reloadData()
	}
}
