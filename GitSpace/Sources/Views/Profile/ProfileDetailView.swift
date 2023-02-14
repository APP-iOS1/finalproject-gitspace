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
            
            // 내 프로필이 아니라 타인의 프로필에 뜨는 버튼
            HStack { // MARK: - follow, knock 버튼을 위한 stack
                
                // 누르면 follow, unfollow로 전환
                GSButton.CustomButtonView(
                    style: .secondary(isDisabled: false)
                ) {
                    withAnimation {
                        followButtonLable == "Unfollow" ? (followButtonLable = "+ Follow") : (followButtonLable = "Unfollow")
                    }
                } label: {
                    GSText.CustomTextView(style: .title3, string: self.followButtonLable)
                        .frame(maxWidth: .infinity)
                }
                
                Spacer()
                    .frame(width: 10)
                
                // 누르면 knock message를 쓸 수 있는 sheet를 띄우도록 state bool var toggle.
                GSButton.CustomButtonView(
                    style: .secondary(isDisabled: false)
                ) {
                    withAnimation {
                        showKnockSheet.toggle()
                    }
                } label: {
                    GSText.CustomTextView(style: .title3, string: "Knock")
                        .frame(maxWidth: .infinity)
                }
                .sheet(isPresented: $showKnockSheet) {
                    SendKnockView()
                }
            }
            .padding(.vertical, 20)
            
            Divider()
                .frame(height: 1)
                .overlay(Color.gsGray3)
            
            Spacer()
            
        }
        .padding(.horizontal, 20)
    }
    
}



// MARK: - 재사용되는 profile section을 위한 뷰 (이미지, 이름, 닉네임, description, 위치, 링크, 팔로잉 등)
struct ProfileSectionView: View {
    
    @EnvironmentObject var GitHubAuthManager: GitHubAuthManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            
            // MARK: -사람 이미지와 이름, 닉네임 등을 위한 stack.
            HStack(spacing: 20) {
                ProfileAsyncImage(urlStr: "\(GitHubAuthManager.authenticatedUser?.avatar_url ?? "")", size: 70)
                
                VStack(alignment: .leading) {
                    // 이름
                    GSText.CustomTextView(style: .title2, string: GitHubAuthManager.authenticatedUser?.name ?? "")
                    
                    Spacer()
                        .frame(height: 1)
                    
                    // 닉네임
                    GSText.CustomTextView(style: .description, string: GitHubAuthManager.authenticatedUser?.login ?? "")
                }
                
                Spacer()
            }
            
            // MARK: - 프로필 Bio
            if GitHubAuthManager.authenticatedUser?.bio != "" {
                HStack {
                    GSText.CustomTextView(style: .body1, string: "\(GitHubAuthManager.authenticatedUser?.bio ?? "")")
                    Spacer()
                }
                .padding(15)
                .font(.callout)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.leading)
                .background(Color.gsGray3)
                .clipShape(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                )
                .padding(.vertical, 10)
            }
            
            // MARK: - 소속
            if GitHubAuthManager.authenticatedUser?.company != "" {
                HStack {
                    Image(systemName: "building.2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.gsGray2)

                    GSText.CustomTextView(style: .captionPrimary1, string: GitHubAuthManager.authenticatedUser?.company ?? "")
                }
            }
            
            // MARK: - 위치 이미지, 국가 및 위치
            if GitHubAuthManager.authenticatedUser?.location != "" {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.gsGray2)
                    
                    GSText.CustomTextView(style: .description2, string: GitHubAuthManager.authenticatedUser?.location ?? "")
                }
                .foregroundColor(Color(.systemGray))
            }
            
            // MARK: - 링크 이미지, 블로그 및 기타 링크
            if GitHubAuthManager.authenticatedUser?.blog != "" {
                HStack{
                    Image(systemName: "link")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.gsGray2)
                    
                    Button {
                        
                    } label: {
                        Link(destination: URL(string: GitHubAuthManager.authenticatedUser?.blog ?? "")!) {
                            GSText.CustomTextView(style: .captionPrimary1, string: GitHubAuthManager.authenticatedUser?.blog ?? "")
                        }
                    }
                }
            }
            
            // MARK: - 사람 심볼, 팔로워 및 팔로잉 수
            HStack {
                Image(systemName: "person")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 15, height: 15)
                    .foregroundColor(.gsGray2)
                
                NavigationLink {
                    Text("This Page Will Shows Followers List.")
                } label: {
                    HStack {
                        GSText.CustomTextView(style: .title4, string: handleCountUnit(countInfo: GitHubAuthManager.authenticatedUser?.followers ?? 0))
                        GSText.CustomTextView(style: .sectionTitle, string: "followers")
                            .padding(.leading, -2)
                    }
                }
                
                Text("･")
                    .foregroundColor(.gsGray2)
                    .padding(.leading, -3)
                    .padding(.trailing, -9)
                
                NavigationLink {
                    Text("This Page Will Shows Following List.")
                } label: {
                    HStack {
                        GSText.CustomTextView(style: .title4, string: handleCountUnit(countInfo: GitHubAuthManager.authenticatedUser?.following ?? 0))
                        GSText.CustomTextView(style: .sectionTitle, string: "following")
                            .padding(.leading, -2)
                    }
                }
            }
            
            Divider()
                .frame(height: 1)
                .overlay(Color.gsGray3)
                .padding(.vertical, 10)
            
            
            // MARK: - 유저의 README
            GSText.CustomTextView(style: .caption2, string: "README.md")
            GSCanvas.CustomCanvasView(style: .primary) {
                Text("리드미 내용")
                    .frame(maxWidth: .infinity)
            }
        }
    }
}



// MARK: - knock 버튼 눌렀을 때 뜨는 sheet view
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
