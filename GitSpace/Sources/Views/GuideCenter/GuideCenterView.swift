//
//  GuideCenterView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/07.
//

import SwiftUI

struct GuideCenterView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                HStack {
                    
                    Image("GitSpace-General-Guide")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    
                    VStack(alignment: .leading) {
                        GSText.CustomTextView(
                            style: .title3,
                            string: "The Essential Guidbook for GitSpacers 📖")
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                GuideFuncSection()
                
                // - MARK: 1차 출시 이후 차단, 신고 기능 추가 예정
//                GuideBlockSection()
//                GuideReportSection()
                
            } // ScrollView
            .navigationBarTitle("Guide Center"/*, displayMode: .inline*/)
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
    } // body
}

struct GuideCenterView_Previews: PreviewProvider {
    static var previews: some View {
        GuideCenterView()
    }
}
