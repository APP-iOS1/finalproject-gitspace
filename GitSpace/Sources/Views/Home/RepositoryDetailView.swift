//
//  RepositoryDetailView.swift
//  GitSpace
//
//  Created by yeeunchoi on 2023/01/17.
//

import SwiftUI
import RichText

struct RepositoryDetailView: View {
    
    @StateObject var repositoryDetailViewModel = RepositoryDetailViewModel(service: GitHubService())
    @StateObject var contributorViewModel = ContributorViewModel(service: GitHubService())
    @State private var selectedTagList: [Tag] = []
    @State private var markdownString: String = ""
    @State private var isFailedToLoadReadme = false
    @State private var isEmptyReadme = false
    
    let gitHubService: GitHubService
    let repository: Repository
    
    init(service: GitHubService, repository: Repository) {
        self.gitHubService = service
        self.repository = repository
    }
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            // MARK: - 레포 디테일 정보 섹션
            RepositoryInfoCard(service: GitHubService(), repository: repository, contributorViewModel: contributorViewModel)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            
            // MARK: - 레포에 부여된 태그 섹션
            RepositoryDetailViewTags(selectedTags: $selectedTagList, repository: repository)
                .padding(.horizontal, 20)
            
            Spacer()
            
            GSNavigationLink(style: .primary) {
                ContributorListView(service: GitHubService(), repository: repository, contributorManager: contributorViewModel)
                    .navigationTitle("Contributors")
            } label: {
                GSText.CustomTextView(style: .buttonTitle1, string:"✊🏻  Knock Knock!")
            }
            .disabled(contributorViewModel.isLoading)
            .padding(.top, 24)
            
            Divider()
                .frame(height: 1)
                .overlay(Color.gsGray3)
                .padding(.vertical, 24)
            
            if isFailedToLoadReadme {
                FailToLoadReadmeView()
            } else if isEmptyReadme {
                ReadmeEmptyView()
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
                .padding(.top, 15)
                .padding(.horizontal, 20)
            }
        }
//        .padding(.horizontal, 30)
        .onViewDidLoad {
            Task {
                let readMeResult = await repositoryDetailViewModel.requestReadMe(repository: repository)
                
                switch readMeResult {
                case .success(let result):
                    markdownString = result
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
                
                withAnimation(.easeInOut) {
                    contributorViewModel.isLoading = true
                }
                
                contributorViewModel.contributors.removeAll()
                contributorViewModel.temporaryContributors.removeAll()
                // TODO: - 현재 컨트리뷰터 리퀘스트는 한 페이지당 30명을 불러옴, 컨트리뷰터가 30명을 넘는 레포지토리는 페이지네이션 필요, 뷰의 변화가 필요할지도.
                // For-Loop (contributor pagination, infinite scroll)
                let contributorListResult = await contributorViewModel.requestContributors(repository: repository, page: 1)
                switch contributorListResult {
                case .success():
                    contributorViewModel.contributors = contributorViewModel.temporaryContributors
                    withAnimation(.easeInOut) {
                        contributorViewModel.isLoading = false
                    }
                case .failure(let error):
                    // contributor 목록을 가져오는데 실패했다는 에러
                    print(error)
                }
            }
        }
        .navigationBarTitle(repository.name, displayMode: .inline)
    }
}


struct RepositoryInfoCard: View {
    
    @ObservedObject var contributorViewModel: ContributorViewModel
    let gitHubService: GitHubService
    let repository: Repository
    
    init(service: GitHubService, repository: Repository, contributorViewModel: ContributorViewModel) {
        self.gitHubService = service
        self.repository = repository
        self.contributorViewModel = contributorViewModel
    }
    
    var body: some View {
        GSCanvas.CustomCanvasView(style: .primary) {
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
                        if contributorViewModel.isLoading {
                            ForEach(0..<10) { _ in
                                ContributorListSkeletonCell()
                            }
                        } else {
                            ForEach(contributorViewModel.contributors) { user in
                                NavigationLink(destination: TargetUserProfileView(user: user)) {
                                    GithubProfileImage(urlStr: user.avatar_url, size: 40)
                                }
                            }
                        }
                    }
                }
            }
        }
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
                        .foregroundColor(.primary)
                }
            }
            
            // 추가된 태그들
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(selectedTags, id: \.self) { tag in
                        // !!!: - 버튼 디자인시스템 변경 이전까지 다크모드에서 태그버튼이 주황색으로 표시됨
                        GSButton.CustomButtonView(
                            style: .tag(
                                isSelectedInAddTagSheet: true
                            )
                        ) {
                            
                        } label: {
                            // !!!: - 대응데이
                            // FIXME: - 태그버튼 사이즈 임시 축소, 추후 디자인 시스템에서 버튼 사이즈 통일 필요
                            Text(tag.tagName)
                                .padding(-10)
                        }
                        .padding(.horizontal, 5)
                    }
                }
            }
            
        }
        // FIXME: selectedTag의 값
        /// 실제로는 각 레포가 가지고 있는 태그가 들어와야 한다!
        .fullScreenCover(isPresented: $isTagSheetShowed) {
            AddTagSheetView(preSelectedTags: $selectedTags, selectedTags: selectedTags, beforeView: .repositoryDetailView, selectedRepository: repository)
        }
        .onAppear {
            Task {
                selectedTags = await tagViewModel.requestRepositoryTags(repositoryName: repository.fullName) ?? []
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
