//
//  profileDetailView.swift
//  GitSpace
//
//  Created by 정예슬 on 2023/01/17.
//

import SwiftUI

// TODO: - kncokSheetView 70%만 뜰 수 있도록 수정...(iOS 15에선 너무 까다롭다..)

struct ProfileDetailView: View {
    
    //follow/unfollow 버튼 lable(누를 시 텍스트 변환을 위해 state 변수로 선언)
    @State var followButtonLable: String = "+ Follow"
    //knock 버튼 눌렀을 때 sheet view 띄우는 것에 대한 Bool state var.
    @State var showKnockSheet: Bool = false
    
    
    var body: some View {
        // MARK: - 처음부터 끝까지 모든 요소들을 아우르는 stack.
        VStack(alignment: .leading, spacing: 10) {
            
            ProfileSectionView()
            
            HStack { // MARK: - follow, knock 버튼을 위한 stack
                
                // 누르면 follow, unfollow로 전환
                GSButton.CustomButtonView(
                    style: .secondary(isDisabled: false)
                ) {
                    withAnimation {
                        followButtonLable == "Unfollow" ? (followButtonLable = "+ Follow") : (followButtonLable = "Unfollow")
                    }
                } label: {
                    Text(self.followButtonLable)
                    /* 일단 width를 이렇게 적용해봤는데 내부적으로 일괄 적용해야 할 수도 */
                        .frame(maxWidth: .infinity)
                }
                
                Spacer()
                
                // 누르면 knock message를 쓸 수 있는 sheet를 띄우도록 state bool var toggle.
                GSButton.CustomButtonView(
                    style: .secondary(isDisabled: false)
                ) {
                    withAnimation {
                        showKnockSheet.toggle()
                    }
                } label: {
                    Text("Knock")
                        .frame(maxWidth: .infinity)
                }
                .sheet(isPresented: $showKnockSheet) {
                    knockSheetView(kncokMessage: "")
                }
                
                
//                Button { ///누르면 knock message를 쓸 수 있는 sheet를 띄우도록 state bool var toggle.
//                    showKnockSheet.toggle()
//                } label: {
//                    Text("Knock")
//                        .bold()
//                        .frame(minWidth: 130)
//                        .foregroundColor(Color(.systemBackground))
//                        .padding()
//                        .background(.black)
//                        .cornerRadius(20)
//                }
//                .sheet(isPresented: $showKnockSheet) {
//                    knockSheetView(kncokMessage: "")
//                }
            }
            .padding(.vertical)
            
            Divider()
                .frame(height: 2)
                .overlay(.gray)
            
            Spacer()
            
        }
        .padding()

    }
    
}

//MARK: - 재사용되는 profile section을 위한 뷰 (이미지, 이름, 닉네임, description, 위치, 링크, 팔로잉 등)
struct ProfileSectionView: View {
    
    // FIXME: 나중에 상위 뷰에서 받아올 데이터
    let followerCount: String = "1900"
    let followingCount: String = "1200"
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            HStack { //MARK: -사람 이미지와 이름, 닉네임 등을 위한 stack.
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)

                VStack(alignment: .leading) { // 이름, 닉네임
                    GSText.CustomTextView(style: .title2, string: "UserName")
                    Spacer()
                        .frame(height: 10)
                    GSText.CustomTextView(style: .description, string: "@UserNickname")
                }
                
				Spacer()
            }
            .padding(.bottom, 5)
            
            
            //MARK: - 프로필 자기 ..설명..?
            HStack {
                Text("Hi! I'm Random Brazil Guy!")
                Spacer()
            }
            .padding(15)
            .font(.callout)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.leading)
            .background(Color.gsGray3)
            .clipShape(
                RoundedRectangle(cornerRadius: 17, style: .continuous)
            )
            .padding(.bottom, 10)
                
            
            HStack { //MARK: - 위치 이미지, 국가 및 위치
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(.gsGray2)
                GSText.CustomTextView(style: .description, string: "Brazil, South America")
            }
            .foregroundColor(Color(.systemGray))
            HStack{ //MARK: - 링크 이미지, 블로그 및 기타 링크
                Image(systemName: "link")
                    .foregroundColor(.gsGray2)
                Button {
                    
                } label: {
                    HStack {
                        Link(destination: URL(string: "https://yeseul-programming.tistory.com")!) {
                            
                            GSText.CustomTextView(style: .body1, string: "yeseul-programming.tistory.com")
                        }
                    }
                }
            }
            
            HStack { //MARK: - 사람 심볼, 팔로워 및 팔로잉 수
                Image(systemName: "person")
                    .foregroundColor(.gsGray2)
                
                NavigationLink {
                    Text("This Page Will Shows Followers List.")
                } label: {
                    HStack {
                        GSText.CustomTextView(style: .title3, string: handleCountUnit(countInfo: followerCount))
                        GSText.CustomTextView(style: .description, string: "followers")
                            .padding(.leading, -2)
                    }
                }
                .padding(.trailing, 5)
//                .buttonStyle(PlainButtonStyle())
                
                Text("|")
                    .foregroundColor(.gsGray3)
                    .padding(.trailing, 5)
                
                NavigationLink {
                    Text("This Page Will Shows Following List.")
                } label: {
                    HStack {
                        GSText.CustomTextView(style: .title3, string: handleCountUnit(countInfo: followingCount))
                        GSText.CustomTextView(style: .description, string: "following")
                            .padding(.leading, -2)
                    }
                }
//                .buttonStyle(PlainButtonStyle())
            }
        }
		.padding(.horizontal, 10)
    }
}



//MARK: - knock 버튼 눌렀을 때 뜨는 sheet view
struct knockSheetView: View {
    @Environment(\.dismiss) var dismiss
    @State var kncokMessage: String
    
    var body: some View {
        VStack{
            Group{
                Text("Let's Write Your Knock Message!!")
                TextField("I want to talk with you.", text: $kncokMessage)
            } .padding()
            Button {
                dismiss()
            } label: {
                Text("Knock Knock !!")
                    .bold()
                    .foregroundColor(Color(.systemBackground))
                    .padding()
                    .background(.black)
                    .cornerRadius(20)
            }
        }
    }
}



struct ProfileDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDetailView()
    }
}
