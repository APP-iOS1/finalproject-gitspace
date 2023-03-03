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
    
    init(service: GitHubService, repository: Repository, contributorManager: ContributorViewModel) {
        self.gitHubService = service
        self.repository = repository
        self.contributorManager = contributorManager
    }
    
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
                    .padding(.vertical, 25)
                
                Spacer()
            }
            
            HStack {
                GSText.CustomTextView(
                    style: .title2,
                    string: "Who do you want to chat with?")
                
                Spacer()
            }
            .padding(.leading, 20)
            
            
            
            
            // MARK: - 컨트리뷰터 명단 스크롤 뷰
            /* 서브 캡션 */
            HStack {
                GSText.CustomTextView(
                    style: .caption1,
                    string:
"""
You can chat with GitSpace User.
Please select a User to start chatting with.
"""
                )
                Spacer()
            }
            .padding(.leading, 20)
            .padding(.top, -10)
            
            Divider()
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            
            HStack {
                GSText.CustomTextView(
                    style: .caption1,
                    string: "GitSpace User  ⎯  \(contributorManager.contributors.count)")
                Spacer()
            }
            .padding(.leading, 20)
            
            ForEach(contributorManager.contributors) { user in
                
                NavigationLink(destination: Text("SendKnock View로 랜딩할 예정")) {
                    ContributorGitSpaceUserListCell(targetUser: user)
                } // NavigationLink
                .padding(.horizontal, 20)
            } // ForEach
            
            Divider()
                .padding([.top, .horizontal], 20)
                .padding(.bottom, 10)
            
            HStack {
                GSText.CustomTextView(
                    style: .caption1,
                    string: "Non-GitSpace User  ⎯  \(contributorManager.contributors.count)")
                Spacer()
            }
            .padding(.leading, 20)
            
            
            
            ForEach(contributorManager.contributors) { user in
                
                ContributorListCell(targetUser: user)
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
