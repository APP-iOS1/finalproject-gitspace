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
	@Published var navigateToKnock: Bool = false
	@Published var navigateToChat: Bool = false
	
}

extension GSTabBarRouter {
    enum Page {
        case stars
        case chats
		case pushChats(id: String)
        case knocks
		case pushKnocks(id: String)
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
			case let (.pushChats(lhsChatID), .pushChats(rhsChatID)):
				return lhsChatID == rhsChatID
			case let (.pushKnocks(lhsKnockID), .pushKnocks(rhsKnockID)):
				return lhsKnockID == rhsKnockID
			default:
				return false
			}
		}
    }	
}

extension GSTabBarRouter {
	enum MessageType {
		case knock(title: String, body: String, fromUser: String, knockID: String)
		case chat(title: String, body: String, fromUser: String, chatID: String)
	}
}
