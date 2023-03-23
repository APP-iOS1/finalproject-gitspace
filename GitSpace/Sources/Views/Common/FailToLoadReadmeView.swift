//
//  FailToLoadReadmeView.swift
//  GitSpace
//
//  Created by 박제균 on 2023/03/17.
//

import SwiftUI

struct FailToLoadReadmeView: View {
    var body: some View {
        VStack {
            Image("GitSpace-Star-Empty")
                .resizable()
            GSText.CustomTextView(style: .title3, string: "Fail to Load README.md")
        }
        .frame(width: 200, height: 200)
    }
}

struct ReadmeEmptyView: View {
    var body: some View {
        VStack {
            Image("GitSpace-ReadMe-Empty")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 200)
            
            GSText.CustomTextView(style: .title3, string: "**README.md** does not exist.")
        }
        .frame(width: 250, height: 200)
    }
}



struct FailToLoadReadmeView_Previews: PreviewProvider {
    static var previews: some View {
        FailToLoadReadmeView()
    }
}
