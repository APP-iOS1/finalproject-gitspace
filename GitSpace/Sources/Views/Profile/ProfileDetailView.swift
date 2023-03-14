//
//  CurrentUserProfileView.swift
//  GitSpace
//
//  Created by 정예슬 on 2023/01/17.
//

import SwiftUI
import RichText

// MARK: - 재사용되는 profile section을 위한 뷰 (이미지, 이름, 닉네임, description, 위치, 링크, 팔로잉 등)
struct CurrentUserProfileView: View {

    let gitHubService = GitHubService()
    @EnvironmentObject var GitHubAuthManager: GitHubAuthManager
    @State private var markdownString = ""

    var body: some View {
        ScrollView(showsIndicators: false) {

            VStack(alignment: .leading, spacing: 10) {

                // MARK: -사람 이미지와 이름, 닉네임 등을 위한 stack.
                // FIXME: AsyncImage -> 캐시 이미지로 교체하면서 urlStr이 사용되지 않음, targetUserName을 실제로 호출받아서 넣어야 정상 작동함. By. 태영
                HStack(spacing: 20) {
                    Group {
                        let size: CGFloat = 70
                        if let avatarURL = GitHubAuthManager.authenticatedUser?.avatar_url {
                            GithubProfileImage(urlStr: avatarURL, size: size)
                        } else {
                            DefaultProfileImage(size: size)
                        }
                    }

                    VStack(alignment: .leading) {
                        // 이름
                        GSText.CustomTextView(style: .title2, string: GitHubAuthManager.authenticatedUser?.name ?? "")

                        Spacer()
                            .frame(height: 1)

                        // 닉네임
                        GSText.CustomTextView(style: .description, string: GitHubAuthManager.authenticatedUser?.login ?? "")
                    }

                    Spacer()
                }

                // MARK: - 프로필 Bio
                if let bio = GitHubAuthManager.authenticatedUser?.bio {
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
                } else {
                    EmptyView()
                }

                // MARK: - 소속
                if let company = GitHubAuthManager.authenticatedUser?.company {
                    HStack {
                        Image(systemName: "building.2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .foregroundColor(.gsGray2)

                        GSText.CustomTextView(style: .captionPrimary1, string: company)
                    }
                } else {
                    EmptyView()
                }

                // MARK: - 위치 이미지, 국가 및 위치
                if let location = GitHubAuthManager.authenticatedUser?.location {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .foregroundColor(.gsGray2)

                        GSText.CustomTextView(style: .captionPrimary1, string: location)
                    }
                } else {
                    EmptyView()
                }

                // MARK: - 링크 이미지, 블로그 및 기타 링크
                if let blog = GitHubAuthManager.authenticatedUser?.blog, blog != "" {
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
                } else {
                    EmptyView()
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
                            GSText.CustomTextView(style: .title4, string: handleCountUnit(countInfo: GitHubAuthManager.authenticatedUser?.followers ?? 0))
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
                            GSText.CustomTextView(style: .title4, string: handleCountUnit(countInfo: GitHubAuthManager.authenticatedUser?.following ?? 0))
                            GSText.CustomTextView(style: .sectionTitle, string: "following")
                                .padding(.leading, -2)
                        }
                    }
                }

                Divider()
                    .frame(height: 1)
                    .overlay(Color.gsGray3)
                    .padding(.vertical, 10)

                // MARK: - 유저의 README
                GSText.CustomTextView(style: .caption2, string: "README.md")

                GSCanvas.CustomCanvasView(style: .primary) {
                    RichText(html: markdownString)
                        .colorScheme(.auto)
                        .fontType(.system)
                        .linkOpenType(.SFSafariView())
                        .placeholder {
                        Image("GitSpace-Loading")
                        GSText.CustomTextView(style: .body1, string: "Loading README.md...")
                    }
                }
            } // vstack
            .padding(.horizontal, 20)
        }
            .onAppear {
                Task {
                    guard let userName = GitHubAuthManager.authenticatedUser?.login else { return }

                    let result = await gitHubService.requestRepositoryReadme(owner: userName, repositoryName: userName)

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

                        let htmlResult = await gitHubService.requestMarkdownToHTML(content: decodeContent)

                        switch htmlResult {
                        case .success(let result):
                            markdownString = result
                        case .failure:
                            markdownString = "fail to load README.md"
                        }
                        
                    case .failure(let error):
                        print(error)
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



//struct ProfileDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileDetailView()
//    }
//}
