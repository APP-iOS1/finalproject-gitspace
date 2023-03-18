//
//  CurrentUserProfileView.swift
//  GitSpace
//
//  Created by 정예슬 on 2023/01/17.
//

import SwiftUI
import RichText

// MARK: - 자기자신의 정보를 나타내는 프로필 뷰 (Profile 탭)
struct CurrentUserProfileView: View {

    @EnvironmentObject var gitHubAuthManager: GitHubAuthManager
    @State private var markdownString = ""
    @State private var isFailedToLoadReadme = false

    let gitHubService = GitHubService()

    var body: some View {
        ScrollView(showsIndicators: false) {

            VStack(alignment: .leading, spacing: 10) {

                // MARK: -사람 이미지와 이름, 닉네임 등을 위한 stack.
                // FIXME: AsyncImage -> 캐시 이미지로 교체하면서 urlStr이 사용되지 않음, targetUserName을 실제로 호출받아서 넣어야 정상 작동함. By. 태영
                HStack(spacing: 20) {

                    if let avatarURL = gitHubAuthManager.authenticatedUser?.avatar_url {
                        GithubProfileImage(urlStr: avatarURL, size: 70)
                    } else {
                        DefaultProfileImage(size: 70)
                    }

                    VStack(alignment: .leading) {

                        if let name = gitHubAuthManager.authenticatedUser?.name {
                            // 내가 설정한 이름
                            GSText.CustomTextView(style: .title2, string: name)
                            Spacer()
                                .frame(height: 6)
                            // 내 깃허브 아이디
                            GSText.CustomTextView(style: .description, string: gitHubAuthManager.authenticatedUser?.login ?? "")
                        } else {
                            GSText.CustomTextView(style: .title2, string: gitHubAuthManager.authenticatedUser?.login ?? "")
                        }
                    }
                    Spacer()
                }
                    .padding(.bottom, 5)

                // MARK: - 프로필 Bio
                if let bio = gitHubAuthManager.authenticatedUser?.bio {
                    HStack {
                        GSText.CustomTextView(style: .body1, string: bio)
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

                // MARK: - 소속
                if let company = gitHubAuthManager.authenticatedUser?.company {
                    HStack {
                        Image(systemName: "building.2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .foregroundColor(.gsGray2)

                        GSText.CustomTextView(style: .captionPrimary1, string: company)
                    }
                }

                // MARK: - 위치 이미지, 국가 및 위치
                if let location = gitHubAuthManager.authenticatedUser?.location {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .foregroundColor(.gsGray2)

                        GSText.CustomTextView(style: .captionPrimary1, string: location)
                    }
                }

                // MARK: - 링크 이미지, 블로그 및 기타 링크
                if let blog = gitHubAuthManager.authenticatedUser?.blog, blog != "" {
                    HStack {
                        Image(systemName: "link")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .foregroundColor(.gsGray2)

                        if let blogURL = URL(string: blog) {
                            Link(destination: blogURL) {
                                GSText.CustomTextView(style: .captionPrimary1, string: blog)
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
                        Text("This Page Will Shows Followers List.")
                    } label: {
                        HStack {
                            GSText.CustomTextView(style: .title4, string: handleCountUnit(countInfo: gitHubAuthManager.authenticatedUser?.followers ?? 0))
                            GSText.CustomTextView(style: .sectionTitle, string: "followers")
                                .padding(.leading, -2)
                        }
                    }

                    Text("･")
                        .foregroundColor(.gsGray2)
                        .padding(.leading, -3)
                        .padding(.trailing, -9)

                    NavigationLink {
                        Text("This Page Will Shows Following List.")
                    } label: {
                        HStack {
                            GSText.CustomTextView(style: .title4, string: handleCountUnit(countInfo: gitHubAuthManager.authenticatedUser?.following ?? 0))
                            GSText.CustomTextView(style: .sectionTitle, string: "following")
                                .padding(.leading, -2)
                        }
                    }
                }

                Divider()
                    .frame(height: 1)
                    .overlay(Color.gsGray3)
                    .padding(.vertical, 10)

                if isFailedToLoadReadme {
                    FailToLoadReadmeView()
                } else {
                    // MARK: - 유저의 README
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

            } // vstack
            .padding(.horizontal, 20)
        }
            .onAppear {
                Task {
                    guard let userName = gitHubAuthManager.authenticatedUser?.login else { return }
                    let result = await gitHubService.requestRepositoryReadme(owner: userName, repositoryName: userName)

                    switch result {

                    case .success(let readme):
                        guard let content = Data(base64Encoded: readme.content, options: .ignoreUnknownCharacters) else {
                            isFailedToLoadReadme = true
                            return
                        }

                        guard let decodeContent = String(data: content, encoding: .utf8) else {
                            isFailedToLoadReadme = true
                            return
                        }

                        let htmlResult = await gitHubService.requestMarkdownToHTML(content: decodeContent)

                        switch htmlResult {
                        case .success(let result):
                            markdownString = result
                        case .failure:
                            isFailedToLoadReadme = true
                        }

                    case .failure:
                        isFailedToLoadReadme = true
                    }
                }
        }
    }
}



// MARK: - knock 버튼 눌렀을 때 뜨는 sheet view
struct knockSheetView: View {
    @Environment(\.dismiss) var dismiss

    @State var kncokMessage: String

    var body: some View {
        VStack {
            Group {
                Text("Let's Write Your Knock Message!!")
                TextField("I want to talk with you.", text: $kncokMessage)
            } .padding()
            Button {
                dismiss()
            } label: {
                Text("Knock Knock !!")
                    .bold()
                    .foregroundColor(Color(.systemBackground))
                    .padding()
                    .background(.black)
                    .cornerRadius(20)
            }
        }
    }
}

