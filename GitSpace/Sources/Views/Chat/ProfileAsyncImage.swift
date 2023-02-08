//
//  ProfileAsyncImage.swift
//  GitSpace
//
//  Created by 원태영 on 2023/02/01.
//

import SwiftUI

// MARK: -View :
struct ProfileAsyncImage: View {
    
    let urlStr: String = "https://w.namu.la/s/fb074c9e538edb0b41d818df3cb7b5499a844aeb5e8becc3ce1664468c885d883e8a8243a33eefc11e107b8d7dbbf77a410d78675770117a6654984ebe73f2f2eb846d97e660cdc8ab76067ddad22f9574647c8b25eaf5022f4f481b458094b9"
    let size: CGFloat
    
    var body : some View {
        AsyncImage(url: URL(string: urlStr)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .border(.primary)
                .clipShape(Circle())
                .frame(width : size)
        } placeholder: {
            // 불러오는 중입니다...
            Text("Loading...")
        }
    }
}
