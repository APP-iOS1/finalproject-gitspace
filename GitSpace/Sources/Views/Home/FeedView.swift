//
//  FeedView.swift
//  GitSpace
//
//  Created by 박제균 on 2023/01/18.
//

import SwiftUI

struct FeedView: View {

    let userNumber: Int

    var body: some View {

            HStack(spacing: 25) {
                // FIXME: - Profile Detail View와 연결하기
                NavigationLink {
                    Text("특정유저의 프로필 입니다.")
                } label: {
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width: 50, height: 50)
                        .overlay {
                        Text("User \(userNumber)")
                    }
                }
                .foregroundColor(.primary)
                .contextMenu(menuItems: {
                    
                    Button(role: .none) {
                        // action
                    } label: {
                        Text("Penpal 보내기")
                        Image(systemName: "paperplane")
                            .renderingMode(.original)
                    }
                    
                    Button(role: .destructive) {
                        // action
                    } label: {
                        Text("Unfollow")
                        Image(systemName: "person.badge.minus")
                            .renderingMode(.original)
                    }
                })
            

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        NavigationLink {
                            Text("특정유저의 프로필 입니다.")
                        } label: {
                            Text("User \(userNumber)")
                                .bold()
                        }
                        .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text("\(userNumber) 시간 전")
                            .font(.footnote)
                            .foregroundColor(Color(.systemGray))
                    }
                    // FIXME: - Repository Detail View와 연결하기
                    NavigationLink {
                        Text("특정 레포지토리의 디테일 뷰 입니다.")
                    } label: {
                        Text("User \(userNumber) starred **APPSCHOOL1-REPO/finalproject-gitspace**")
                    }
                    .foregroundColor(.primary)
                    .contextMenu(menuItems: {
                        // 만약 사용자도 팔로우중인 레포지토리라면 unstar 버튼을 보여줌
                        Button(role: .destructive) {
                            // action
                        } label: {
                            Text("Unstar")
                            Image(systemName: "star.slash")
                                .renderingMode(.original)
                        }
                        
                        // 사용자가 팔로우중인 레포지토리가 아니라면 star버튼을 보여줌
                        Button(role: .none) {
                            // action
                        } label: {
                            Text("Star")
                                .foregroundColor(.red)
                            Image(systemName: "star")
                                .renderingMode(.original)
                        }
                    })
                } // vstack
            } // hstack
            .padding()
    } // body

}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(userNumber: 1)
    }
}
