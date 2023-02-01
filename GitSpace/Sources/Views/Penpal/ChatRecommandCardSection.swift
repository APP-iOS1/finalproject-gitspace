//
//  ChatRecommandCardSection.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/31.
//

import SwiftUI


struct DummyUserInfo: Hashable, Identifiable {
    var id: UUID = UUID()
    let userName: String
    let followerCount: String
    let repoCount: String
}

struct ChatRecommandCardSection: View {
    @State private var isDisabled = false
    @State private var isEditing = false
    @State private var isSelected = false
    
    @Environment(\.colorScheme) var colorScheme
    
    let userInfo1 = DummyUserInfo(userName: "randombrazilguy", followerCount: "1.9k", repoCount: "20")
    let userInfo2 = DummyUserInfo(userName: "randombrazilgirl", followerCount: "3.3k", repoCount: "61")
    let userInfo3 = DummyUserInfo(userName: "randombrazilmama", followerCount: "340", repoCount: "44")
    
    
    var body: some View {
        let recommendedUsers = [userInfo1, userInfo2, userInfo3]
        
        // MARK: - 단일 카드 컴포넌트
        VStack(alignment: .leading) {
            
            // TODO: - 모든 gray 컬러 gsGray로 변경 예정
            Text("Recommended “pals” for you 👋")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom, -10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(recommendedUsers) { user in
                        VStack(alignment: .trailing) {
                            HStack {
                                // TODO: - 유저 프로필로 교체 예정
                                Circle()
                                    .frame(width: 64)
                                    .padding(.trailing, 10)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("@" + "\(user.userName)")
                                        .font(.title3)
                                        .bold()
                                    
                                    HStack {
                                        Group {
                                            Text("\(user.followerCount)").bold() + Text(" ") + Text("followers")
                                        }
                                        .font(.callout)
                                        
                                        Text("·")
                                        
                                        Group {
                                            Text("\(user.repoCount)").bold() + Text(" ") + Text("repos")
                                        }
                                        .font(.callout)
                                    }
                                    
                                }
                            }
                            
                            Spacer()
                                .frame(height: 20)
                            
                            // TODO: - 네비링크버튼 추상화 완료시 코드 바꾸기
							NavigationLink {
								NewKnockView()
							} label: {
								GSButton.CustomButtonView(
									style: .secondary(
										isDisabled: false
								)) {
									
								} label: {
									Text("💬 Chat")
								}
								.disabled(true)
							}
                        }
                        .padding(.vertical, 21)
                        .padding(.horizontal, 17)
                        .background(
                            RoundedRectangle(cornerRadius: 35, style: .continuous)
                                .fill(.white)
                                .shadow(color: Color(uiColor: UIColor.systemGray6), radius: 8, x: 0, y: 2)
                        )
                    }
                    
                }
                .padding(.vertical, 20)
            }
            
        }
        
        
    }
}

struct ChatRecommandCardSection_Previews: PreviewProvider {
    static var previews: some View {
        ChatRecommandCardSection()
    }
}
