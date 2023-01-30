//
//  DummyPenpalListView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/18.
//

import SwiftUI

struct DummyPenpalListView: View {
    
    var body: some View {
        NavigationView {
            NavigationLink {
                //ChatDetailView()
            } label: {
                Text("여기는 펜팔 채팅방 리스트 뷰입니다. 채팅방으로 이동")
            }
            
        }
    }
}

struct DummyPenpalListView_Previews: PreviewProvider {
    static var previews: some View {
        DummyPenpalListView()
    }
}
