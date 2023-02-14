//
//  RepositoryDetailView.swift
//  GitSpace
//
//  Created by yeeunchoi on 2023/01/17.
//

import SwiftUI
import MarkdownUI


struct RepositoryDetailView: View {
    @State private var selectedTagList: [Tag] = []
    @State private var markdownString: String = ""
    @StateObject var contributorViewModel = ContributorViewModel()
    
    let gitHubService: GitHubService
    let repository: Repository
    
    init(service: GitHubService, repository: Repository) {
        self.gitHubService = service
        self.repository = repository
    }
    
    var body: some View {
        // TODO: - 정보가 많아지면 ScrollView 로 변경 고려해볼것
        ScrollView(showsIndicators: false) {
//
//            HStack {
//                Image("GuideImage")
//                // FIXME: - star를 누른 사람의 이름 주입
//                Text("Check out what **Random Brazil Guy** just starred!")
//                    .font(.footnote)
//                    .foregroundColor(.secondary)
//                Spacer()
//            }
//            .padding(.bottom, 10)
            
            
            // MARK: - 레포 디테일 정보 섹션
            RepositoryInfoCard(service: gitHubService, repository: repository, contributorManager: contributorViewModel)
                .padding(.bottom, 20)
            
            // MARK: - 레포에 부여된 태그 섹션
            RepositoryDetailViewTags(selectedTags: $selectedTagList)

            Spacer()
            
            GSNavigationLink(style: .primary) {
                ContributorListView()
                    .navigationTitle("Contributors")
            } label: {
                GSText.CustomTextView(style: .title3, string:"✊🏻  Knock Knock!")
            }
            
            Markdown {
                markdownString
            }
            .markdownTheme(.gitHub)
            .padding(.vertical, 5)
            
        }
        .padding(.horizontal, 30)
        .onAppear {
            
            Task {
                let readMeResult = await gitHubService.requestRepositoryReadme(owner: repository.owner.login, repositoryName: repository.name)
                
                switch readMeResult {
                    
                case .success(let response):
                    guard let content = Data(base64Encoded: response.content, options: .ignoreUnknownCharacters) else {
                        markdownString = "Fail to read README.md"
                        return
                    }
                    
                    guard let decodeContent = String(data: content, encoding: .utf8) else {
                        markdownString = "Fail to read README.md"
                        return
                    }
                    
                    markdownString = decodeContent
                    
                case .failure(let error):
                    print(error)
                }
                
                let contributorsResult = await gitHubService.requestRepositoryContributors(owner: repository.owner.login, repositoryName: repository.name, page: 1)
                
                switch contributorsResult {
                case .success(let users):
                    contributorViewModel.contributors.removeAll()
                    for user in users {
                        let result = await gitHubService.requestUserInformation(userName: user.login)
                        switch result {
                        case .success(let user):
                            contributorViewModel.contributors.append(user)
                        case .failure(let error):
                            print(error)
                        }
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        }
        .navigationBarTitle(repository.name, displayMode: .inline)
    }
}


struct RepositoryInfoCard: View {

    @ObservedObject var contributorManager: ContributorViewModel
    let gitHubService: GitHubService
    let repository: Repository
    
    init(service: GitHubService, repository: Repository, contributorManager: ContributorViewModel) {
        self.gitHubService = service
        self.repository = repository
        self.contributorManager = contributorManager
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // 레포 타이틀
            GSText.CustomTextView(style: .title1, string: repository.name)
            
            // 레포 설명글
            GSText.CustomTextView(style: .body1, string: repository.description ?? "This Repository has no description")
            
            GSText.CustomTextView(style: .body2, string: "⭐️ \(repository.stargazersCount) stars")
            
            Divider()
            
            // Contributors 섹션 타이틀
            GSText.CustomTextView(style: .title3, string: "Contributors")
            
            // Contributors 유저 프로필들
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(contributorManager.contributors) { user in
                        
                        NavigationLink(destination: UserProfileView(service: gitHubService, user: user)) {
                            
                            let url = URL(string: user.avatar_url)
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            } placeholder: {
                                Image("avatarImage")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .shadow(color: .gray, radius: 3, x: 1, y: 2)
                .opacity(0.2)
        )
    }
}



struct RepositoryDetailViewTags: View {
//    let tags: [String] = ["thisis", "my", "tags", "hehe"]
    @Binding var selectedTags: [Tag]
    @State var isTagSheetShowed: Bool = false
    @EnvironmentObject var tagViewModel: TagViewModel

    var body: some View {
        VStack(alignment: .leading) {
            
            // 태그 섹션 타이틀
            HStack {
                Text("**My Tags**")
                    .font(.title2)
                
                // 태그 추가 버튼
                Button {
                    // MainHomeView 코드 붙붙
                    isTagSheetShowed = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                }
            }
            
            // 추가된 태그들
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(selectedTags, id: \.self) { tag in
                        // !!!: - 버튼 디자인시스템 변경 이전까지 다크모드에서 태그버튼이 주황색으로 표시됨
                        GSButton.CustomButtonView(
                            style: .tag(
                                isSelected: true,
                                isEditing: false)
                        ) {

                        } label: {
                            // !!!: - 대응데이
                            // FIXME: - 태그버튼 사이즈 임시 축소, 추후 디자인 시스템에서 버튼 사이즈 통일 필요
                            Text(tag.tagName)
                            .padding(-10)

                        }
                    }
                }
            }
            
        }
        // FIXME: selectedTag의 값
        /// 실제로는 각 레포가 가지고 있는 태그가 들어와야 한다!
        .fullScreenCover(isPresented: $isTagSheetShowed) {
            AddTagSheetView(preSelectedTags: $selectedTags, selectedTags: selectedTags, beforeView: .repositoryDetailView)
        }
        .onAppear {
            Task {
                selectedTags = await tagViewModel.requestRepositoryTags(repositoryName: "wwdc/2022") ?? []
                
            }
        }
    }
}



//struct RepositoryDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            RepositoryDetailView(service: GitHubService())
//        }
//    }
//}
