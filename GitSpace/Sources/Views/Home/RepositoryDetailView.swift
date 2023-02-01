//
//  RepositoryDetailView.swift
//  GitSpace
//
//  Created by yeeunchoi on 2023/01/17.
//

import SwiftUI

struct RepositoryDetailView: View {

    var body: some View {
        // TODO: - 정보가 많아지면 ScrollView 로 변경 고려해볼것
        VStack {

            HStack {
                Image("GuideImage")
                Text("Check out what **Random Brazil Guy** just starred!")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Spacer()
            }
                .padding(.bottom, 10)


            // MARK: - 레포 디테일 정보 섹션
            RepositoryInfoCard()
                .padding(.bottom, 20)

            // MARK: - 레포에 부여된 태그 섹션
            RepositoryDetailViewTags()

            Spacer()

            
            NavigationLink {
                // MARK: - ContributorListView
                // 툴바 메일 아이콘 탭 시 노크 가능한 유저 리스트 뷰로 이동
                ContributorListView()
                    .navigationTitle("Knock Knock!")
            } label: {
                GSButton.CustomButtonView(style: .primary(isDisabled: false)) {

                } label: {
                    Text("✊🏻  Knock Knock!")
                        .font(.headline)
                        .foregroundColor(.black)
                }
                // FIXME: - 버튼 디자인 시스템 변경되면 disabled 제거
                // !!!: - 버튼 디자인시스템 변경 이전까지 다크모드에서 버튼이 회색으로 표시됨
                .disabled(true)
            }
            

        }
            .padding(.horizontal, 30)
            .navigationBarTitle("Repository", displayMode: .inline)
    }
}


struct RepositoryInfoCard: View {

    var body: some View {
        VStack(alignment: .leading) {

            // 레포 타이틀
            Text("**RepoTitle**")
                .font(.largeTitle)
                .padding(.bottom, 5)

            // 레포 설명글
            Text("This is a description paragraph for current repository. Check out more information by knocking on users!")
                .padding(.vertical, 5)

            // 레포에 찍힌 스타 개수
            Text("⭐️ 234,305 stars")
                .font(.footnote)
                .padding(.vertical, 5)
                .foregroundColor(.secondary)

            Divider()

            // Contributors 섹션 타이틀
            Text("**Contributors**")
                .padding(.vertical, 5)


            // Contributors 유저 프로필들
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0...2, id: \.self) { profile in
                        NavigationLink(destination: ProfileDetailView()) {

                            Image("avatarImage")
                                .resizable()
                                .frame(width: 40, height: 40)

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
                    ForEach(tags, id: \.self) { tag in
                        // !!!: - 버튼 디자인시스템 변경 이전까지 다크모드에서 태그버튼이 주황색으로 표시됨
                        GSButton.CustomButtonView(style: .tag(isEditing: false)) {

                        } label: {
                            Text(tag)
                            // FIXME: - 태그버튼 사이즈 임시 축소, 추후 디자인 시스템에서 버튼 사이즈 통일 필요
                            .padding(-10)
                        }



                    }
                }
            }

        }
        // FIXME: selectedTag의 값
        /// 실제로는 각 레포가 가지고 있는 태그가 들어와야 한다!
        .fullScreenCover(isPresented: $isTagSheetShowed) {
            AddTagSheetView(selectedTags: .constant([]))
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
