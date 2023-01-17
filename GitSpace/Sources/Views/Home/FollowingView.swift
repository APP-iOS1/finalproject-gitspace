//
//  FollowingView.swift
//  GitSpace
//
//  Created by 박제균 on 2023/01/18.
//

import SwiftUI

struct FollowingView: View {
    
    var body: some View {
        
        // FIXME: - 상위 뷰로 NavigationView 옮겨주기
        NavigationView {
            VStack {
                ForEach(1..<5) { number in
                    FeedView(userNumber: number)
                    Divider()
                }
            }
        } // nav
    } // body
}



struct FollowingView_Previews: PreviewProvider {
    static var previews: some View {
        FollowingView()
    }
}
