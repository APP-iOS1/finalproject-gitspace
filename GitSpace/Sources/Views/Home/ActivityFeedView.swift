//
//  ActivityFeedView.swift
//  GitSpace
//
//  Created by 박제균 on 2023/01/18.
//

import SwiftUI

struct ActivityFeedView: View {

    let userNumber: Int

    var body: some View {

        HStack(spacing: 25) {
            // FIXME: - Button Shape의 NavigationLink가 아님 -> GSNavigationLink 적용 불가
            NavigationLink {
                ProfileDetailView()
            } label: {
                Image("avatarImage")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
                .foregroundColor(.primary)

            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    NavigationLink {
                        ProfileDetailView()
                    } label: {
                        GSText.CustomTextView(style: .title3, string: "User \(userNumber)")
                    }

                    NavigationLink {
                        RepositoryDetailView()
                    } label: {
                        GSText.CustomTextView(style: .body1, string: "User \(userNumber) starred **APPSCHOOL1-REPO/finalproject-gitspace**")
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
                
                VStack {
                    // FIXME: - 이벤트 종류에 따른 메뉴 분기처리하기
                    Menu {
                        
                        // FIXME: - GSButton으로 수정필요, role을 연관값으로 가진 style이 아직 없어서 중단
                        Button(role: .none) {
                            // action
                        } label: {
                            Text("Chat")
                            Image(systemName: "bubble.left")
                                .renderingMode(.original)
                        }

                        Button(role: .none) {
                            // action
                        } label: {
                            Text("Star")
                                .foregroundColor(.red)
                            Image(systemName: "star")
                                .renderingMode(.original)
                        }
                        
                        Divider()

                        Button(role: .destructive) {
                            // action
                        } label: {
                            Text("Unstar")
                            Image(systemName: "star.slash")
                                .renderingMode(.original)
                        }

                        Button(role: .destructive) {

                        } label: {
                            Text("Unfollow User")
                            Image(systemName: "person.badge.minus")
                        }

                    } label: {
                        Image(systemName: "ellipsis")
                    }
                        .foregroundColor(.primary)

                    Spacer()
                    
                    GSText.CustomTextView(style: .caption2, string: "\(userNumber) 시간 전")

                }
            } // vstack
        } // hstack
        .padding(.horizontal)
    } // body

}

struct ActivityFeedView_Previews: PreviewProvider {
    static var previews: some View {
//        FeedView(userNumber: 1)
        ContentView(tabBarRouter: GSTabBarRouter())
    }
}
