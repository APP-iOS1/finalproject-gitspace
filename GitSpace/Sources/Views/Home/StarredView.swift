//
//  StarredView.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/01/17.
//

import SwiftUI

struct StarredView: View {
    
    let gitHubService: GitHubService
    
    init(service: GitHubService) {
        self.gitHubService = service
    }
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var repositoryViewModel: RepositoryViewModel
    @EnvironmentObject var tagViewModel: TagViewModel
    @State private var searchTag: String = ""
    @State private var selectedTagList: [Tag] = []
    @State private var isShowingSelectTagView: Bool = false
    @StateObject private var keyboardHandler = KeyboardHandler()
    
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
//        guard let tags = repositoryViewModel.tags else { return }
        for (index, item) in Array(zip(tagViewModel.tags.indices, tagViewModel.tags ?? [])) {
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
                GSTextField.CustomTextFieldView(style: .searchBarField, text: $searchTag)
                    .padding(.horizontal, 20)
                
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
                    
                    if let repo = repositoryViewModel.repositories {
                        if repo.isEmpty {
                            VStack(spacing: 10) {
                                Image("GitSpace-Star-Empty")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 300, height: 300)
                                
                                Text("There is no repository\nthat you starred!")
                                    .font(.title3)
                                    .foregroundColor(.gsGray1)
                                    .multilineTextAlignment(.center)
                            }
                        } else {
                            ForEach(repositoryViewModel.repositories!) { repository in
                                ZStack {
                                    GSCanvas.CustomCanvasView(style: .primary) {
                                        HStack {
                                            NavigationLink {
                                                /* Repository Detail View */
                                                RepositoryDetailView(service: gitHubService, repository: repository)
                                            } label: {
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
                                            }
                                        }
                                    }
                                    
                                    VStack {
                                        /* Penpal, Menu button */
                                        HStack {
                                            Spacer()
                                            
                                            Menu {
                                                Section {
                                                    Button(action: { print("Share") }) {
                                                        Label("Share", systemImage: "square.and.arrow.up")
                                                    }
                                                    Button(action: { print("Chat") }) {
                                                        Label("Chat", systemImage: "message")
                                                    }
                                                    //                                            Button(action: { print("Modify Tags") }) {
                                                    //                                                Label("Modify Tags", systemImage: "tag")
                                                    //                                            }
                                                }
                                                
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
                            } // ForEach
                        } // if-else repo.isEmpty
                    } // if-let repo
                } // ScrollView
            }
            .onAppear{
                Task {
                    await repositoryViewModel.requestStarredRepositories(page: 1)
                }
            }
            .refreshable {
                Task {
                    await repositoryViewModel.requestStarredRepositories(page: 2)
                }
            }
        }
        .sheet(isPresented: $isShowingSelectTagView) {
            AddTagSheetView(preSelectedTags: $selectedTagList, selectedTags: selectedTagList, beforeView: .starredView)
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
