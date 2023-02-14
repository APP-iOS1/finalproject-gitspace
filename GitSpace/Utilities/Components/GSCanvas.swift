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
        case primary
        /* 카드 스타일은 나중에 더 추가될 가능성 있음 (예: 프로필 뷰에서 자기소개 카드) */
    }
    
    struct CustomCanvasView<Content: View>: View {
        
        public let style: GSCanvasStyle
        public let content: Content
        
        var body: some View {
            
            content
                .modifier(GSCanvasModifier(style: .primary))
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
            
            
            // MARK: - Testing Views
            
            /*
             
             GSCanvas는 아래와 같은 방식으로 사용됩니다.
             GSCanvas.CustomCanvasView.init(style: 카드 스타일 (현재는 primary만 존재), content: {
                Stack or Group으로 감싸진 내용
             })
             
             */
            

            // MARK: - 1. Repo List
            
            GSCanvas.CustomCanvasView.init(style: .primary, content: {
                /* 캔버스 내부: */
                Group {
                    NavigationLink {
//                        RepositoryDetailView(service: <#GitHubService#>)
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
                    }
                }
            })
            
            
            // MARK: - 2. Repo Detail
            
            GSCanvas.CustomCanvasView.init(style: .primary, content: {
                /* 캔버스 내부: */
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
            })
            
            
            // MARK: - 3. Chat Recommendation
            
            GSCanvas.CustomCanvasView.init(style: .primary, content: {
                /* 캔버스 내부: */
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
            })
            
            
            // MARK: - 4. Knock Message
            
            GSCanvas.CustomCanvasView.init(style: .primary, content: {
                /* 캔버스 내부: */
                VStack {
                    Text("\("Knock message - Hi! This is Gildong from South Korea who’s currently studying Web programming. Would you mind giving me some time and advising me on my future career path? \nThank you so much for your help!")")
                        .font(.system(size: 15, weight: .regular))
                }

            })
        }
        .padding(.horizontal, 40)
    }
}


struct GSCanvas_Previews: PreviewProvider {
    static var previews: some View {
        TestCanvas()
    }
}
