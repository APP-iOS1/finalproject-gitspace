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



struct ChatUserRecommendationSection: View {
    
    @State var currentIndex: Int = 0
    
    let userInfo1 = DummyUserInfo(userName: "yeeeunchoilianne", followerCount: "1.9k", repoCount: "20")
    let userInfo2 = DummyUserInfo(userName: "randombrazilgirl19970227", followerCount: "3.3k", repoCount: "61")
    let userInfo3 = DummyUserInfo(userName: "randombrazilmama", followerCount: "340", repoCount: "44")


    
    var body: some View {
        
        let users = [userInfo1, userInfo2, userInfo3]
        
        VStack(alignment: .leading) {
            
            // TODO: - 모든 gray 컬러 gsGray로 변경 예정
            Text("Recommended “pals” for you 👋")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom, -10)
            
            
            Carousel(index: $currentIndex, items: users) { user in

                GeometryReader { proxy in

                    let size = proxy.size

                    VStack(alignment: .trailing) {
                        HStack {
                            // TODO: - [GITHUB API] 유저 프로필 내용으로 바꾸기
                            Image("avatarImage")
                                .frame(width: 64)


                            VStack(alignment: .leading, spacing: 8) {
                                
                                HStack {
                                    Text("@" + "\(user.userName)")
                                        .font(.title3)
                                        .bold()
                                        .lineLimit(1)
                                    Spacer()
                                }

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
                            SendKnockView()
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
                    .padding(17)
                    

                    // TODO: - 추상화 후 백그라운드를 캔버스 디자인시스템으로 바꾸기
                    .background(
                        RoundedRectangle(cornerRadius: 35, style: .continuous)
                            .fill(.white)
                            .shadow(color: Color(uiColor: UIColor.systemGray5), radius: 6, x: 0, y: 2)
                    )

                }



            }
            .frame(height: 120)
            .padding(.vertical,20)
            
     
            
            
            // MARK: - Carousel Indicator Dots
            HStack {
                
                Spacer()
                
                ForEach(users.indices,id: \.self) { index in
                    
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







struct Carousel<Content: View,T: Identifiable>: View {
    var content: (T) -> Content
    var list: [T]
    
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int

    
    init(spacing: CGFloat = 15,
         trailingSpace: CGFloat = 80,
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
        ChatUserRecommendationSection()
    }
}






//struct ChatUserRecommendationSection: View {
//
//    @Environment(\.colorScheme) var colorScheme
//
//    let userInfo1 = DummyUserInfo(userName: "randombrazilguy", followerCount: "1.9k", repoCount: "20")
//    let userInfo2 = DummyUserInfo(userName: "randombrazilgirl", followerCount: "3.3k", repoCount: "61")
//    let userInfo3 = DummyUserInfo(userName: "randombrazilmama", followerCount: "340", repoCount: "44")
//
//
//    var body: some View {
//        let recommendedUsers = [userInfo1, userInfo2, userInfo3]
//
//        // MARK: - 단일 카드 컴포넌트
//        VStack(alignment: .leading) {
//
//            TabView {
//                ForEach(recommendedUsers) { user in
//
//                    VStack(alignment: .trailing) {
//                        HStack {
//                            // TODO: - [GITHUB API] 유저 프로필 내용으로 바꾸기
//                            Image("avatarImage")
//                                .frame(width: 64)
//
//
//                            VStack(alignment: .leading, spacing: 8) {
//                                Text("@" + "\(user.userName)")
//                                    .font(.title3)
//                                    .bold()
//
//                                HStack {
//                                    Group {
//                                        Text("\(user.followerCount)")
//                                            .bold()
//                                            .padding(.trailing, -5)
//                                        Text("followers")
//                                    }
//                                    .font(.callout)
//
//                                    Text("·")
//                                        .font(.caption)
//                                        .foregroundColor(.gray)
//
//                                    Group {
//                                        Text("\(user.repoCount)")
//                                            .bold()
//                                            .padding(.trailing, -5)
//                                        Text("repos")
//                                    }
//                                    .font(.callout)
//                                }
//
//                            }
//                        }
//
//                        Spacer()
//                            .frame(height: 20)
//
//                        // MARK: - NewKnockView로 이동하는 챗 버튼
//                        // TODO: - 버튼 추상화 후 네비링크버튼 타입으로 바꾸기
//                        NavigationLink {
//                            SendKnockView()
//                        } label: {
//                            Text("Let's Chat!")
//                                .font(.callout)
//                                .foregroundColor(.primary)
//                                .fontWeight(.semibold)
//                                .padding(.vertical, 12)
//                                .padding(.horizontal, 23)
//                                .background(Color.gsGreenPrimary)
//                                .cornerRadius(20)
//                        }
//                    }
//                    .padding(.vertical, 21)
//                    .padding(.horizontal, 17)
//                    // TODO: - 추상화 후 백그라운드를 캔버스 디자인시스템으로 바꾸기
//                    .background(
//                        RoundedRectangle(cornerRadius: 35, style: .continuous)
//                            .fill(.white)
//                            .shadow(color: Color(uiColor: UIColor.systemGray5), radius: 6, x: 0, y: 2)
//                    )
//                }
//
//            }
//            .tabViewStyle(.page)
//            .indexViewStyle(.page(backgroundDisplayMode: .always))
//
//            .frame(width: UIScreen.main.bounds.width, height: 250)
//
//
//            Spacer()
//
//
//
//            // TODO: - 모든 gray 컬러 gsGray로 변경 예정
//            Text("Recommended “pals” for you 👋")
//                .font(.footnote)
//                .foregroundColor(.gray)
//                .padding(.bottom, -10)
//
////            ScrollView(.horizontal, showsIndicators: false) {
////                HStack(spacing: 12) {
////                    ForEach(recommendedUsers) { user in
////                        VStack(alignment: .trailing) {
////                            HStack {
////                                // TODO: - [GITHUB API] 유저 프로필 내용으로 바꾸기
////                                Image("avatarImage")
////                                    .frame(width: 64)
////
////
////                                VStack(alignment: .leading, spacing: 8) {
////                                    Text("@" + "\(user.userName)")
////                                        .font(.title3)
////                                        .bold()
////
////                                    HStack {
////                                        Group {
////                                            Text("\(user.followerCount)")
////                                                .bold()
////                                                .padding(.trailing, -5)
////                                            Text("followers")
////                                        }
////                                        .font(.callout)
////
////                                        Text("·")
////                                            .font(.caption)
////                                            .foregroundColor(.gray)
////
////                                        Group {
////                                            Text("\(user.repoCount)")
////                                                .bold()
////                                                .padding(.trailing, -5)
////                                            Text("repos")
////                                        }
////                                        .font(.callout)
////                                    }
////
////                                }
////                            }
////
////                            Spacer()
////                                .frame(height: 20)
////
////                            // MARK: - NewKnockView로 이동하는 챗 버튼
////                            // TODO: - 버튼 추상화 후 네비링크버튼 타입으로 바꾸기
////                            NavigationLink {
////                                SendKnockView()
////                            } label: {
////                                Text("Let's Chat!")
////                                    .font(.callout)
////                                    .foregroundColor(.primary)
////                                    .fontWeight(.semibold)
////                                    .padding(.vertical, 12)
////                                    .padding(.horizontal, 23)
////                                    .background(Color.gsGreenPrimary)
////                                    .cornerRadius(20)
////                            }
////                        }
////                        .padding(.vertical, 21)
////                        .padding(.horizontal, 17)
////
////                        // TODO: - 추상화 후 백그라운드를 캔버스 디자인시스템으로 바꾸기
////                        .background(
////                            RoundedRectangle(cornerRadius: 35, style: .continuous)
////                                .fill(.white)
////                                .shadow(color: Color(uiColor: UIColor.systemGray5), radius: 6, x: 0, y: 2)
////                        )
////                    }
////
////                }
////                .padding(.vertical, 20)
////                .padding(.horizontal, 4)
////            }
//
//        }
//
//
//    }
//}

