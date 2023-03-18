//
//  ReadmeLoadingView.swift
//  GitSpace
//
//  Created by 박제균 on 2023/03/16.
//

import SwiftUI

struct ReadmeLoadingView: View {
    var body: some View {
        VStack {
            Image("GitSpace-Loading")
                .resizable()

            GSText.CustomTextView(style: .title4, string: "Loading README.md...")
        }
        .frame(width: 150, height: 150)

    }
}

struct ReadmeLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        ReadmeLoadingView()
    }
}
