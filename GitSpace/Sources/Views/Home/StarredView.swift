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
    Tag(name: "All", selectedCount: 0),
    Tag(name: "SwiftUI", selectedCount: 0),
    Tag(name: "Swift", selectedCount: 0),
    Tag(name: "MVVM", selectedCount: 0),
    Tag(name: "Interview", selectedCount: 0),
    Tag(name: "iOS", selectedCount: 0)
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
    @State var searchTag: String = ""
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                /* selection tag view */
                HStack {
                    ForEach(tagList) { tag in
                        Button {
                            print("\(tag.name)")
                        } label: {
                            Text("\(tag.name)")
                        }
                        .padding(10)
                        .background(Color.black)
                        .foregroundColor(Color(.systemBackground))
                        .cornerRadius(10)
                    }
                }
            }
            ScrollView {
                /* selected tags */
                HStack {
                    ForEach(tagList) { tag in
                        Button {
                            print("\(tag.name)")
                        } label: {
                            Text("\(tag.name)")
                        }
                        .padding(10)
                        .background(Color.black)
                        .foregroundColor(Color(.systemBackground))
                        .cornerRadius(20)
                    }
                }
                
                /* repository list */
                ForEach(repositoryList) { repository in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(repository.owner)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.black)
                            Spacer()
                            Button(action: { print("penpal") }) {
                                Image(systemName: "message.circle.fill")
                            }
                            Button(action: { print("ellipsis") }) {
                                Image(systemName: "ellipsis")
                            }
                        }
                        
                        Text(repository.name)
                            .font(.title2)
                            .padding(.bottom, 1)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.black)
                        
                        Text(repository.description)
                            .font(.caption)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemFill))
                    .padding(5)
                }
            }
            /* searchbar */
            .searchable(
                text: $searchTag,
                placement: .navigationBarDrawer,
                prompt: Text("Placeholder")
            )
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
