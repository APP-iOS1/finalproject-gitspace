//
//  MainHomeView.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/17.
//

import SwiftUI

struct MainHomeView: View {
    
    @EnvironmentObject var gitHubAuthManager: GitHubAuthManager
    @State private var selectedHomeTab = "Starred"
    @ObservedObject var eventViewModel = EventViewModel()
    private let starTab = "Starred"
    private let activityTab = "Activity"
    let gitHubService = GitHubService()
    
    var body: some View {
        VStack {
            /* Starred, Activity Tab Button */
            HStack {
                GSButton.CustomButtonView(
                    style: .homeTab(
                        tabName: starTab,
                        tabSelection: $selectedHomeTab
                    )
                ) {
                    selectedHomeTab = starTab
                } label: {
                    Text(starTab)
                        .font(.title3)
                        .foregroundColor(selectedHomeTab == starTab ? .primary : .gsGray2)
                        .bold()
                        .padding(.bottom, 4)
                }
                .tag(starTab)
                
                Divider()
                    .frame(height: 10)
                    .padding(.horizontal, 4)
                
                GSButton.CustomButtonView(
                    style: .homeTab(
                        tabName: activityTab,
                        tabSelection: $selectedHomeTab
                    )
                ) {
                    selectedHomeTab = activityTab
                } label: {
                    Text(activityTab)
                        .font(.title3)
                        .foregroundColor(selectedHomeTab == activityTab ? .primary : .gsGray2)
                        .bold()
                        .padding(.bottom, 4)
                }
                .tag(activityTab)
                
                Spacer()
            }
            .overlay(alignment: .bottom) {
                Divider()
                    .frame(minHeight: 0.5)
                    .overlay(Color.primary)
                    .offset(y: 3.5)
            }
            .padding(16)
            
            /* Starred, Activity View */
            switch selectedHomeTab {
            case starTab:
                StarredView(service: gitHubService)
                    .ignoresSafeArea()
            case activityTab:
                ActivityView(eventViewModel: eventViewModel)
                    .ignoresSafeArea()
            default:
                Text("네트워크 에러입니다.")
            }
            
        }
        .task {
            
            guard let currentGitHubUser = gitHubAuthManager.authenticatedUser?.login else { return }
            
            let activitiesResult = await gitHubService.requestAuthenticatedUserReceivedEvents(userName: currentGitHubUser, page: 1)
            
            eventViewModel.events.removeAll()
            
            switch activitiesResult {
            case .success(let events):
                eventViewModel.events = events.filter { $0.type == "PublicEvent" || $0.type == "WatchEvent" || $0.type == "ForkEvent" || $0.type == "CreateEvent" }
            case .failure(let error):
                print(error)
            }
            
            await eventViewModel.fetchEventActors()
            await eventViewModel.fetchEventRepositories()
        }
        // FIXME: - 추후 네비게이션 타이틀 지정 (작성자: 제균)
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("GitSpace")
                    .font(.title2)
                    .bold()
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    NotificationView()
                } label: {
                    Image(systemName: "bell")
                        .foregroundColor(.black)
                }
            }
        }
    }
}

struct MainHomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainHomeView()
        }
    }
}
