//
//  profileDetailView.swift
//  GitSpace
//
//  Created by 정예슬 on 2023/01/17.
//

import SwiftUI

struct profileDetailView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            HStack{
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                VStack(alignment: .leading){
                    Text("여기에 사람 이름이 들어갈거임.")
                        .bold()
                    Spacer()
                        .frame(height: 20)
                    Text("@여기에 사람 닉네임 들어감.")
                }
            }
            .frame(height: 100)
            Text("아임 브라질 랜덤 가이..")
                .padding(.vertical, 10)
            HStack{
                Image(systemName: "mappin.and.ellipse")
                Text("Brazil, South America")
                    .bold()
                    .foregroundColor(.gray)
            }
            HStack{
                Image(systemName: "link")
                Text("yeseul-programming.tistory.com")
                    .bold()
            }
            HStack{
                Image(systemName: "person")
                Text("1924 followers · 1272 following")
                    .bold()
            }
            HStack{
                Button {
                    
                } label: {
                    Text("+ Follow")
                        .bold()
                        .frame(minWidth: 130)
                        .foregroundColor(.white)
                        .padding()
                        .background(.gray)
                        .cornerRadius(15)
                }
                Spacer()
                Button {
                    
                } label: {
                    Text("Knock")
                        .bold()
                        .frame(minWidth: 130)
                        .foregroundColor(.white)
                        .padding()
                        .background(.gray)
                        .cornerRadius(15)
                }
            }
            .padding(.vertical, 15)
            Divider()
                .frame(height: 2)
                .overlay(.gray)
            Spacer()
        }
        .padding()
    }
    func followButtonAction(){
        
    }
}

struct profileDetailView_Previews: PreviewProvider {
    static var previews: some View {
        profileDetailView()
    }
}
