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
                
                // MARK: - User Profice Pic
                AsyncImage(url: URL(string: "https://avatars.githubusercontent.com/u/64696968?v=4")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 100)
                } placeholder: {
                    ProgressView()
                } // AsyncImage
                
                // MARK: - User Info
                VStack(spacing: 5) {
                    /// userName이 들어갈 자리
                    Text("\("guguhanogu")")
                        .bold()
                        .font(.title3)
                        .foregroundColor(Color(.black))
                        
                    /// user의 팔로워 수, 레포 수 가 표시될 자리
                    HStack {
                        Text("팔로워 \("392")명﹒레포 \("0")개")
                    }
                } // VStack : User Info
                .font(.footnote)
                .foregroundColor(Color(.systemGray))
                
                // MARK: - 프로필 이동 버튼
                NavigationLink {
                    ProfileDetailView()
                } label: {
                    GSButton.CustomButtonView(style: .secondary(
                        isDisabled: false)
					) {

                        } label: {
                            Text("View Profile")
                                .font(.footnote)
                                .foregroundColor(.primary)
                                .bold()
                                .padding(-8)
                        }
						.disabled(true)
                }
                
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
//                        .overlay(
//                                RoundedRectangle(cornerRadius: 16)
//                                    //.shadow(color: .gray, radius: 10, x: 10, y: 10)
//                                    //.foregroundColor(.clear)
//                                    .stroke(Color.gsLightGray2, lineWidth: 0.2)
//                                    .padding(.horizontal, 10)
//
//
//
//                            )
                        


                }
                
            } // ScrollView
            VStack {
                
            } // VStack
        }
        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button {
//                    dismiss()
//                } label: {
//                    HStack {
//                        Image(systemName: "chevron.left")
//                        Text("Back")
//                            .padding(.leading, -5)
//                    }
//                    .foregroundColor(.black)
//                }
//
//            } // ToolbarItem
            
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
