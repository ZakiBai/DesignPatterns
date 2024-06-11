//
//  LoginViewController.swift
//  TodoList
//
//  Created by Kirill Leonov on 14.11.2023.
//

import UIKit

protocol ILoginViewController: AnyObject {

	/// Метод отрисовки информации на экране.
	/// - Parameter viewData: данные для отрисовки на экране.
	func render(viewData: LoginModel.ViewData)

	/// Метод реализации открытия нового экрана, за неимением роутера.
	/// - Parameter screen: Какой экран надо отобразить.
	func show(screen: UIViewController)
}

final class LoginViewController: UIViewController {

	// MARK: - Dependencies

	var presenter: ILoginPresenter?

	// MARK: - Private properties

	private lazy var textFieldLogin: UITextField = makeTextField()
	private lazy var textFieldPass: UITextField = makeTextField()
	private lazy var buttonLogin: UIButton = makeButtonLogin()

	private var constraints = [NSLayoutConstraint]()

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

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		layout()
	}
}

// MARK: - Actions

private extension LoginViewController {
	@objc
	func login() {
		presenter?.didLogin(login: textFieldLogin.text ?? "", password: textFieldPass.text ?? "")
	}
}

// MARK: - Setup UI

private extension LoginViewController {

	func makeTextField() -> UITextField {
		let textField = UITextField()

		textField.backgroundColor = .white
		textField.textColor = .black
		textField.layer.borderWidth = Sizes.borderWidth
		textField.layer.cornerRadius = Sizes.cornerRadius
		textField.layer.borderColor = UIColor.lightGray.cgColor
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Sizes.Padding.half, height: textField.frame.height))
		textField.leftViewMode = .always
		textField.translatesAutoresizingMaskIntoConstraints = false

		textField.translatesAutoresizingMaskIntoConstraints = false

		return textField
	}

	func makeButtonLogin() -> UIButton {
		let button = UIButton()

		button.configuration = .filled()
		button.configuration?.cornerStyle = .medium
		button.configuration?.baseBackgroundColor = .red
		button.configuration?.title = "Login"
		button.addTarget(self, action: #selector(login), for: .touchUpInside)

		button.translatesAutoresizingMaskIntoConstraints = false

		return button
	}

	func setup() {
		view.backgroundColor = .white
		title = "Authorization"
		navigationController?.navigationBar.prefersLargeTitles = true

		// Кастомная конфигурация наших полей
		textFieldLogin.placeholder = "Login"
		textFieldPass.placeholder = "Password"
		textFieldPass.isSecureTextEntry = true

		view.addSubview(textFieldLogin)
		view.addSubview(textFieldPass)
		view.addSubview(buttonLogin)
	}
}

// MARK: - Layout UI

private extension LoginViewController {

	func layout() {
		NSLayoutConstraint.deactivate(constraints)

		let newConstraints = [
			textFieldLogin.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			textFieldLogin.topAnchor.constraint(equalTo: view.topAnchor, constant: thirdOfTheScreen),
			textFieldLogin.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Sizes.L.widthMultiplier),
			textFieldLogin.heightAnchor.constraint(equalToConstant: Sizes.L.height),

			textFieldPass.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			textFieldPass.topAnchor.constraint(equalTo: textFieldLogin.bottomAnchor, constant: Sizes.Padding.normal),
			textFieldPass.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Sizes.L.widthMultiplier),
			textFieldPass.heightAnchor.constraint(equalToConstant: Sizes.L.height),

			buttonLogin.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			buttonLogin.topAnchor.constraint(equalTo: textFieldPass.bottomAnchor, constant: Sizes.Padding.double),
			buttonLogin.widthAnchor.constraint(equalToConstant: Sizes.L.width),
			buttonLogin.heightAnchor.constraint(equalToConstant: Sizes.L.height)
		]

		NSLayoutConstraint.activate(newConstraints)

		constraints = newConstraints
	}

	var thirdOfTheScreen: Double {
		return view.bounds.size.height / 3.0
	}
}

// MARK: - ILoginViewController

extension LoginViewController: ILoginViewController {
	func show(screen: UIViewController) {
		navigationController?.pushViewController(screen, animated: true)
	}

	func render(viewData: LoginModel.ViewData) {
		textFieldLogin.text = viewData.login
		textFieldPass.text = viewData.password
	}
}
