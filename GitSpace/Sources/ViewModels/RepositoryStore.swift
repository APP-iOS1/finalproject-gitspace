//
//  RepositoryStore.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/02/05.
//

import Foundation

class RepositoryStore: ObservableObject {
    // MARK: - Dummy Tag Data
    @Published var tagList: [Tag] = [
        Tag(name: "SwiftUI"),
        Tag(name: "Swift"),
        Tag(name: "MVVM"),
        Tag(name: "Interview"),
        Tag(name: "iOS"),
        Tag(name: "UIKit"),
        Tag(name: "Yummy"),
        Tag(name: "Checkit"),
        Tag(name: "TheVoca"),
        Tag(name: "GGOM-GGO-MI")
    ]
    
    // MARK: - Dummy Repository Data
    @Published var repositoryList: [Repository] = [
        Repository(name: "sanghee-dev", owner: "Hello-Chat", description: "Real time chat application built with SwiftUI & Firestore", tags: [0, 1, 4]),
        Repository(name: "wwdc", owner: "2022", description: "Student submissions for the WWDC 2022 Swift Student Challenge", tags: [4]),
        Repository(name: "apple", owner: "swift-evolution", description: "This maintains proposals for changes and user-visible enhancements to the Swift Programming Language.", tags: [4]),
        Repository(name: "apple", owner: "swift", description: "The Swift Programming Language", tags: [4]),
        Repository(name: "SnapKit", owner: "SnapKit", description: "A Swift Autolayout DSL for iOS & OS X", tags: [1, 4]),
        Repository(name: "clarknt", owner: "100-days-of-swiftui", description: "Solutions to Paul Hudson's \"100 days of SwiftUI\" projects and challenges", tags: [0, 1, 4])
    ]
}
