//
//  TabManager.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/28.
//

import Foundation

class TabManager : ObservableObject {
    
    enum TabState {
        case user
        case chat
        case profile
    }
    
    @Published var tabSelection: TabState
    
    init(tabSelection: TabState = .user) {
        self.tabSelection = tabSelection
    }
}
