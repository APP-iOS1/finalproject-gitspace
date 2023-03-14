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
        
        gitSpaceUserList.removeAll()
        
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
                } // HStack
                
                HStack {
                    if gitSpaceUserList.isEmpty && isDevided == true {
                        // MARK: - 저장소의 기여자들 중 GitSpace User가 없을 경우
                        GSText.CustomTextView(
                            style: .title2,
                            string: "Oops!")
                    // if
                    } else if contributorManager.contributors.count == 1 && gitSpaceUserList.contains(userInfoManager.currentUser?.githubID ?? 0) {
                        
                        // MARK: - currentUser가 저장소의 유일한 기여자일 경우
                        GSText.CustomTextView(
                            style: .title2,
                            string: "Hello, \(userInfoManager.currentUser?.githubName ?? userInfoManager.currentUser!.githubLogin)!")
                    // else if
                    } else {
                        GSText.CustomTextView(
                            style: .title2,
                            string: "Who do you want to chat with?")
                    } // else
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
// MARK: - 저장소의 기여자들 중 GitSpace User가 없을 경우
"""
There are no GitSpace users
among the contributors to this repository.
"""
                        )
                        // if
                    } else if contributorManager.contributors.count == 1 && gitSpaceUserList.contains(userInfoManager.currentUser?.githubID ?? 0) {
                        GSText.CustomTextView(
                            style: .caption1,
                            string:
// MARK: - currentUser가 저장소의 유일한 기여자일 경우
"""
You're the only contributor to this repository!
Unfortunately, you can't chat with yourself.
"""
                            )
                        // else if
                    } else {
                        GSText.CustomTextView(
                            style: .caption1,
                            string:
// MARK: - 저장소의 기여자들 중 GitSpace User가 있을 경우
"""
You can chat with GitSpace User.
Please select a User to start chatting with.
"""
                        )
                    } // else
                    
                    Spacer()
                } // HStack
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
                    } // HStack
                    .padding(.leading, 20)
                    
                    ForEach(contributorManager.contributors) { user in
                        if gitSpaceUserList.contains(user.id) &&
                            user.id == userInfoManager.currentUser!.githubID {
                            ContributorListCell(targetUser: user)
                                .padding(.horizontal, 20)
                        } // if
                        
                        if gitSpaceUserList.contains(user.id) {
                            if user.id != userInfoManager.currentUser!.githubID {
                                NavigationLink {
                                    SendKnockView(sendKnockToGitHubUser: user)
                                        .task {
                                            // UserStore가 opponent를 가질 수 있도록 메소드 호출
                                            let _ = await userInfoManager.requestUserInfoWithGitHubID(githubID: user.id)
                                        }
                                } label: {
                                    ContributorGitSpaceUserListCell(targetUser: user)
                                } // NavigationLink
                                .padding(.horizontal, 20)
                            } // if
                        } // if
                    } // ForEach
                } // if
                
                // MARK: - GitSpace User가 아닌 유저의 리스트
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
            } // else
            
        } // ScrollView
        .task {
            await devideUser()            
        }
        .refreshable {
            await devideUser()
        }
        
    } // body
}

//struct ContributorListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContributorListView()
//    }
//}
