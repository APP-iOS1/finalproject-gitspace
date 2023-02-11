//
//  ReceivedKnockView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/01/31.
//

import SwiftUI

struct ReceivedKnockView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        VStack {
            VStack {
                Button {
                    
                } label: {
                    
                }
                
                
                
            } // VStack
            
            ScrollView {
                // MARK: - 상단 프로필 정보 뷰
                TopperProfileView()
                
                Divider()
                    .padding(.vertical, 20)
                    .padding(.horizontal, 5)
                
                // MARK: - Knock Message
                /// 1. 전송 시간
                /// 2. 시스템 메세지: Knock Message
                /// 3. 메세지 내용
                
                VStack(spacing: 10) {
                    /// 1. 전송 시간
                    Text("\("23/01/27 14:00 KST")")
                        .font(.footnote)
                        .foregroundColor(.gsLightGray2)
                    
                    /// 2. 시스템 메세지: Knock Message
                    HStack {
                        Text("Knock Message")
                            .font(.subheadline)
                            .foregroundColor(.gsLightGray1)
                            .bold()
                        
                        Spacer()
                    }
                    .padding(.leading, 15)
                    
                    /// 3. 메세지 내용
                    
                    
                    Text("\("Hi! This is Gildong from South Korea who’s currently studying Web programming. Would you mind giving me some time and advising me on my future career path? \nThank you so much for your help!")")
                        .font(.system(size: 15, weight: .regular))
                        .padding(.horizontal, 30)
                        .padding(.vertical, 30)
                        .fixedSize(horizontal: false, vertical: true)
                        .background(
                            RoundedRectangle(cornerRadius: 17)
                                .fill(.white)
                                .shadow(color: Color(.systemGray5), radius: 8, x: 0, y: 2)
                            
                        )
                        .padding(.horizontal, 15)
                }
                
            } // ScrollView
            
            VStack(spacing: 10) {
                
                Divider()
                    .padding(.top, -8)
                
                
//                Text("\("guguhanogu")")
//                    .bold()
//                    .font(.title3)
//                + Text(" knocked on you!")
//
                Text("Accept message request from \("guguhanogu")?")
                    .font(.subheadline)
                    .bold()
                    .padding(.bottom, 10)
                
                Text("If you accept, they will also be able to call you and see info such as your activity status and when you've read messages.")
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundColor(.gsGray2)
                    .padding(.top, -15)
                    .padding(.bottom)
                    .padding(.horizontal)
                    
                
                
                GSButton.CustomButtonView(style: .secondary(
                    isDisabled: false)) {
                        
                        
                    } label: {
                        Text("Accept")
                            .font(.body)
                            .foregroundColor(.primary)
                            .bold()
                            .padding(EdgeInsets(top: 0, leading: 130, bottom: 0, trailing: 130))
                    } // button: Accept
                
                
                
                HStack(spacing: 60) {
                    Button {
                        
                    } label: {
                        Text("Block")
                            .bold()
                            .foregroundColor(.red)
                    } // Button: Block
                    
                    Divider()
                    
                    Button {
                        
                    } label: {
                        Text("Decline")
                            .bold()
                            .foregroundColor(.primary)
                    } // Button: Decline
                }
                .frame(height: 30)
                
            } // VStack
        }
        .toolbar {
            
            ToolbarItem(placement: .principal) {
                HStack(spacing: 5) {
                    AsyncImage(url: URL(string: "https://avatars.githubusercontent.com/u/64696968?v=4")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .frame(width: 30)
                    } placeholder: {
                        ProgressView()
                    } // AsyncImage
                    
                    Text("\("guguhanogu")")
                        .bold()
                } // HStack
                .foregroundColor(.black)
            } // ToolbarItemGroup
        } // toolbar
    }
}

struct ReceivedKnockView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReceivedKnockView()
        }
    }
}
