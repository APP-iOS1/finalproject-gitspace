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
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 200)

            GSText.CustomTextView(style: .title4, string: "Loading README.md...")
        }
        .frame(width: 250, height: 200)

    }
}

struct ReadmeLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        ReadmeLoadingView()
    }
}
