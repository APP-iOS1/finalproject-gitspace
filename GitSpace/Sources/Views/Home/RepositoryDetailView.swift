//
//  RepositoryDetailView.swift
//  GitSpace
//
//  Created by yeeunchoi on 2023/01/17.
//

import SwiftUI

struct RepositoryDetailView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Spacer()
                .frame(height: 20)
            
            // MARK: - 레포 디테일 정보 섹션
            RepositoryInfoCard()
                .padding(.bottom, 20)
            
            // MARK: - 레포에 부여된 태그 섹션
            RepositoryDetailViewTags()
            
            Spacer()
            
        }
        .padding(.horizontal, 30)
        .navigationBarTitle("Repository", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    // MARK: - ContributorListView
                    // 툴바 메일 아이콘 탭 시 노크 가능한 유저 리스트 뷰로 이동
                    ContributorListView()
                        .navigationTitle("Knock Knock!")
                } label: {
                    Text("📮")
                        .font(.largeTitle)
                }
            }
        }
    }
}


struct RepositoryInfoCard: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // 레포 타이틀
            Text("**RepoTitle**")
                .font(.largeTitle)
                .padding(.bottom, 5)
            
            // 유저 프로필 이미지 + 유저네임
            HStack {
                ZStack {
                    Circle()
                        .frame(width: 50)
                        .foregroundColor(Color(.systemGray))
                    Text("profile \nImage")
                        .font(.caption2)
                }
                Text("username")
                    .padding(.vertical, 5)
            }
            
            // 레포 설명글
            Text("This is a description paragraph for current repository. Check out more information by knocking on users!")
                .padding(.vertical, 5)
            
            // 레포에 찍힌 스타 개수
            Text("⭐️ 234,305 stars")
                .font(.footnote)
                .padding(.vertical, 5)
                .foregroundColor(Color(.systemGray))
            
            Divider()
            
            // Contributors 섹션 타이틀
            HStack {
                Text("**Contributors**")
                    .padding(.vertical, 5)
                ZStack {
                    Circle()
                        .stroke(Color.black)
                        .frame(width: 15)
                    Text("2")
                        .font(.caption2)
                }
            }
            
            // Contributors 유저 프로필들
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0...2, id:\.self) { profile in
                        NavigationLink(destination: ProfileDetailView()) {
                            ZStack {
                                Circle()
                                    .frame(width: 40)
                                    .foregroundColor(Color(.systemGray))
                                Text("profile \nImage")
                                    .font(.caption2)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .shadow(color: .gray, radius: 3, x: 1, y: 2)
                .opacity(0.2)
        )
    }
}



struct RepositoryDetailViewTags: View {
    let tags: [String] = ["thisis", "my", "tags", "hehe"]
    @State var isTagSheetShowed: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // 태그 섹션 타이틀
            HStack {
                Text("**My Tags**")
                    .font(.title2)
                
                // 태그 추가 버튼
                Button {
                    // MainHomeView 코드 붙붙
                    isTagSheetShowed = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                }
            }
            
            // 추가된 태그들
            ScrollView(.horizontal) {
                HStack {
                    ForEach(tags, id:\.self) { tag in
                        Text(tag)
                            .font(.callout)
                            .foregroundColor(.white)
                            .padding(.vertical, 7)
                            .padding(.horizontal, 13)
                            .background(.black)
                            .cornerRadius(20)
                    }
                }
            }
            
        }
        // FIXME: selectedTag의 값
        /// 실제로는 각 레포가 가지고 있는 태그가 들어와야 한다!
        .fullScreenCover(isPresented: $isTagSheetShowed) {
            AddTagSheetView(preSelectedTags: .constant([]))
        }
    }
}





struct RepositoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RepositoryDetailView()
        }
    }
}
