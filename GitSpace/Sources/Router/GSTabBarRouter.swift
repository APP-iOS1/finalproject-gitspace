//
//  GSTabBarRouter.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/03.
//

import SwiftUI

/**
 현재 렌더링하고 있는 탭을 저장하는 GSTabBarRouter class
 
 - Author: 제균
 */

final class GSTabBarRouter: ObservableObject {
    @Published var currentPage: Page?
	@Published var navigateToReceivedKnock: Bool = false
	@Published var navigateToSentKnock: Bool = false
	@Published var navigateToChat: Bool = false
	
	init() {
		currentPage = nil
		
		$navigateToSentKnock
			.sink { newValue in
				print("$navigateToSentKnock", newValue)
			}
		
		$navigateToReceivedKnock
			.sink { newValue in
				print("$navigateToReceivedKnock", newValue)
			}
	}
}

extension GSTabBarRouter {
    enum Page {
        case stars
        case chats
        case knocks
        case profile
		
		static func ==(
			lhs: GSTabBarRouter.Page,
			rhs: GSTabBarRouter.Page
		) -> Bool {
			switch (lhs, rhs) {
			case (.stars, .stars):
				return true
			case (.profile, .profile):
				return true
			case (.knocks, .knocks):
				return true
			case (.chats, .chats):
				return true
			default:
				return false
			}
		}
    }	
}
