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
                                // TODO: - [GITHUB API] 유저 프로필 내용으로 바꾸기
                                Image("avatarImage")
                                    .frame(width: 64)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("@" + "\(user.userName)")
                                        .font(.title3)
                                        .bold()
                                    
                                    HStack {
                                        Group {
                                            Text("\(user.followerCount)")
                                                .bold()
                                                .padding(.trailing, -5)
                                            Text("followers")
                                        }
                                        .font(.callout)
                                        
                                        Text("·")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        
                                        Group {
                                            Text("\(user.repoCount)")
                                                .bold()
                                                .padding(.trailing, -5)
                                            Text("repos")
                                        }
                                        .font(.callout)
                                    }
                                    
                                }
                            }
                            
                            Spacer()
                                .frame(height: 20)
                            
                            // MARK: - NewKnockView로 이동하는 챗 버튼
                            // TODO: - 버튼 추상화 후 네비링크버튼 타입으로 바꾸기
                            NavigationLink {
                                NewKnockView()
                            } label: {
                                Text("Let's Chat!")
                                    .font(.callout)
                                    .foregroundColor(.primary)
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 23)
                                    .background(Color.gsGreenPrimary)
                                    .cornerRadius(20)
                            }
                        }
                        .padding(.vertical, 21)
                        .padding(.horizontal, 17)
                        
                        // TODO: - 추상화 후 백그라운드를 캔버스 디자인시스템으로 바꾸기
                        .background(
                            RoundedRectangle(cornerRadius: 35, style: .continuous)
                                .fill(.white)
                                .shadow(color: Color(uiColor: UIColor.systemGray5), radius: 6, x: 0, y: 2)
                        )
                    }
                    
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 4)
            }
            
        }
        
        
    }
}

struct ChatRecommandCardSection_Previews: PreviewProvider {
    static var previews: some View {
        ChatRecommandCardSection()
    }
}
