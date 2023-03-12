//
//  RepositoryDetailView.swift
//  GitSpace
//
//  Created by yeeunchoi on 2023/01/17.
//

import SwiftUI
import RichText

struct RepositoryDetailView: View {
    @State private var selectedTagList: [Tag] = []
    @State private var markdownString: String = ""
    @StateObject var contributorViewModel = ContributorViewModel(service: GitHubService())
    @StateObject var repositoryDetailViewModel = RepositoryDetailViewModel(service: GitHubService())
    
    let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    var body: some View {
        
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
            RepositoryInfoCard(service: GitHubService(), repository: repository, contributorManager: contributorViewModel)
                .padding(.bottom, 20)
            
            // MARK: - 레포에 부여된 태그 섹션
            RepositoryDetailViewTags(selectedTags: $selectedTagList, repository: repository)

            Spacer()
            
            GSNavigationLink(style: .primary) {
                ContributorListView(service: GitHubService(), repository: repository, contributorManager: contributorViewModel)
                    .navigationTitle("Contributors")
            } label: {
                GSText.CustomTextView(style: .title3, string:"✊🏻  Knock Knock!")
            }
            
            
            RichText(html: markdownString)
                .colorScheme(.auto)
                .fontType(.system)
                .linkOpenType(.SFSafariView())
                .placeholder {
                    VStack {
                        Image("GitSpace-Loading")
                        GSText.CustomTextView(style: .body1, string: "Loading README.md...")
                    }
                }
            
        }
        .padding(.horizontal, 30)
        .task {
            markdownString = await repositoryDetailViewModel.requestReadMe(repository: repository)
            contributorViewModel.contributors.removeAll()
            contributorViewModel.temporaryContributors.removeAll()
            // TODO: - 현재 컨트리뷰터 리퀘스트는 한 페이지당 30명을 불러옴, 컨트리뷰터가 30명을 넘는 레포지토리는 페이지네이션 필요, 뷰의 변화가 필요할지도.
            // For-Loop (contributor pagination, infinite scroll)
            let contributorListResult = await contributorViewModel.requestContributors(repository: repository, page: 1)
            switch contributorListResult {
            case .success():
                contributorViewModel.contributors = contributorViewModel.temporaryContributors
            case .failure(let error):
                // contributor 목록을 가져오는데 실패했다는 에러
                print(error)
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
                        NavigationLink(destination: UserProfileView(user: user)) {
                            GithubProfileImage(urlStr: user.avatar_url, size: 40)
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

    @Binding var selectedTags: [Tag]
    @State var isTagSheetShowed: Bool = false
    @EnvironmentObject var tagViewModel: TagViewModel
    
    let repository: Repository

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
            AddTagSheetView(preSelectedTags: $selectedTags, selectedTags: selectedTags, beforeView: .repositoryDetailView, repositoryName: repository.fullName)
        }
        .onAppear {
            Task {
                selectedTags = await tagViewModel.requestRepositoryTags(repositoryName: repository.fullName) ?? []
                let _ = print("++++", selectedTags)
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
