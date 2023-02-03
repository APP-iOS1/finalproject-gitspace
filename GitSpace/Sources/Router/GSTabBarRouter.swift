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
    @Published var currentPage: Page = .stars
}

extension GSTabBarRouter {
    enum Page {
        case stars
        case chats
        case knocks
        case profile
    }
}
