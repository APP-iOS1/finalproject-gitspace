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
        //MARK: - 처음부터 끝까지 모든 요소들을 아우르는 stack.
        VStack(alignment: .leading, spacing: 10){
            
            ProfileSectionView()
            
            HStack{ //MARK: - follow, knock 버튼을 위한 stack
                Button { /// 누르면 follow, unfollow로 전환
                    followButtonLable == "Unfollow" ? (followButtonLable = "+ Follow") : (followButtonLable = "Unfollow")
                } label: {
                    Text(self.followButtonLable)
                        .bold()
                        .frame(minWidth: 130)
                        .foregroundColor(Color(.systemBackground))
                        .padding()
                        .background(.black)
                        .cornerRadius(20)
                }
                
                Spacer()
                
                Button { ///누르면 knock message를 쓸 수 있는 sheet를 띄우도록 state bool var toggle.
                    showKnockSheet.toggle()
                } label: {
                    Text("Knock")
                        .bold()
                        .frame(minWidth: 130)
                        .foregroundColor(Color(.systemBackground))
                        .padding()
                        .background(.black)
                        .cornerRadius(20)
                }
                .sheet(isPresented: $showKnockSheet){
                    knockSheetView(kncokMessage: "")
                }
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
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            HStack{ //MARK: -사람 이미지와 이름, 닉네임 등을 위한 stack.
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)


                VStack(alignment: .leading){ // 이름, 닉네임
                    Text("UserName")
                        .font(.headline)
                        .bold()
                    //Spacer()
                        //.frame(height: 20)
                    Text("@UserNickname")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
				Spacer()
            }
            .padding(.bottom, 5)
            
            //MARK: - 프로필 자기 ..설명..?
            
            HStack {
                Text("Hi! I'm Random Brazil Guy!")
                Spacer()
            }
            .padding()
            .font(.callout)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.leading)
            // FIXME: - gsGray색상으로 변경 필요
            .background(Color(.systemGray3))
            .clipShape(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
            )
                
            
            HStack{ //MARK: - 위치 이미지, 국가 및 위치
                Image(systemName: "mappin.and.ellipse")
                Text("Brazil, South America")
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
            .foregroundColor(Color(.systemGray))
            HStack{ //MARK: - 링크 이미지, 블로그 및 기타 링크
                Image(systemName: "link")
                    .foregroundColor(.secondary)
                Button {
                    
                } label: {
                    HStack {
                        Link(destination: URL(string: "https://yeseul-programming.tistory.com")!) {
                            Text("yeseul-programming.tistory.com")
                                .font(.callout)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            HStack{ //MARK: - 사람 심볼, 팔로워 및 팔로잉 수
                Image(systemName: "person")
                    .foregroundColor(.secondary)
                
                NavigationLink {
                    Text("This Page Will Shows Followers List.")
                } label: {
                    HStack {
                        Text("1.9K")
                            .foregroundColor(.primary)
                            .bold()
                        
                        Text("followers")
                            .foregroundColor(.secondary)
                            .padding(.leading, -5)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
//                Text("·")
//                    .foregroundColor(Color(.systemGray))
//                    .padding(.horizontal, -3)
                
                NavigationLink {
                    Text("This Page Will Shows Following List.")
                } label: {
                    HStack {
                        Text("1.2K")
                            .foregroundColor(.primary)
                            .bold()
                        
                        Text("following")
                            .foregroundColor(.secondary)
                            .padding(.leading, -5)
                    }
                }
                .buttonStyle(PlainButtonStyle())
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
