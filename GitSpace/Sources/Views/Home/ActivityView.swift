//
//  ActivityView.swift
//  GitSpace
//
//  Created by 박제균 on 2023/01/18.
//

import SwiftUI

struct ActivityView: View {
    
    let gitHubService = GitHubService()
    
    @EnvironmentObject var gitHubAuthManager: GitHubAuthManager
    @ObservedObject var eventViewModel: EventViewModel
    
//    init(service: GitHubService) {
//        self.gitHubService = service
//    }
    
    var body: some View {
        
            ScrollView {
                
                ForEach(eventViewModel.events) { event in
                    // event, gitHubUser, Repository 필요
                    // 인덱스로 접근하면 안되던뎅
                    ActivityFeedView(service: gitHubService, event: event)
                    Divider()
                }
            } // ScrollView
    } // body
}
