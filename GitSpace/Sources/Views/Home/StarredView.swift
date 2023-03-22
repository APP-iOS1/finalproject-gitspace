//
//  StarredView.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/01/17.
//

import SwiftUI

struct StarredView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var repositoryViewModel: RepositoryViewModel
    @EnvironmentObject var tagViewModel: TagViewModel
    @State private var searchTag: String = ""
    @State private var selectedTagList: [Tag] = []
    @State private var isShowingSelectTagView: Bool = false
    @StateObject private var keyboardHandler = KeyboardHandler()
    @State private var currentPage: Int = 1
    
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
        /// 삭제되는 태그들의 인덱스를 알면 쉽게 삭제가 된다.
        for (index, item) in Array(zip(tagViewModel.tags.indices, tagViewModel.tags)) {
            if item.id == tag.id {
                tagViewModel.tags[index].isSelected = false
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
                // FIXME: v1.0.0 출시를 위해 잠시 주석 처리함.
                /// 출시 기한을 맞추기 위해 부득이 검색창을 숨김처리합니다.
                /// 이후 다음 버전에 검색 기능을 넣을 예정입니다.
//                GSTextField.CustomTextFieldView(style: .searchBarField, text: $searchTag)
//                    .padding(.horizontal, 20)
                
                /* Scroll Main Content */
                
                /* selected tags header */
                HStack {
                    GSText.CustomTextView(
                        style: .caption1,
                        string: "Selected Tags")
                    
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
                        ForEach(Array(selectedTagList.enumerated()), id: \.offset) { index, tag in
                            GSButton.CustomButtonView(
                                style: .tag(
                                    isSelected: true,
                                    isEditing: false
                                )
                            ) {
                                withAnimation {
                                    removeTag(at: index, tag: tag)
                                    if !selectedTagList.isEmpty {
                                        repositoryViewModel.filterRepository(selectedTagList: selectedTagList)
                                    } else {
                                        repositoryViewModel.filteredRepositories = repositoryViewModel.repositories
                                    }
                                }
                            } label: {
                                Text("\(tag.tagName)")
                            }
                            .transition(
                                .asymmetric(
                                    insertion: .opacity.combined(with: .move(edge: .trailing)),
                                    removal: .opacity.combined(with: .move(edge: .leading))
                                )
                            )
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 10)
                
                /* repository list */
                ScrollView {
                    if let repositories = repositoryViewModel.filteredRepositories {
                        if repositories.isEmpty {
                            VStack(spacing: 10) {
                                Image("GitSpace-Star-Empty")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 300, height: 300)
                                
                                GSText.CustomTextView(
                                    style: .title3,
                                    string: "There is no repository\nthat you starred!")
                                .multilineTextAlignment(.center)
                            }
                        } else {
                            ForEach(Array(zip(repositories.indices, repositories)), id:\.0) { index, repository in
                                LazyVStack {
                                    ZStack {
                                        GSCanvas.CustomCanvasView(style: .primary) {
                                            HStack {
                                                NavigationLink {
                                                    /* Repository Detail View */
                                                    RepositoryDetailView(service: GitHubService(), repository: repository)
                                                } label: {
                                                    /* Repository Row */
                                                    VStack(alignment: .leading) {
                                                        HStack(alignment: .top) {
                                                            VStack(alignment: .leading) {
                                                                GSText.CustomTextView(
                                                                    style: .body1,
                                                                    string: repository.owner.login)
                                                                .multilineTextAlignment(.leading)
                                                                GSText.CustomTextView(
                                                                    style: .title2,
                                                                    string: repository.name)
                                                                .multilineTextAlignment(.leading)
                                                            }
                                                            Spacer()
                                                        }
                                                        .padding(.bottom, 5)
                                                        GSText.CustomTextView(
                                                            style: .caption1,
                                                            string: repository.description ?? "")
                                                        .multilineTextAlignment(.leading)
                                                    }
                                                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                                                    .onAppear {
                                                        Task {
                                                            if index % 30 == 27 {
                                                                currentPage += 1
                                                                repositoryViewModel.repositories! += await repositoryViewModel.requestStarredRepositories(page: currentPage) ?? []
                                                                repositoryViewModel.filteredRepositories = repositoryViewModel.repositories
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        
                                        VStack {
                                            /* Penpal, Menu button */
                                            HStack {
                                                Spacer()
                                                
                                                Menu {
                                                    // FIXME: v 1.0.0 에서는 넣지 않을 기능
                                                    /// 다음 버전에 출시 share을 넣을 예정
                                                    /*
                                                    Section {
                                                        Button(action: { print("Share") }) {
                                                            Label("Share", systemImage: "square.and.arrow.up")
                                                        }
                                                    }
                                                    */
                                                    Section {
                                                        Button(role: .destructive, action: { print("Unstar") }) {
                                                            Label("Unstar", systemImage: "star")
                                                        }
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
                                    } // ZStack
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 15)
                                }
                            } // ForEach
                        } // if-else repo.isEmpty
                    } else {
                        ForEach(0..<4, id: \.self) { i in
                            HomeCardSkeletonCell()
                        }
                    } // if-let repo
                } // ScrollView
            }
            .onViewDidLoad {
                Task {
                    repositoryViewModel.repositories = await repositoryViewModel.requestStarredRepositories(page: currentPage)
                    repositoryViewModel.filteredRepositories = repositoryViewModel.repositories
                    if !selectedTagList.isEmpty {
                        repositoryViewModel.filterRepository(selectedTagList: selectedTagList)
                    }
                }
            }
            .refreshable {
                currentPage = 1
                Task {
                    repositoryViewModel.repositories = await repositoryViewModel.requestStarredRepositories(page: currentPage)
                    repositoryViewModel.filteredRepositories = repositoryViewModel.repositories
                    if !selectedTagList.isEmpty {
                        repositoryViewModel.filterRepository(selectedTagList: selectedTagList)
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingSelectTagView) {
            AddTagSheetView(preSelectedTags: $selectedTagList, selectedTags: selectedTagList, beforeView: .starredView, selectedRepository: nil)
        }
        .onTapGesture {
            self.endTextEditing()
        }
    }
}


//struct StarredView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            StarredView()
//        }
//    }
//}
