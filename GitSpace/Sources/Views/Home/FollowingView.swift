//
//  FollowingView.swift
//  GitSpace
//
//  Created by 박제균 on 2023/01/18.
//

import SwiftUI

struct FollowingView: View {
    // FIXME: - MainHomeView와 연결 필요
    var body: some View {
        // FIXME: - 상위 뷰(MainHome)로 NavigationView 옮겨주고, MainHomeView에 ScrollView 필요
        NavigationView {
            ScrollView {
                ForEach(1..<5) { number in
                    FeedView(userNumber: number)
                    Divider()
                }
            } // vstack
        } // nav
    } // body
}



struct FollowingView_Previews: PreviewProvider {
    static var previews: some View {
        FollowingView()
    }
}
