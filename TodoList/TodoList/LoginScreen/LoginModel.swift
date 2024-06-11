//
//  LoginModel.swift
//  TodoList
//
//  Created by Kirill Leonov on 24.11.2023.
//

import Foundation

/// LoginModel является NameSpace для отделения ViewData различных экранов друг отдруга
enum LoginModel {

	/// Структура описывающая  экран авторизации
	struct ViewData {
		let login: String
		let password: String
	}
}
