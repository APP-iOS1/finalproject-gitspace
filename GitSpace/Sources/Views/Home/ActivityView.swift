//
//  ActivityView.swift
//  GitSpace
//
//  Created by 박제균 on 2023/01/18.
//

import SwiftUI

struct ActivityView: View {
    
    @EnvironmentObject var gitHubAuthManager: GitHubAuthManager
    @ObservedObject var eventViewModel: EventViewModel
    
    var body: some View {
        
            ScrollView {
                ForEach(eventViewModel.events) { event in
                    // event, gitHubUser, Repository 필요
                    // 인덱스로 접근하면 안되던뎅
                    ActivityFeedView(eventViewModel: eventViewModel, event: event)
                    Divider()
                }
            } // ScrollView
            .refreshable {
                Task{
                    guard let currentGitHubUser = gitHubAuthManager.authenticatedUser?.login else { return }
                    try await eventViewModel.requestAuthenticatedUserReceivedEvents(who: currentGitHubUser)
                }
            }
    } // body
}
