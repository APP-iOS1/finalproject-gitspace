//
//  ContributorListView.swift
//  GitSpace
//
//  Created by yeeunchoi on 2023/01/18.
//

import SwiftUI
import FirebaseAuth

struct ContributorListView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userInfoManager: UserStore
    @ObservedObject var contributorManager: ContributorViewModel
    
    public let gitHubService: GitHubService
    public let repository: Repository
    
    init(service: GitHubService, repository: Repository, contributorManager: ContributorViewModel) {
        self.gitHubService = service
        self.repository = repository
        self.contributorManager = contributorManager
    }
    
    @State var gitSpaceUserList: [Int] = []
    @State var isDevided: Bool = false
    
    func devideUser() async {
        
        withAnimation(.easeInOut) {
            isDevided = false
        }
        
        for someUser in contributorManager.contributors {
            if await userInfoManager.requestUserInfoWithGitHubID(githubID: someUser.id) != nil {
                gitSpaceUserList.append(someUser.id)
            }
        }
        
        withAnimation(.easeInOut) {
            isDevided = true
        }
    }
    
    // MARK: - BODY
    var body: some View {
        
        ScrollView {
            if isDevided == true {
                // MARK: - 상황별 마스코트 이미지
                /* 노트 시나리오의 시각적 힌트 제공 */
                HStack {
                    Spacer()
                    
                    Image("GitSpace-ContributorListView")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width - 250)
                        .padding(.vertical, 25)
                    
                    Spacer()
                }
                
                
                HStack {
                    if gitSpaceUserList.isEmpty && isDevided == true {
                        GSText.CustomTextView(
                            style: .title2,
                            string: "Oops!")
                    } else {
                        GSText.CustomTextView(
                            style: .title2,
                            string: "Who do you want to chat with?")
                    }
                    Spacer()
                }
                .padding(.leading, 20)
                
                // MARK: - 컨트리뷰터 명단 스크롤 뷰
                /* 서브 캡션 */
                HStack {
                    
                    if gitSpaceUserList.isEmpty {
                        GSText.CustomTextView(
                            style: .caption1,
                            string:
"""
There are no GitSpace users
among the contributors to this repository.
"""
                        )
                    } else {
                        GSText.CustomTextView(
                            style: .caption1,
                            string:
"""
You can chat with GitSpace User.
Please select a User to start chatting with.
"""
                        )
                    }
                    
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.top, -10)
                .padding(.bottom, -10)
                
                if !gitSpaceUserList.isEmpty {
                    Divider()
                        .padding([.top, .horizontal], 20)
                        .padding(.bottom, 10)
                    
                    HStack {
                        GSText.CustomTextView(
                            style: .caption1,
                            string: "GitSpace User  ⎯  \(gitSpaceUserList.count)")
                        Spacer()
                    }
                    .padding(.leading, 20)
                    
                    ForEach(contributorManager.contributors) { user in
                        
                        if gitSpaceUserList.contains(user.id) {
                            NavigationLink(destination: Text("SendKnock View로 랜딩할 예정")) {
                                ContributorGitSpaceUserListCell(targetUser: user)
                            } // NavigationLink
                            .padding(.horizontal, 20)
                        } // if
                    } // ForEach
                } // if
                
                if contributorManager.contributors.count - gitSpaceUserList.count != 0 {
                    Divider()
                        .padding([.top, .horizontal], 20)
                        .padding(.bottom, 10)
                    
                    HStack {
                        GSText.CustomTextView(
                            style: .caption1,
                            string: "Non-GitSpace User  ⎯  \(contributorManager.contributors.count - gitSpaceUserList.count)")
                        Spacer()
                    } // HStack
                    .padding(.leading, 20)
                    
                    ForEach(contributorManager.contributors) { user in
                        
                        if !gitSpaceUserList.contains(user.id) {
                            ContributorListCell(targetUser: user)
                                .padding(.horizontal, 20)
                        } // if
                    } // ForEach
                } // if
            } else {
                ContributorListSkeletonView()
            }
            
        } // ScrollView
        .task {
            await devideUser()
        }
        
    } // body
}

//struct ContributorListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContributorListView()
//    }
//}
