//
//  ProfileAsyncImage.swift
//  GitSpace
//
//  Created by 원태영 on 2023/02/01.
//

import SwiftUI

// MARK: -View :
struct GithubProfileImage: View {
    
    let urlStr: String
    let size: CGFloat
    @State private var profileImage: Image?
    
    init(urlStr: String, size: CGFloat) {
        self.urlStr = urlStr
        self.size = size
    }
    
    var body : some View {
        
        VStack {
            EmptyView()
            if let profileImage {
                profileImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width : size)
            }
        }
        .task {
            profileImage = await .loadCachedImage(key: urlStr)
        }
    }
}


struct DefaultProfileImage: View {
    let size: CGFloat
    
    var body: some View {
        Image("ProfilePlaceholder")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            .frame(width : size)
    }
}
