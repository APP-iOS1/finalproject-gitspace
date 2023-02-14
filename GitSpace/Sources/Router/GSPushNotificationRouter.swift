//
//  AppState.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/09.
//

import SwiftUI

final class GSPushNotificationRouter: ObservableObject {
	@Published var pageNavigationTo: GSTabBarRouter.Page?
	
	var navigationBindingActive: Binding<Bool> {
		.init { () -> Bool in
			self.pageNavigationTo != nil
		} set: { (newValue) in
			if !newValue { self.pageNavigationTo = nil }
		}
	}
}

extension GSPushNotificationRouter {
	// 메시지의 타입을 결정하고 메시지의 제목과 내용은 연관값으로 받아옵니다.
	
}
