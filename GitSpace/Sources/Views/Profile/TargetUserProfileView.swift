//
//  TargetUserProfileView.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/14.
//

import SwiftUI
import RichText

// MARK: - gitHubUser 필요

struct TargetUserProfileView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var gitHubAuthManager: GitHubAuthManager
    @EnvironmentObject var userInfoManager: UserStore
    @EnvironmentObject var blockedUsers: BlockedUsers
    @StateObject var targetUserProfileViewModel = TargetUserProfileViewModel(gitHubService: GitHubService())
    @State private var markdownString = ""
    @State private var followButtonLable: String = "➕ Follow"
    @State private var isShowingKnockSheet: Bool = false
    @State private var isGitSpaceUser = false
    @State private var isFailedToLoadReadme = false
    @State private var isEmptyReadme = false
    @State private var isBlockViewShowing = false
    @State private var isReportViewShowing = false
    @State private var isSuggestBlockViewShowing = false
    @State private var targetUserInfo: UserInfo? = nil
    @State private var isBlockedUser: Bool = false
    
    var isFromTopperProfileView: Bool = false
    let user: GithubUser
    let gitHubService = GitHubService()
    
    init(user: GithubUser) {
        self.user = user
    }
    
    init(user: GithubUser, isFromTopperProfileView: Bool) {
        self.user = user
        self.isFromTopperProfileView = isFromTopperProfileView
    }
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            if isBlockedUser {
                VStack {
                    GSText.CustomTextView(
                        style: .title3,
                        string: "This user is blocked user"
                    )
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    Color.gsRed
                )
            }
            
            VStack(spacing: 8) {
                
                VStack(alignment: .leading) {
                    // MARK: -사람 이미지와 이름, 닉네임 등을 위한 stack.
                    HStack(spacing: 10) {
                        GithubProfileImage(
                            urlStr: user.avatar_url,
                            size: 60
                        )
                        VStack(alignment: .leading) {
                            // 유저가 설정한 이름이 존재하는 경우
                            if let name = user.name {
                                GSText.CustomTextView(
                                    style: .title2,
                                    string: name
                                )
                                Spacer()
                                    .frame(height: 8)
                                // 유저의 깃허브 아이디
                                GSText.CustomTextView(
                                    style: .description,
                                    string: user.login
                                )
                            } else { // 유저가 설정한 이름이 존재하지 않는 경우, 유저의 깃허브 아이디만 보여준다.
                                GSText.CustomTextView(
                                    style: .title2,
                                    string: user.login
                                )
                            }
                        }
                        Spacer()
                    }
                    .padding(.bottom, 5)
                    
                    if let bio = user.bio {
                        // MARK: - bio
                        HStack() {
                            GSText.CustomTextView(
                                style: .body1,
                                string: bio
                            )
                            Spacer()
                        }
                        .padding(15)
                        .font(.callout)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.leading)
                        .background(Color.gsGray3)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                        )
                        .padding(.vertical, 10)
                    }
                    
                    if let company = user.company {
                        // MARK: - 소속
                        HStack {
                            Image(systemName: "building.2")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15, height: 15)
                                .foregroundColor(.gsGray2)
                            
                            GSText.CustomTextView(
                                style: .captionPrimary1,
                                string: company
                            )
                        }
                    }
                    
                    if let location = user.location {
                        // MARK: - 위치 이미지, 국가 및 위치
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15, height: 15)
                                .foregroundColor(.gsGray2)
                            
                            GSText.CustomTextView(
                                style: .captionPrimary1,
                                string: location
                            )
                        }
                    }
                    
                    if let blogURLString = user.blog, blogURLString != "" {
                        // MARK: - 링크 이미지, 블로그 및 기타 링크
                        HStack {
                            Image(systemName: "link")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15, height: 15)
                                .foregroundColor(.gsGray2)
                            
                            if let blogURL = URL(string: blogURLString) {
                                Link(destination: blogURL) {
                                    GSText.CustomTextView(
                                        style: .captionPrimary1,
                                        string: blogURLString
                                    )
                                    .multilineTextAlignment(.leading)
                                }
                            }
                        }
                    }
                    
                    // MARK: - 사람 심볼, 팔로워 및 팔로잉 수
                    HStack {
                        Image(systemName: "person")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .foregroundColor(.gsGray2)
                        
                        NavigationLink {
                            TargetUserFollowerListView(
                                service: gitHubService,
                                targetUserLogin: user.login,
                                followers: user.followers
                            )
                        } label: {
                            HStack {
                                GSText.CustomTextView(
                                    style: .title4,
                                    string: handleCountUnit(
                                        countInfo: user.followers
                                    )
                                )
                                GSText.CustomTextView(
                                    style: .sectionTitle,
                                    string: "followers"
                                )
                                .padding(.leading, -2)
                            }
                        } // NavigationLink
                        
                        Text("･")
                            .foregroundColor(.gsGray2)
                            .padding(.leading, -3)
                            .padding(.trailing, -9)
                        
                        NavigationLink {
                            TargetUserFollowingListView(
                                service: gitHubService,
                                targetUserLogin: user.login,
                                following: user.following
                            )
                        } label: {
                            HStack {
                                GSText.CustomTextView(
                                    style: .title4,
                                    string: handleCountUnit(
                                        countInfo: user.following
                                    )
                                )
                                GSText.CustomTextView(
                                    style: .sectionTitle,
                                    string: "following"
                                )
                                .padding(.leading, -2)
                            }
                        } // NavigationLink
                    }
                }
                
                // 내 프로필인지 아닌지에 따라 분기처리
                if user.login != gitHubAuthManager.authenticatedUser?.login {
                    // MARK: - follow, knock 버튼을 위한 stack
                    
                    // GitSpaceUser라면 팔로우/팔로잉, 노크 버튼 다 보여주고 아니라면 팔로우/팔로잉 버튼만 보이기
                    if isGitSpaceUser {
                        HStack {
                            // 누르면 follow, unfollow로 전환
                            GSButton.CustomButtonView(
                                style: .secondary(isDisabled: false)
                            ) {
                                Task {
                                    if targetUserProfileViewModel.isFollowingUser {
                                        // TODO: - 경고: 정말 unfollow 하시겠습니까?
                                        do {
                                            try await targetUserProfileViewModel.requestToUnfollowUser(who: user.login)
                                            targetUserProfileViewModel.isFollowingUser = false
                                        } catch(let error) {
                                            print(error)
                                        }
                                    } else {
                                        do {
                                            try await targetUserProfileViewModel.requestToFollowUser(who: user.login)
                                            targetUserProfileViewModel.isFollowingUser = true
                                        } catch(let error) {
                                            print(error)
                                        }
                                    }
                                }
                            } label: {
                                targetUserProfileViewModel.isFollowingUser ?
                                GSText.CustomTextView(
                                    style: .buttonTitle1,
                                    string: "✅ Following"
                                )
                                .frame(maxWidth: .infinity)
                                :
                                GSText.CustomTextView(
                                    style: .buttonTitle1,
                                    string: "➕ Follow"
                                )
                                .frame(maxWidth: .infinity)
                            }
                            
                            Spacer()
                                .frame(width: 10)
                            
                            if isFromTopperProfileView {
                                GSButton.CustomButtonView(
                                    style: .secondary(isDisabled: false)
                                ) {
                                    dismiss()
                                } label: {
                                    GSText.CustomTextView(
                                        style: .buttonTitle1,
                                        string: "Knock"
                                    )
                                    .frame(maxWidth: .infinity)
                                }
                            } else {
                                GSNavigationLink(style: .secondary()) {
                                    KnockCommunicationRouter(targetGithubUser: user)
                                } label: {
                                    GSText.CustomTextView(
                                        style: .buttonTitle1,
                                        string: "Knock")
                                    .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        .padding(.vertical, 10)
                    } else {
                        GSButton.CustomButtonView(
                            style: .secondary(isDisabled: false)
                        ) {
                            Task {
                                if targetUserProfileViewModel.isFollowingUser {
                                    // TODO: - 경고: 정말 unfollow 하시겠습니까?
                                    do {
                                        try await targetUserProfileViewModel.requestToUnfollowUser(who: user.login)
                                        targetUserProfileViewModel.isFollowingUser = false
                                    } catch(let error) {
                                        print(error)
                                    }
                                } else {
                                    do {
                                        try await targetUserProfileViewModel.requestToFollowUser(who: user.login)
                                        targetUserProfileViewModel.isFollowingUser = true
                                    } catch(let error) {
                                        print(error)
                                    }
                                }
                            }
                        } label: {
                            targetUserProfileViewModel.isFollowingUser ?
                            GSText.CustomTextView(
                                style: .buttonTitle1,
                                string: "✅ Following"
                            )
                            .frame(maxWidth: .infinity)
                            :
                            GSText.CustomTextView(
                                style: .buttonTitle1,
                                string: "➕ Follow"
                            )
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.vertical, 10)
                    }
                }
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color.gsGray3)
                    .padding(.vertical, 10)
                
                // MARK: - 유저의 README
                if isFailedToLoadReadme {
                    FailToLoadReadmeView()
                } else if isEmptyReadme {
                    ReadmeEmptyView()
                } else {
                    VStack {
                        HStack {
                            GSText.CustomTextView(
                                style: .caption2,
                                string: "README.md"
                            )
                            Spacer()
                        }
                        
                        RichText(html: markdownString)
                            .colorScheme(.auto)
                            .fontType(.system)
                            .linkOpenType(.SFSafariView())
                            .placeholder {
                                ReadmeLoadingView()
                            }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            if blockedUsers.blockedUserList.contains(where: {
                $0.1 == user
            }) {
                isBlockedUser = true
            } else {
                isBlockedUser = false
            }
            isGitSpaceUser = userInfoManager.users.contains { $0.githubID == user.id }
        }
        .task {
            targetUserInfo = await userInfoManager.requestUserInfoWithGitHubID(githubID: user.id)
            isGitSpaceUser = userInfoManager.users.contains { $0.githubLogin == self.user.login }
            
            let readMeRequestResult = await targetUserProfileViewModel.requestUserReadme(user: user.login)
            let isFollowingTargetUser = await targetUserProfileViewModel.checkAuthenticatedUserIsFollowing(who: user.login)
            
            if isFollowingTargetUser {
                followButtonLable = "✅ Following"
                targetUserProfileViewModel.isFollowingUser = true
            } else {
                followButtonLable = "➕ Follow"
                targetUserProfileViewModel.isFollowingUser = false
            }
            
            switch readMeRequestResult {
            case .success(let readmeString):
                markdownString = readmeString
            case .failure(let error):
                switch error {
                case .failToLoadREADME:
                    isFailedToLoadReadme = true
                case .unexpectedStatusCode:
                    isEmptyReadme = true
                default:
                    break
                }
            }
        }
        .halfSheet(isPresented: $isBlockViewShowing) {
            if let targetUserInfo {
                BlockView(
                    isBlockViewShowing: $isBlockViewShowing,
                    isBlockedUser: $isBlockedUser,
                    targetUser: targetUserInfo
                )
                .environmentObject(userInfoManager)
                .environmentObject(blockedUsers)
            }
        }
        .sheet(isPresented: $isReportViewShowing) {
            if let targetUser = targetUserInfo {
                ReportView(
                    isReportViewShowing: $isReportViewShowing,
                    isSuggestBlockViewShowing: $isSuggestBlockViewShowing,
                    targetUser: targetUser
                )
            }
        }
        .halfSheet(isPresented: $isSuggestBlockViewShowing) {
            SuggestBlockView(
                isBlockViewShowing: $isBlockViewShowing,
                isSuggestBlockViewShowing: $isSuggestBlockViewShowing
            )
        }
        .toolbar {
            if (isGitSpaceUser && userInfoManager.currentUser?.githubID != user.id) {
                Menu {
                    Section {
                        if !blockedUsers.blockedUserList.contains(where: { $0.gitHubUser == user }) {
                            Button(role: .destructive, action: {
                                /* Block 모달 뷰 appear */
                                isBlockViewShowing = true
                            }) {
                                Label("Block", systemImage: "nosign")
                            }
                        }
                        
                        Button(role: .destructive, action: {
                            /* Report 모달 뷰 appear */
                            isReportViewShowing = true
                        }) {
                            Label("Report", systemImage: "exclamationmark.bubble")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .frame(width: 40, height: 40)
                }
            }
        } //  body
    }
}
