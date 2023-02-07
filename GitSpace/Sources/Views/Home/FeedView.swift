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
            NavigationLink {
                ProfileDetailView()
            } label: {
                Image("avatarImage")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
                .foregroundColor(.primary)
            // FIXME: - ContextMenu 일단 보류, 제거 가능
//                .contextMenu(menuItems: {
//
//                Button(role: .none) {
//                    // action
//                } label: {
//                    Text("Penpal 보내기")
//                    Image(systemName: "paperplane")
//                        .renderingMode(.original)
//                }
//
//                NavigationLink(destination: ProfileDetailView()) {
//                    Text("Profile로 이동")
//                    Image(systemName: "person.circle")
//                }
//
//
//                Divider()
//
//                Button(role: .destructive) {
//                    // action
//                } label: {
//                    Text("Unfollow")
//                    Image(systemName: "person.badge.minus")
//                        .renderingMode(.original)
//                }
//            })

            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    NavigationLink {
                        ProfileDetailView()
                    } label: {
                        Text("User \(userNumber)")
                            .bold()
                    }
                        .foregroundColor(.primary)



                    NavigationLink {
                        RepositoryDetailView()
                    } label: {
                        Text("User \(userNumber) starred **APPSCHOOL1-REPO/finalproject-gitspace**")
                            .multilineTextAlignment(.leading)
                            .font(.body)
                    }
//                    .multilineTextAlignment(.leading)
                        .foregroundColor(.primary)

                }
                
                Spacer()
                
                VStack {
                    Menu {

                        Button(role: .none) {
                            // action
                        } label: {
                            Text("Penpal 보내기")
                            Image(systemName: "paperplane")
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
                            Text("Unfollow")
                            Image(systemName: "person.badge.minus")
                        }

                    } label: {
                        Image(systemName: "ellipsis")
                    }
                        .foregroundColor(.primary)
                    // FIXME: - ContextMenu 일단 보류, 제거 가능
                    //                    .contextMenu(menuItems: {
                    //                    // 만약 사용자도 팔로우중인 레포지토리라면 unstar 버튼을 보여줌
                    //                    Button(role: .destructive) {
                    //                        // action
                    //                    } label: {
                    //                        Text("Unstar")
                    //                        Image(systemName: "star.slash")
                    //                    }
                    //
                    //                    // 사용자가 팔로우중인 레포지토리가 아니라면 star버튼을 보여줌
                    //                    Button(role: .none) {
                    //                        // action
                    //                    } label: {
                    //                        Text("Star")
                    //                        Image(systemName: "star")
                    //                    }
                    //                })

                    Spacer()
                    Text("\(userNumber) 시간 전")
                        .font(.footnote)
                        .foregroundColor(Color(.systemGray))

                }
            } // vstack
        } // hstack
        .padding(.horizontal)
    } // body

}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
//        FeedView(userNumber: 1)
        ContentView(tabBarRouter: GSTabBarRouter())
    }
}
