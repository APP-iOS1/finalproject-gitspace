//
//  MainPenpalView.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/17.
//

import SwiftUI

struct MainPenpalView: View {
    var body: some View {
        NavigationView {
            NavigationLink {
                ChatDetailView()
            } label: {
                Text("채팅방으로")
            }
        }
    }
}

struct MainPenpalView_Previews: PreviewProvider {
    static var previews: some View {
        MainPenpalView()
    }
}
