//
//  RepositoryDetailView.swift
//  GitSpace
//
//  Created by yeeunchoi on 2023/01/17.
//

import SwiftUI

struct RepositoryDetailView: View {
    @State private var selectedTagList: [Tag] = []

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
            RepositoryDetailViewTags(selectedTags: $selectedTagList)

            Spacer()

            GSNavigationLink(style: .primary) {
                ContributorListView()
                    .navigationTitle("Contributors")
            } label: {
                GSText.CustomTextView(style: .title3, string:"✊🏻  Knock Knock!")
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
//    let tags: [String] = ["thisis", "my", "tags", "hehe"]
    @Binding var selectedTags: [Tag]
    @State var isTagSheetShowed: Bool = false
    @EnvironmentObject var tagViewModel: TagViewModel


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
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(selectedTags, id: \.self) { tag in
                        // !!!: - 버튼 디자인시스템 변경 이전까지 다크모드에서 태그버튼이 주황색으로 표시됨
                        GSButton.CustomButtonView(
                            style: .tag(
                                isSelected: true,
                                isEditing: false)
                        ) {

                        } label: {
                            // !!!: - 대응데이
                            // FIXME: - 태그버튼 사이즈 임시 축소, 추후 디자인 시스템에서 버튼 사이즈 통일 필요
                            Text(tag.tagName)
                            .padding(-10)
                        }



                    }
                }
            }

        }
        // FIXME: selectedTag의 값
        /// 실제로는 각 레포가 가지고 있는 태그가 들어와야 한다!
        .fullScreenCover(isPresented: $isTagSheetShowed) {
            AddTagSheetView(preSelectedTags: $selectedTags, selectedTags: selectedTags, beforeView: .repositoryDetailView)
        }
        .onAppear {
            Task {
                selectedTags = await tagViewModel.requestRepositoryTags(repositoryName: "wwdc/2022") ?? []
                
            }
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
