//
//  StarredView.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/01/17.
//

import SwiftUI

struct StarredView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var repositoryStore: RepositoryStore
    @State private var searchTag: String = ""
    @State private var selectedTagList: [Tag] = []
    @State private var isShowingSelectTagView: Bool = false
    
    // FIXME: systemGray6을 gsGray로 바꾸어야 한다.
    /// 현재 존재하는 gsGray 컬러가 너무 진해서 시스템 그레이로 설정해두었다.
    /// 아주 연한 gsGray 컬러를 설정할 필요가 있다.
    let backgroundGradient = LinearGradient(
        gradient: Gradient(
            colors: [.clear, Color(.systemGray6)]
        ),
        startPoint: .top, endPoint: .bottom
    )
    
    func removeTag(at index: Int, tag: Tag) {
        /* 삭제되는 태그들의 인덱스를 알면 쉽게 삭제가 되는데.. ¯\_( ͡° ͜ʖ ͡°)_/¯ */
        for (index, item) in Array(zip(repositoryStore.tagList.indices, repositoryStore.tagList)) {
            if item.id == tag.id {
                repositoryStore.tagList[index].isSelected = false
            }
        }
        selectedTagList.remove(at: index)
    }
    
    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                /* searchbar (custom) */
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: $searchTag)
                        .foregroundColor(.primary)
                }
                .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal, 10)
                
                /* Scroll Main Content */
                
                /* selected tags header*/
                HStack {
                    Text("Selected Tags")
                        .foregroundColor(.gsLightGray2)
                        .font(.system(size: 13))
                        .fontWeight(.regular)
                    
                    Spacer()
                    
                    Button {
                        isShowingSelectTagView.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .foregroundColor(colorScheme == .light ? .black : .white)
                    
                }
                .padding(.top, 10)
                .padding(.horizontal, 20)
                
                /* Selected Tag List */
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Array(selectedTagList.enumerated()), id:\.offset) { index, tag in
                            GSButton.CustomButtonView(
                                style: .tag(
									isSelected: true,
                                    isEditing: false
                                )
                            ) {
                                removeTag(at: index, tag: tag)
                            } label: {
                                Text("\(tag.name)")
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 10)
                
                /* repository list */
                ScrollView {
                    ForEach(repositoryStore.repositoryList) { repository in
                        ZStack {
                            RepositoryCardView {
                                HStack {
                                    NavigationLink {
                                        /* Repository Detail View */
                                        RepositoryDetailView()
                                    } label: {
                                        VStack(alignment: .leading) {
                                            HStack(alignment: .top) {
                                                VStack(alignment: .leading) {
                                                    Text(repository.name)
                                                        .font(.body)
                                                        .multilineTextAlignment(.leading)
                                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                                    Text(repository.owner)
                                                        .font(.title2)
                                                        .padding(.bottom, 1)
                                                        .multilineTextAlignment(.leading)
                                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                                }
                                                Spacer()
                                            }
                                            
                                            Text(repository.description)
                                                .font(.caption)
                                                .multilineTextAlignment(.leading)
                                                .foregroundColor(.gray)
                                        }
                                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                                    }
                                }
                            }
                            VStack {
                                /* Penpal, Menu button */
                                HStack {
                                    Spacer()
                                    
                                    NavigationLink(destination: {
                                        /*
                                         1. 우선 누구한테 챗 할지 레포기여자 목록 보여주기
                                         2. 그 중에서 이미 챗하고 있는 사람은 조금 다르게 표기하기
                                         */
                                        ContributorListView()
                                    }) {
                                        Image(systemName: "message.circle.fill")
                                    }
                                    .foregroundColor(colorScheme == .light ? .black : .white)
                                    
                                    Menu {
                                        Button(action: { print("Share") }) {
                                            Text("Share")
                                            Image(systemName: "square.and.arrow.up")
                                        }
                                        Button(action: { print("Penpal") }) {
                                            Text("Penpal")
                                            Image(systemName: "message")
                                        }
                                        Button(action: { print("Modify Tags") }) {
                                            Text("Modify Tags")
                                            Image(systemName: "tag")
                                        }
                                    } label: {
                                        Image(systemName: "ellipsis")
                                            .frame(height: 20)
                                    }
                                    .foregroundColor(colorScheme == .light ? .black : .white)
                                    
                                }
                                Spacer()
                            }
                            .offset(x: -20, y: 20)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 15)
                    }
                }
            }
            .sheet(isPresented: $isShowingSelectTagView) {
                AddTagSheetView(preSelectedTags: $selectedTagList, selectedTags: selectedTagList)
            }
        }
    }
}


struct StarredView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StarredView()
        }
    }
}
