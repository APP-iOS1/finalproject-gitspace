//
//  SetPrivacySafetyView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/09.
//

import SwiftUI

struct SetPrivacySafetyView: View {
    var body: some View {
        List {
            // MARK: - APP MANAGEMENT
            Section {
                Button(role: .cancel) {
                    print("모든 캐시를 ;;삭제할거임")
                } label: {
                    HStack {
                        Text("Clear cache")
                        Spacer()
                        Text("\(10) MB")
                            .foregroundColor(.gsGray2)
                    }
                }
            } header: {
                Text("app Management")
            }
            
        } // List
        .navigationBarTitle("Privacy & Safety", displayMode: .inline)
    }
}

struct SetPrivacySafetyView_Previews: PreviewProvider {
    static var previews: some View {
        SetPrivacySafetyView()
    }
}
