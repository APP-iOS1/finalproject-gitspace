//
//  profileDetailView.swift
//  GitSpace
//
//  Created by 정예슬 on 2023/01/17.
//

import SwiftUI

// 사용자의 프로필 뷰
// TODO: - ToolBar Item들 네비게이션으로 다른 뷰 연결

struct MainProfileView: View {
    var body: some View {
        //MARK: - 처음부터 끝까지 모든 요소들을 아우르는 stack.
        VStack(alignment: .leading){
            ProfileSectionView()
				.padding(.horizontal, 10)
            Spacer()
        }
        .toolbar{
            ToolbarItemGroup(placement: .navigationBarTrailing){
                NavigationLink {
                    ProfileSettingView()
                } label: {
                    Image(systemName: "gearshape")
                        .foregroundColor(.primary)
                }
            }
        }
        
    }
}

struct MainProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            MainProfileView()
        }
    }
}
