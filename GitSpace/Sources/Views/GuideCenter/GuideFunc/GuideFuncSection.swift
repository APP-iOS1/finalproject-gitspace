//
//  GuideFuncSection.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/07.
//

import SwiftUI

struct GuideFuncSection: View {
    var body: some View {
        Group {
            
            HStack {
                GSText.CustomTextView(
                    style: .title2,
                    string: "Features")
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
            
            GSCanvas.CustomCanvasView.init(style: .primary, content: {
                /* 캔버스 내부: */
                
                Group {
                    
                    NavigationLink {
                        StarGuideView()
                    } label: {
                        HStack(spacing: 10) {

                            Image("GitSpace-Star")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 50)

                            VStack(alignment: .leading, spacing: 5) {
                                GSText.CustomTextView(
                                    style: .title3,
                                    string: "Star")

                                GSText.CustomTextView(
                                    style: .caption1,
                                    string: "Star repositories you want to see again")
                                .multilineTextAlignment(.leading)
                            }

                            VStack {
                                Text("")
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.gsGray2)
                        } // HStack
                    } // NavigationLink
                    
                    NavigationLink {
                        TagGuideView()
                    } label: {
                        HStack(spacing: 10) {

                            Image("GitSpace-Tag-Guide")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 50)

                            VStack(alignment: .leading, spacing: 5) {
                                GSText.CustomTextView(
                                    style: .title3,
                                    string: "Tag")

                                GSText.CustomTextView(
                                    style: .caption1,
                                    string: "Organize your starred repositories using tags")
                                .multilineTextAlignment(.leading)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.gsGray2)
                        } // HStack
                    } // NavigationLink
                    
                    NavigationLink {
                        ActivityGuideView()
                    } label: {
                        HStack(spacing: 10) {

                            Image("GitSpace-Activity-Guide")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 50)

                            VStack(alignment: .leading, spacing: 5) {
                                GSText.CustomTextView(
                                    style: .title3,
                                    string: "Activity")

                                GSText.CustomTextView(
                                    style: .caption1,
                                    string: "Catch up with your friends' latest Git activities")
                                .multilineTextAlignment(.leading)
                            }

                            VStack {
                                Text("")
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.gsGray2)
                        } // HStack
                    } // NavigationLink
                    
                    NavigationLink {
                        KnockGuideView()
                    } label: {
                        HStack(spacing: 10) {
                            
                            Image("GitSpace-Knock")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 50)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                GSText.CustomTextView(
                                    style: .title3,
                                    string: "Knock")
                                
                                GSText.CustomTextView(
                                    style: .caption1,
                                    string: "Knock, before your chat")
                                .multilineTextAlignment(.leading)
                            }
                            
                            VStack {
                                Text("")
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gsGray2)
                        } // HStack
                    } // NavigationLink
                    
                    NavigationLink {
                        ChatGuideView()
                    } label: {
                        HStack(spacing: 10) {
                            
                            Image("GitSpace-Chat-Guide")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 60)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                GSText.CustomTextView(
                                    style: .title3,
                                    string: "Chat")
                                
                                GSText.CustomTextView(
                                    style: .caption1,
                                    string: "Connect with contributors of your starred repositories")
                                .multilineTextAlignment(.leading)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gsGray2)
                        } // HStack
                    } // NavigationLink
                }
            }) // GSCanvas
            .padding(.horizontal)
        } // Group
    }
}

struct GuideFuncSection_Previews: PreviewProvider {
    static var previews: some View {
        GuideCenterView()
    }
}
