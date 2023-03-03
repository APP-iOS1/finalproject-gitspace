//
//  ContributorListView.swift
//  GitSpace
//
//  Created by yeeunchoi on 2023/01/18.
//

import SwiftUI
import FirebaseAuth

struct ContributorListView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var userInfoManager: UserStore
    @ObservedObject var contributorManager: ContributorViewModel
    public let gitHubService: GitHubService
    public let repository: Repository
    
    // MARK: - BODY
    var body: some View {
        
        ScrollView {
            Spacer()
                .frame(height: 20)
            
            GSText.CustomTextView(
                style: .title2,
                string: "Who do you want to chat with?"
			)
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
                
				NavigationLink {
					// 어떤 유저의 정보를 전달할 것인지만 정하면 된다.
					// user.id == 내가 보낼 상대방의 id
					// currentuserid == 내 id
					SendKnockView(
						sendKnockToGitHubUser: user
					)
				} label: {
                    let url = URL(string: user.avatar_url)
                    
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
	
	// MARK: - LIFECYCLE
	init(service: GitHubService, repository: Repository, contributorManager: ContributorViewModel) {
		self.gitHubService = service
		self.repository = repository
		self.contributorManager = contributorManager
	}
}

//struct ContributorListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContributorListView()
//    }
//}
