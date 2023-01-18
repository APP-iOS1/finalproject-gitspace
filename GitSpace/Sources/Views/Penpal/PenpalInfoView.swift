//
//  PenpalInfoView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/18.
//

import SwiftUI

struct PenpalInfoView: View {
    
    @State private var alarmStop : Bool = false
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https://avatars.githubusercontent.com/u/45925685?v=4")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: 80)
            } placeholder: {
                ProgressView()
            }
            Text("Taeyoung Won")
                .bold()
                .padding(.horizontal, -8)
            
            Text("@wontaeyoung")
                .foregroundColor(Color(uiColor: .systemGray))
            
            Divider()
                .padding(.horizontal, -10)
            
            VStack(alignment: .leading) {
                Text("알림")
                    .font(.title3)
                    .bold()
                
                Toggle("알림 일시중지", isOn: $alarmStop)
            }
            
            Divider()
                .padding(.horizontal, -10)
            
            
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct PenpalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PenpalInfoView()
    }
}
