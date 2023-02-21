//
//  ContributorListView.swift
//  GitSpace
//
//  Created by yeeunchoi on 2023/01/18.
//

import SwiftUI

struct ContributorListView: View {
    
    @ObservedObject var contributorManager: ContributorViewModel
    let gitHubService: GitHubService
    let repository: Repository
    
    init(service: GitHubService, repository: Repository, contributorManager: ContributorViewModel) {
        self.gitHubService = service
        self.repository = repository
        self.contributorManager = contributorManager
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    let contributors: [String] = ["contributor1", "contributor2", "contributor3"]
    
    var body: some View {
        
        ScrollView {
            Spacer()
                .frame(height: 20)
            
            GSText.CustomTextView(
                style: .title2,
                string: "Who do you want to chat with?")
            .padding(.leading, 10)
            .padding(.bottom, -5)
            
            // MARK: - 상황별 마스코트 이미지
            /* 노트 시나리오의 시각적 힌트 제공 */
            HStack {
                Spacer()
                
                Image("GitSpace-ContributorListView")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width - 250)
                    .padding(.vertical, 30)
                
                Spacer()
            }
            
            // MARK: - 컨트리뷰터 명단 스크롤 뷰
            /* 서브 캡션 */
            HStack {
                GSText.CustomTextView(
                    style: .caption1,
                    string: "Choose a user to start your chat.")
                Spacer()
            }
            .padding(.leading, 20)
            .padding(.bottom, 5)
            
            ForEach(contributorManager.contributors) { user in
                
                NavigationLink(destination: SendKnockView()) {
                    GSCanvas.CustomCanvasView.init(style: .primary, content: {
                        HStack(spacing: 15) {
                            /* 유저 프로필 이미지 */
                            GithubProfileImage(urlStr: user.avatar_url, size: 40)
                            
                            VStack(alignment: .leading) {
                                /* 유저네임 */
                                GSText.CustomTextView(
                                    style: .title3,
                                    string: user.name ?? user.login)
                                
                                /* 유저ID */
                                GSText.CustomTextView(
                                    style: .sectionTitle,
                                    string: user.login)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gsGray2)
                        } // HStack
                    }) // GSCanvas
                } // NavigationLink
                .padding(.horizontal, 20)
            } // ForEach
        } // ScrollView
    } // body
}

//struct ContributorListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContributorListView()
//    }
//}
