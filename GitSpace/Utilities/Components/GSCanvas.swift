//
//  GSCanvas.swift
//  GitSpace
//
//  Created by yeeunchoi on 2023/02/03.
//

import Foundation
import SwiftUI


struct GSCanvas {
    public enum GSCanvasStyle {
        case lightmode
        case darkmode
    }
    
    struct CustomCanvasView<Content: View>: View {
        
        public let style: GSCanvasStyle
        public let content: Content
        
        var body: some View {
            
            switch style {
            case .lightmode:
                Group {
                    content
                }
                .modifier(GSCanvasModifier(style: .lightmode))
                
            case .darkmode:
                Group {
                    content
                }
                .modifier(GSCanvasModifier(style: .darkmode))
            }
        }
        
        init(style: GSCanvasStyle, @ViewBuilder content: () -> Content) {
            self.style = style
            self.content = content()
        }
    }
}




struct TestCanvas: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            
            
            // MARK: - testing
            
            GSCanvas.CustomCanvasView.init(style: .lightmode, content: {
                VStack {
                    Text("dddddd")
                        .font(.title3)
                    Text("dddddd")
                        .font(.title3)
                    Text("dddddd")
                        .font(.title3)
                    Text("dddddd")
                        .font(.title3)
                    Text("dddddd")
                        .font(.title3)
                    Text("dddddd")
                        .font(.title3)
                    Text("dddddd")
                        .font(.title3)
                }
            })
            
            
            
            
            // MARK: - 1. Repo List
            Group {
                HStack {
                    NavigationLink {
                        RepositoryDetailView()
                    } label: {
                        VStack(alignment: .leading) {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading) {
                                    Text("Repo-name")
                                        .font(.body)
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                    Text("Repo-owner")
                                        .font(.title2)
                                        .padding(.bottom, 1)
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                }
                                Spacer()
                            }
                            
                            Text("Repo description")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.gray)
                        }
                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                    }
                }
            }
            .cornerRadius(17)
            .background(
                RoundedRectangle(cornerRadius: 17, style: .continuous)
                    .fill(.white)
                    .shadow(color: Color(uiColor: UIColor.systemGray5), radius: 6, x: 0, y: 2)
            )

            
            Spacer()
            
            
            
            
            // MARK: - 2. Repo Detail
            VStack(alignment: .leading) {

                Text("Repo title")
                    .font(.largeTitle)
                    .padding(.bottom, 5)

                Text("This is a description paragraph for current repository. Check out more information by knocking on users!")
                    .padding(.vertical, 5)

                Text("⭐️ 234,305 stars")
                    .font(.footnote)
                    .padding(.vertical, 5)
                    .foregroundColor(.secondary)

                Divider()

                Text("**Contributors**")
                    .padding(.vertical, 5)

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
                RoundedRectangle(cornerRadius: 17, style: .continuous)
                    .fill(.white)
                    .shadow(color: Color(uiColor: UIColor.systemGray5), radius: 6, x: 0, y: 2)
            )

            Spacer()
            
            
            // MARK: - 3. Chat Recommendation
            VStack(alignment: .trailing) {
                HStack {
                    Image("avatarImage")
                        .frame(width: 64)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("@" + "Username")
                            .font(.title3)
                            .bold()
                        
                        HStack {
                            Group {
                                Text("112")
                                    .bold()
                                    .padding(.trailing, -5)
                                Text("followers")
                            }
                            .font(.callout)
                            
                            Text("·")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Group {
                                Text("357")
                                    .bold()
                                    .padding(.trailing, -5)
                                Text("repos")
                            }
                            .font(.callout)
                        }
                        
                    }
                }
                
                Spacer()
                    .frame(height: 20)

                NavigationLink {
                    SendKnockView()
                } label: {
                    Text("Let's Chat!")
                        .font(.callout)
                        .foregroundColor(.primary)
                        .fontWeight(.semibold)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 23)
                        .background(Color.gsGreenPrimary)
                        .cornerRadius(20)
                }
            }
            .padding(.vertical, 21)
            .padding(.horizontal, 17)
            
            .background(
                RoundedRectangle(cornerRadius: 17, style: .continuous)
                    .fill(.white)
                    .shadow(color: Color(uiColor: UIColor.systemGray5), radius: 6, x: 0, y: 2)
            )
            
            
            Spacer()
            
            
            // MARK: - 4. Knock Message
            Text("\("Knock message - Hi! This is Gildong from South Korea who’s currently studying Web programming. Would you mind giving me some time and advising me on my future career path? \nThank you so much for your help!")")
                .font(.system(size: 15, weight: .regular))
                .padding(.horizontal, 30)
                .padding(.vertical, 30)
                .fixedSize(horizontal: false, vertical: true)
                .background(
                    RoundedRectangle(cornerRadius: 17)
                        .fill(.white)
                        .shadow(color: Color(.systemGray5), radius: 6, x: 0, y: 2)
                    
                )
                .padding(.horizontal, 15)
        }
        .padding(.horizontal, 40)
    }
}


struct GSCanvas_Previews: PreviewProvider {
    static var previews: some View {
        TestCanvas()
    }
}
