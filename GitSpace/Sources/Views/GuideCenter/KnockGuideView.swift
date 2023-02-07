//
//  KnockGuideView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/04.
//

import SwiftUI

struct KnockGuideView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack(alignment: .top) {
            NavigationView {
                ScrollView {
                    HStack {
                        Text("Knock Guides")
                        
                    } // HStack
                } // ScrollView
                .navigationBarTitle("Knock")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        } // Button
                    } // ToolbarItem
                } // toolbar
            } // NavigationView
            
            // MARK: - presentationDragIndicator
            /// .presentationDragIndicator(.visible)
            /// iOS15에는 presentationDragIncidator 가 없어서 수작업으로 구현함.
            /// 추후 다른 방법을 찾으면 변경할 예정
            Capsule()
                .fill(Color.secondary)
                .opacity(0.5)
                .frame(width: 35, height: 5)
                .padding(6)
            
        } // ZStack
    } // body
}

struct KnockGuideView_Previews: PreviewProvider {
    static var previews: some View {
        KnockGuideView()
    }
}
