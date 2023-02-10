//
//  AppState.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/09.
//

import SwiftUI

final class AppState: ObservableObject {
	static let shared = AppState()
	@Published var pageNavigationTo: GSTabBarRouter.Page?
	
	var navigationBindingActive: Binding<Bool> {
		.init { () -> Bool in
			self.pageNavigationTo != nil
		} set: { (newValue) in
			if !newValue { self.pageNavigationTo = nil }
		}
	}
	
	private init () {}
}
