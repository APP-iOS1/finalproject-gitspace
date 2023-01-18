//
//  MyKnockSettingView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/01/18.
//

import SwiftUI

struct MyKnockSettingView: View {
    
    @Binding var showingKnockSetting: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("까 꿍 !")
                } // VStack
            } // ScrollView
            .navigationBarTitle("노크 설정", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        showingKnockSetting.toggle()
                    } // Button
                } // ToolbarItem
            } // toolbar
        } // NavigationView
    } // body
}

struct MyKnockSettingView_Previews: PreviewProvider {
    static var previews: some View {
        MyKnockSettingView(showingKnockSetting: .constant(true))
    }
}
