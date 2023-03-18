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

    @EnvironmentObject var gitHubAuthManager: GitHubAuthManager
    @EnvironmentObject var userInfoManager: UserStore
    @ObservedObject var viewModel = TargetUserProfileViewModel(gitHubService: GitHubService())

    @State private var markdownString = ""
    @State private var followButtonLable: String = "➕ Follow"
    @State private var isShowingKnockSheet: Bool = false
    @State private var isGitSpaceUser = false
    @State private var isFailedToLoadReadme = false

    let user: GithubUser

    init(user: GithubUser) {
        self.user = user
    }

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(spacing: 8) {

                VStack(alignment: .leading) {
                    // MARK: -사람 이미지와 이름, 닉네임 등을 위한 stack.
                    HStack(spacing: 10) {
                        GithubProfileImage(urlStr: user.avatar_url, size: 60)
                        VStack(alignment: .leading) {
                            // 유저가 설정한 이름이 존재하는 경우
                            if let name = user.name {
                                GSText.CustomTextView(style: .title2, string: name)
                                Spacer()
                                    .frame(height: 8)
                                // 유저의 깃허브 아이디
                                GSText.CustomTextView(style: .description, string: user.login)
                            } else { // 유저가 설정한 이름이 존재하지 않는 경우, 유저의 깃허브 아이디만 보여준다.
                                GSText.CustomTextView(style: .title2, string: user.login)
                            }
                        }
                        Spacer()
                    }
                        .padding(.bottom, 5)

                    if let bio = user.bio {
                        // MARK: - bio
                        VStack(alignment: .leading) {
                            GSText.CustomTextView(style: .body1, string: bio)
                        }
                            .padding(15)
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

                            GSText.CustomTextView(style: .captionPrimary1, string: company)
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

                            GSText.CustomTextView(style: .captionPrimary1, string: location)
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
                                    GSText.CustomTextView(style: .captionPrimary1, string: blogURLString)
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

                        // TODO: - NavigationLink: 팔로워 리스트
                        HStack {
                            GSText.CustomTextView(style: .title4, string: handleCountUnit(countInfo: user.followers))
                            GSText.CustomTextView(style: .description, string: "followers")
                                .padding(.leading, -2)
                        }

                        Text("･")
                            .foregroundColor(.gsGray2)
                            .padding(.leading, -3)
                            .padding(.trailing, -9)

                        // TODO: - NavigationLink: 팔로잉 리스트
                        HStack {
                            GSText.CustomTextView(style: .title4, string: handleCountUnit(countInfo: user.following))
                            GSText.CustomTextView(style: .description, string: "following")
                                .padding(.leading, -2)
                        }
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
                                    if viewModel.isFollowingUser {
                                        // TODO: - 경고: 정말 unfollow 하시겠습니까?
                                        do {
                                            try await viewModel.requestToUnfollowUser(who: user.login)
                                            viewModel.isFollowingUser = false
                                        } catch(let error) {
                                            print(error)
                                        }
                                    } else {
                                        do {
                                            try await viewModel.requestToFollowUser(who: user.login)
                                            viewModel.isFollowingUser = true
                                        } catch(let error) {
                                            print(error)
                                        }
                                    }
                                }
                            } label: {
                                viewModel.isFollowingUser ?
                                GSText.CustomTextView(style: .title3, string: "✅ Following")
                                    .frame(maxWidth: .infinity)
                                :
                                    GSText.CustomTextView(style: .title3, string: "➕ Follow")
                                    .frame(maxWidth: .infinity)
                            }

                            Spacer()
                                .frame(width: 10)

                            // 누르면 knock message를 쓸 수 있는 sheet를 띄우도록 state bool var toggle.
                            GSButton.CustomButtonView(
                                style: .secondary(isDisabled: false)
                            ) {
                                withAnimation {
                                    isShowingKnockSheet.toggle()
                                }
                            } label: {
                                GSText.CustomTextView(style: .title3, string: "Knock")
                                    .frame(maxWidth: .infinity)
                            }
                                .sheet(isPresented: $isShowingKnockSheet) {
//                                    SendKnockView()
                            }
                        }
                            .padding(.vertical, 10)
                    } else {
                        GSButton.CustomButtonView(
                            style: .secondary(isDisabled: false)
                        ) {
                            Task {
                                if viewModel.isFollowingUser {
                                    // TODO: - 경고: 정말 unfollow 하시겠습니까?
                                    do {
                                        try await viewModel.requestToUnfollowUser(who: user.login)
                                        viewModel.isFollowingUser = false
                                    } catch(let error) {
                                        print(error)
                                    }
                                } else {
                                    do {
                                        try await viewModel.requestToFollowUser(who: user.login)
                                        viewModel.isFollowingUser = true
                                    } catch(let error) {
                                        print(error)
                                    }
                                }
                            }
                        } label: {
                            viewModel.isFollowingUser ?
                            GSText.CustomTextView(style: .title3, string: "✅ Following")
                                .frame(maxWidth: .infinity)
                            :
                                GSText.CustomTextView(style: .title3, string: "➕ Follow")
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
                } else {
                    VStack {
                        HStack {
                            GSText.CustomTextView(style: .caption2, string: "README.md")
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
            .task {

            isGitSpaceUser = userInfoManager.users.contains { $0.githubLogin == self.user.login }

            let readMeRequestResult = await viewModel.requestUserReadme(user: user.login)
            let isFollowingTargetUser = await viewModel.checkAuthenticatedUserIsFollowing(who: user.login)

            if isFollowingTargetUser {
                followButtonLable = "✅ Following"
                viewModel.isFollowingUser = true
            } else {
                followButtonLable = "➕ Follow"
                viewModel.isFollowingUser = false
            }

            switch readMeRequestResult {
            case .success(let readmeString):
                markdownString = readmeString
            case .failure:
                isFailedToLoadReadme = true
            }
        }

    } //  body
}
