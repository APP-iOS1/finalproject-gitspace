//
//  StarredView.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/01/17.
//

import SwiftUI

// MARK: - Temporary Tag Struct
struct Tag: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var name: String
    var selectedCount: Int
    var isSelected: Bool = false
}

// MARK: - Temporary Repository Sturct
struct Repository: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var owner: String
    var description: String
    var tags: [Tag]?
}

// MARK: - Dummy Tag Data
var tagList: [Tag] = [
    Tag(name: "SwiftUI", selectedCount: 0),
    Tag(name: "Swift", selectedCount: 0),
    Tag(name: "MVVM", selectedCount: 0),
    Tag(name: "Interview", selectedCount: 0),
    Tag(name: "iOS", selectedCount: 0),
    Tag(name: "UIKit", selectedCount: 0),
    Tag(name: "Yummy", selectedCount: 0),
    Tag(name: "Checkit", selectedCount: 0),
    Tag(name: "TheVoca", selectedCount: 0),
    Tag(name: "GGOM-GGO-MI", selectedCount: 0)
]

// MARK: - Dummy Repository Data
var repositoryList: [Repository] = [
    Repository(name: "sanghee-dev", owner: "Hello-Chat", description: "Real time chat application built with SwiftUI & Firestore", tags: [tagList[0], tagList[1], tagList[4]]),
    Repository(name: "wwdc", owner: "2022", description: "Student submissions for the WWDC 2022 Swift Student Challenge", tags: [tagList[4]]),
    Repository(name: "apple", owner: "swift-evolution", description: "This maintains proposals for changes and user-visible enhancements to the Swift Programming Language.", tags: [tagList[4]]),
    Repository(name: "apple", owner: "swift", description: "The Swift Programming Language", tags: [tagList[4]]),
    Repository(name: "SnapKit", owner: "SnapKit", description: "A Swift Autolayout DSL for iOS & OS X", tags: [tagList[1], tagList[4]]),
    Repository(name: "clarknt", owner: "100-days-of-swiftui", description: "Solutions to Paul Hudson's \"100 days of SwiftUI\" projects and challenges", tags: [tagList[0], tagList[1], tagList[4]])
]

struct StarredView: View {
    @State private var searchTag: String = ""
    @State private var selectedTagList: [Tag] = []
    @State private var isShowingSelectTagView: Bool = false
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                /* selection tag view */
                HStack {
                    /* All, 모든 Starred Repository 열람하기 */
                    Button {
                        print("All")
                    } label: {
                        Text("All")
                    }
                    .padding(10)
                    .background(Color.black)
                    .foregroundColor(Color(.systemBackground))
                    .cornerRadius(10)
                    
                    ForEach(tagList[...2]) { tag in
                        Button {
                            print("\(tag.name)")
                            selectedTagList.append(tag)
                        } label: {
                            Text("\(tag.name)")
                        }
                        .padding(10)
                        .background(Color.black)
                        .foregroundColor(Color(.systemBackground))
                        .cornerRadius(10)
                    }
                    
                    Button {
                        /* SelectTagsView가 나오게 하기 위한 Bool 값 토글 */
                        isShowingSelectTagView.toggle()
                    } label: {
                        Text("...")
                    }
                    .padding(10)
                    .background(Color(.systemGray))
                    .foregroundColor(Color(.systemBackground))
                    .cornerRadius(30)
                }
            }
            .padding(.horizontal, 10)
            
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
            ScrollView {
                /* selected tags */
                HStack {
                    ForEach(Array(selectedTagList.enumerated()), id:\.offset) { index, tag in
//                        Button {
//                            print("\(tag.name)")
//                            selectedTagList.remove(at: index)
//                        } label: {
//                            Text("\(tag.name)")
//                        }
//                        .padding(5)
//                        .background(Color.black)
//                        .foregroundColor(Color(.systemBackground))
//                        .cornerRadius(10)
						
						// 버튼 추상화 완료~
						GSButton.ContentView(
							style: .tag
						) {
							selectedTagList.remove(at: index)
						} content:  {
							Text("\(tag.name)")
						}
                    }
                    Spacer()
                }
                .padding(.horizontal, 10)
                
                /* repository list */
                ForEach(repositoryList) { repository in
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
                                                    .foregroundColor(.black)
                                                Text(repository.owner)
                                                    .font(.title2)
                                                    .padding(.bottom, 1)
                                                    .multilineTextAlignment(.leading)
                                                    .foregroundColor(.black)
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
                                Menu {
                                    Button(action: { print("Share") }) {
                                        Text("Share")
                                        Image(systemName: "square.and.arrow.up")
                                    }
									
									GSButton.ContentView (
										style: .symbols) {
											print("Share")
										} content: {
											Group {
												Text("Share")
												Image(systemName: "square.and.arrow.up")
											}
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
                            }
                            Spacer()
                        }
                        .offset(x: -20, y: 20)
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingSelectTagView) {
            SelectTagsView(selectedTagList: $selectedTagList, isShowing: $isShowingSelectTagView)
        }
    }
	
	private func doth(index: Int) {
		selectedTagList.remove(at: index)
	}
}

// MARK: - Repository Card View
struct RepositoryCardView<Content: View>: View {
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        Group(content: content)
            .background(Color(.systemBackground))
            .shadow(color: Color(.systemGray6), radius: 5)
    }
}

struct StarredView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StarredView()
        }
    }
}
