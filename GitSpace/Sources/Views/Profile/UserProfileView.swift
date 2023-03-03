//
//  UserProfileView.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/14.
//

import SwiftUI
import MarkdownUI

// MARK: - gitHubUser 필요

struct UserProfileView: View {

    let user: GithubUser
    let gitHubService: GitHubService

    @EnvironmentObject var gitHubAuthManager: GitHubAuthManager

    @State private var markdownString = ""

    init(service: GitHubService, user: GithubUser) {
        self.gitHubService = service
        self.user = user
    }


    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {

                HStack { // MARK: -사람 이미지와 이름, 닉네임 등을 위한 stack.

                    GithubProfileImage(urlStr: user.avatar_url, size: 60)

                    VStack(alignment: .leading) { // 이름, 닉네임
                        GSText.CustomTextView(style: .title2, string: user.name ?? "")
                        Spacer()
                            .frame(height: 8)
                        GSText.CustomTextView(style: .description, string: user.login)
                    }

                    Spacer()
                }



                // bio

                if let bio = user.bio {
                    VStack {
                        GSText.CustomTextView(style: .body1, string: bio)
                    }
                        .padding(15)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.leading)
                        .background(Color.gsGray3)
                        .clipShape(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                    )
                        .padding(.vertical, 20)
                } else {
                    EmptyView()
                }

                if let location = user.location {
                    HStack { // MARK: - 위치 이미지, 국가 및 위치
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.gsGray2)
                        GSText.CustomTextView(style: .description, string: location)
                    }
//                        .foregroundColor(Color(.systemGray))
                } else {
                    EmptyView()
                }

                if let blogURLString = user.blog, blogURLString != "" {
                    HStack { // MARK: - 링크 이미지, 블로그 및 기타 링크
                        Image(systemName: "link")
                            .foregroundColor(.gsGray2)
                        if let blogURL = URL(string: blogURLString) {
                            Link(destination: blogURL) {
                                GSText.CustomTextView(style: .body1, string: blogURLString)
                            }
                        }
                    }
                } else {
                    EmptyView()
                }

                HStack { // MARK: - 사람 심볼, 팔로워 및 팔로잉 수
                    Image(systemName: "person")
                        .foregroundColor(.gsGray2)

                    NavigationLink {
                        Text("This Page Will Shows Followers List.")
                    } label: {
                        HStack {
                            GSText.CustomTextView(style: .title3, string: handleCountUnit(countInfo: user.followers ?? 0))
                            GSText.CustomTextView(style: .description, string: "followers")
                                .padding(.leading, -2)
                        }
                    }
                        .padding(.trailing, 5)

                    Text("|")
                        .foregroundColor(.gsGray3)
                        .padding(.trailing, 5)

                    NavigationLink {
                        Text("This Page Will Shows Following List.")
                    } label: {
                        HStack {
                            GSText.CustomTextView(style: .title3, string: handleCountUnit(countInfo: user.following ?? 0))
                            GSText.CustomTextView(style: .description, string: "following")
                                .padding(.leading, -2)
                        }
                    }
                }

                Divider()
                    .frame(height: 1)
                    .overlay(Color.gsGray3)
                    .padding(.vertical, 20)


                // MARK: - 유저의 README

                if markdownString == "Fail to read README.md" {
                    
                    GSText.CustomTextView(style: .title2, string: markdownString)
                        .frame(maxWidth: .infinity)
                    
                    GSCanvas.CustomCanvasView(style: .primary) {
                        Image("GitSpace-Block")
                    }
                        .frame(maxWidth: .infinity)
                } else {
                    GSText.CustomTextView(style: .caption2, string: "README.md")
                    GSCanvas.CustomCanvasView(style: .primary) {
                        Markdown {
                            markdownString
                        }
                        .multilineTextAlignment(.center)
                    }
                }


                Spacer()
            }
                .padding(.horizontal, 20)
        }
            .onAppear {
            Task {

//                guard let userName = gitHubAuthManager.authenticatedUser?.login else { return }

                let result = await gitHubService.requestRepositoryReadme(owner: user.login, repositoryName: user.login)

                switch result {

                case .success(let readme):
                    guard let content = Data(base64Encoded: readme.content, options: .ignoreUnknownCharacters) else {
                        markdownString = "Fail to read README.md"
                        return
                    }

                    guard let decodeContent = String(data: content, encoding: .utf8) else {
                        markdownString = "Fail to read README.md"
                        return
                    }

                    markdownString = decodeContent
                case .failure:
                    markdownString = "Fail to read README.md"

                }
            }
        }
    }
}
