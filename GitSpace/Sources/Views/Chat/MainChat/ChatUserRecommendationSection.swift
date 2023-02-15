//
//  ChatRecommandCardSection.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/31.
//

import SwiftUI

struct ChatUserRecommendationSection: View {
    
    let gitHubService = GitHubService()
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject var followerViewModel: FollowerViewModel
    @State var currentIndex: Int = 0
    
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            /* 유저 추천 카드 안내 메세지 */
            GSText.CustomTextView(
                style: .caption1,
                string: ("Recommended users for you 👋"))
            .padding(.bottom, -10)
                
        
            
            // MARK: -  카드 페이지네이션 Carousel
            Carousel(index: $currentIndex, items: followerViewModel.followers) { user in

                GeometryReader { proxy in
                    
                    VStack(alignment: .trailing) {
                        
                        HStack {
                            
                            AsyncImage(url: URL(string: user.avatar_url)!) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                
                            } placeholder: {
                                Image("avatarImage")
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                
                                HStack {
                                    /* 유저 깃헙아이디 (username) */
                                    GSText.CustomTextView(
                                        style: .title2,
                                        string: ("@" + "\(user.login)"))
                                        .lineLimit(1)
                                    Spacer()
                                }

                                HStack {
                                    Group {
                                        /* 유저 팔로워 수 */
                                        /// 팔로워 수 >= 1000 일 때, ~k 단위로 처리
                                        GSText.CustomTextView(
                                            style: .title3,
                                            string: handleCountUnit(countInfo: user.followers))
                                            .padding(.trailing, -5)
                                        
                                        GSText.CustomTextView(
                                            style: .body1,
                                            string: "followers")
                                    }
                                    .font(.callout)

                                    Text("·")
                                        .font(.caption2)
                                        .foregroundColor(.gray)

                                    Group {
                                        /* 유저 레포 수 */
                                        /// 레포 개수 >= 1000 일 때, ~k 단위로 처리
                                        // TODO: 버튼 라벨 같은 것들 Constant로 다 빼기
                                        GSText.CustomTextView(
                                            style: .title3,
                                            string: handleCountUnit(countInfo: user.public_repos))
                                            .padding(.trailing, -5)
                                        
                                        GSText.CustomTextView(
                                            style: .body1,
                                            string: "repos")
                                    }

                                }
     
                            }
                        }

                        Spacer()
                            .frame(height: 20)

                        // MARK: - NewKnockView로 이동하는 챗 버튼
                        GSNavigationLink(style: .secondary) {
                            SendKnockView()
                        } label: {
                            // TODO: - GSText로 바꿔주기 (색이 안입혀져서 일단 일반 텍스트로)
//                            GSText.CustomTextView(style: .title3, string: "Let's chat!")
                            Text("💬 Let's chat!")
                                .font(.footnote)
                                .bold()
                                .foregroundColor(.black)
                        }

                    }
                    .padding(17)
                    

                    // TODO: - 캔버스 디자인시스템에 .secondary 스타일 속성으로 추가하기
                    .background(
                        RoundedRectangle(cornerRadius: 35, style: .continuous)
                            .fill(colorScheme == .light ? .white : .gsGray3)
                            .shadow(color: .gsGray2.opacity(colorScheme == .dark ? 0.0 : 0.3), radius: 6, x: 0, y: 2)
                    )

                }

            }
            .frame(height: 120)
            .padding(.vertical,20)
            
     
            
            
            // MARK: - Carousel 인디케이터 (하단 "...")
            HStack {
                
                Spacer()
                
                ForEach(followerViewModel.responses.indices,id: \.self) { index in
                    
                    Circle()
                        .fill(Color.gsGreenPrimary.opacity(currentIndex == index ? 1 : 0.3))
                        .frame(width: 7, height: 7)
                        .scaleEffect(currentIndex == index ? 1.4 : 1)
                        .animation(.spring(), value: currentIndex == index)
                }
                
                Spacer()
            }
            .padding(.vertical, 20)

        }

    }

}




// MARK: -  카드 페이지네이션 Carousel 내부 코드
struct Carousel<Content: View, T: Identifiable>: View {
    var content: (T) -> Content
    var list: [T]
    
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    
    init(spacing: CGFloat = 10,
         trailingSpace: CGFloat = 60,
         index: Binding<Int>,
         items: [T],
         @ViewBuilder content: @escaping (T)->Content) {
        
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }
    
    
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    var body: some View {
        
        GeometryReader { proxy in
            
            let width = proxy.size.width - (trailingSpace - spacing)
            let adjustMentWidth = (trailingSpace / 2) - spacing
            
            HStack(spacing: spacing) {
                
                ForEach(list) { item in
                    
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                }
            }
            .padding(.horizontal,spacing)
            .offset(x: (CGFloat(currentIndex) * -width) + (currentIndex != 0 ? adjustMentWidth : 0) + offset)
            .gesture(
                DragGesture()
                    .updating($offset, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onEnded({ value in
                        
                        let offsetX = value.translation.width
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        currentIndex = index
                    })
                    .onChanged({ value in
                        let offsetX = value.translation.width
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                    })
            )
        }
        .animation(.easeInOut, value: offset == 0)
    }
}






struct ChatRecommandCardSection_Previews: PreviewProvider {
    static var previews: some View {
        ChatUserRecommendationSection(followerViewModel: FollowerViewModel())
    }
}
