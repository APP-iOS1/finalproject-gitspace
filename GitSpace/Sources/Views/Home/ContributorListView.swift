//
//  ContributorListView.swift
//  GitSpace
//
//  Created by yeeunchoi on 2023/01/18.
//

import SwiftUI

struct ContributorListView: View {
    let contributors: [String] = ["contributor1", "contributor2", "contributor3"]
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Spacer()
                .frame(height: 30)
            
            // MARK: - 안내 메시지 ( ~하세요 -> ~하시겠어요? 질문형으로 변경)
            GSText.CustomTextView(
                style: .title2,
                string: "Who do you want to chat with?")
                .padding(.leading, 10)
                .padding(.bottom, 5)
            

            
            GSText.CustomTextView(
                style: .caption1,
                string: "Choose a user to start your chat.")
                .padding(.leading, 10)
            
            ScrollView {
                ForEach(contributors, id:\.self) { contributor in
                    NavigationLink(destination: {
                        SendKnockView()
                    }, label: {
                        HStack() {
                            /* 유저 프로필 이미지 */
                            Image("avatarImage")
                                .frame(width: 40)
                                .padding(.trailing, 10)
                            
                            /* 유저네임 */
                            GSText.CustomTextView(
                                style: .title3,
                                string: contributor)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    })
                    .padding(.vertical, 25)
                    .contentShape(Rectangle())
                    
                    // TODO: - 추상화 후 백그라운드를 캔버스 디자인시스템으로 바꾸기
                    .background(
                        RoundedRectangle(cornerRadius: 17)
                            .fill(.white)
                            .shadow(
                                color: Color(.systemGray5),
                                radius: 6,
                                x: 0, y: 2)
                            .padding(.vertical, 5)
                    )
                }

                .padding(.horizontal, 10)
                
                

            }
            
            Spacer()
           
        }
        .padding(.horizontal, 10)
       
    }
}

struct ContributorListView_Previews: PreviewProvider {
    static var previews: some View {
        ContributorListView()
    }
}
