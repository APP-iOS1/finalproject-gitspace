//
//  RepositoryDetailView.swift
//  GitSpace
//
//  Created by yeeunchoi on 2023/01/17.
//

import SwiftUI

struct RepositoryDetailView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                RepositoryInfoCard()
                    .padding(.bottom, 20)
                
                RepositoryDetailViewTags()
                
                Spacer()

            }
            .padding(.horizontal, 30)
        }
        .navigationTitle("Repository")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
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
            Text("**RepoTitle**")
                .font(.largeTitle)
                .padding(.vertical, 5)
            
            HStack {
                ZStack {
                    Circle()
                        .frame(width: 50)
                        .foregroundColor(Color.gray)
                    Text("profile \nImage")
                        .font(.caption2)
                }
                Text("username")
                    .padding(.vertical, 5)
            }
            
            Text("This is a description paragraph for current repository. Check out more information by knocking on the user!")
                .padding(.vertical, 5)
            
            Text("⭐️ 234,305 stars")
                .font(.footnote)
                .padding(.vertical, 5)
                .foregroundColor(.gray)
            
            Divider()
            
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
            
            ScrollView(.horizontal) {
                HStack {
                    ZStack {
                        Circle()
                            .frame(width: 40)
                            .foregroundColor(Color.gray)
                        Text("profile \nImage")
                            .font(.caption2)
                    }
                    ZStack {
                        Circle()
                            .frame(width: 40)
                            .foregroundColor(Color.gray)
                        Text("profile \nImage")
                            .font(.caption2)
                    }
                    ZStack {
                        Circle()
                            .frame(width: 40)
                            .foregroundColor(Color.gray)
                        Text("profile \nImage")
                            .font(.caption2)
                    }
                }
            }
        }
        .padding()
        .border(Color.black, width: 2)

    }
}


struct RepositoryDetailViewTags: View {
    let tags: [String] = ["tag1", "tag2", "tag3", "tag4"]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("**My Tags**")
                    .font(.title2)
                
                Button {
                    // MainHomeView 코드 붙붙
                } label: {
                    Image(systemName: "plus")
                }
            }
           
            ScrollView(.horizontal) {
                HStack {
                    ForEach(tags, id:\.self) { tag in
                        Text(tag)
                            .font(.callout)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(.gray)
                            .border(Color.black, width: 2)
                    }
                }
            }
                
        }
    }
}

struct RepositoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryDetailView()
    }
}
