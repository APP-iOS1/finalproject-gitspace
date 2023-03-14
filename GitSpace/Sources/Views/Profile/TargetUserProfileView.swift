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
    
    let user: GithubUser
    let gitHubService: GitHubService
    
    @EnvironmentObject var gitHubAuthManager: GitHubAuthManager
    @State private var markdownString = ""
    //follow/unfollow 버튼 lable(누를 시 텍스트 변환을 위해 state 변수로 선언)
    @State var followButtonLable: String = "+ Follow"
    //knock 버튼 눌렀을 때 sheet view 띄우는 것에 대한 Bool state var.
    @State var showKnockSheet: Bool = false
    
    init(service: GitHubService, user: GithubUser) {
        self.gitHubService = service
        self.user = user
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
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
                
                if let company =  user.company {
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
                
                if let location = user.location {
                    HStack { // MARK: - 위치 이미지, 국가 및 위치
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
                
                if let blogURLString = user.blog, blogURLString != "" {
                    HStack { // MARK: - 링크 이미지, 블로그 및 기타 링크
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
                            GSText.CustomTextView(style: .title4, string: handleCountUnit(countInfo: user.followers))
                            GSText.CustomTextView(style: .description, string: "followers")
                                .padding(.leading, -2)
                        }
                    }
//                    .padding(.trailing, 5)
                    
                    Text("･")
                        .foregroundColor(.gsGray2)
                        .padding(.leading, -3)
                        .padding(.trailing, -9)
                    
                    NavigationLink {
                        Text("This Page Will Shows Following List.")
                    } label: {
                        HStack {
                            GSText.CustomTextView(style: .title4, string: handleCountUnit(countInfo: user.following))
                            GSText.CustomTextView(style: .description, string: "following")
                                .padding(.leading, -2)
                        }
                    }
                }
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color.gsGray3)
                    .padding(.vertical, 10)
                
                // 내 프로필이 아니라 타인의 프로필에 뜨는 버튼
                HStack { // MARK: - follow, knock 버튼을 위한 stack
                    
                    // 누르면 follow, unfollow로 전환
                    GSButton.CustomButtonView(
                        style: .secondary(isDisabled: false)
                    ) {
                        withAnimation {
                            followButtonLable == "Unfollow" ? (followButtonLable = "+ Follow") : (followButtonLable = "Unfollow")
                        }
                    } label: {
                        GSText.CustomTextView(style: .title3, string: self.followButtonLable)
                            .frame(maxWidth: .infinity)
                    }
                    
                    Spacer()
                        .frame(width: 10)
                    
                    // 누르면 knock message를 쓸 수 있는 sheet를 띄우도록 state bool var toggle.
                    GSButton.CustomButtonView(
                        style: .secondary(isDisabled: false)
                    ) {
                        withAnimation {
                            showKnockSheet.toggle()
                        }
                    } label: {
                        GSText.CustomTextView(style: .title3, string: "Knock")
                            .frame(maxWidth: .infinity)
                    }
                    .sheet(isPresented: $showKnockSheet) {
    //                    SendKnockView()
                    }
                }
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
                        RichText(html: markdownString)
                            .colorScheme(.auto)
                            .fontType(.system)
                            .linkOpenType(.SFSafariView())
                            .placeholder {
                                Image("GitSpace-Loading")
                                GSText.CustomTextView(style: .body1, string: "Loading README.md...")
                            }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            
            Task {
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
                    
                    let htmlResult = await gitHubService.requestMarkdownToHTML(content: decodeContent)
                    
                    switch htmlResult {
                        
                    case .success(let result):
                        markdownString = result
                        
                    // markdown을 html로 변환 실패
                    case .failure:
                        markdownString = "fail to load README.md"
                    }
                    
                    // repository의 markdown을 요청 실패
                case .failure:
                    markdownString = "Fail to load README.md"
                }
            }
        }
        
    } //  body
}
