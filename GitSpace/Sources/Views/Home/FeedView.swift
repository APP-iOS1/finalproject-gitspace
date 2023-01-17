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

                VStack(alignment: .leading, spacing: 10) {
                    Text("User \(userNumber)")
                        .bold()
                    // FIXME: - Repository Detail View와 연결하기
                    NavigationLink {
                        Text("특정 레포지토리의 디테일 뷰 입니다.")
                    } label: {
                        Text("User \(userNumber) starred **APPSCHOOL1-REPO/finalproject-gitspace**")
                    }

                }
                .foregroundColor(.primary)

            } // hstack
    } // body

}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(userNumber: 1)
    }
}
