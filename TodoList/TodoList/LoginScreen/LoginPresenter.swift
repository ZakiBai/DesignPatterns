//
//  LoginPresenter.swift
//  TodoList
//
//  Created by Kirill Leonov on 24.11.2023.
//

import Foundation
import UIKit

protocol ILoginPresenter {
	/// Экран готов для отображения информации.
	func viewIsReady()

	/// Пользователь перешел к авторизации.
	/// - Parameters:
	///   - login: Логин пользователя;
	///   - password: Пароль пользователя.
	func didLogin(login: String, password: String)
}

class LoginPresenter: ILoginPresenter {

	// MARK: - Dependencies
	private weak var view: ILoginViewController! // swiftlint:disable:this implicitly_unwrapped_optional

	// MARK: - Private properties
	private let nextScreen: UIViewController! // swiftlint:disable:this implicitly_unwrapped_optional

	// MARK: - Initialization

	init(view: ILoginViewController, nextScreen: UIViewController) {
		self.nextScreen = nextScreen
		self.view = view
	}

	// MARK: - Public methods

	func viewIsReady() {
		view.render(viewData: LoginModel.ViewData(login: "", password: ""))
	}

	func didLogin(login: String, password: String) {
		view.show(screen: nextScreen)
	}
}
