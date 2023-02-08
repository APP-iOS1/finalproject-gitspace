//
//  SetMainView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/08.
//

import SwiftUI

struct SetMainView: View {
    
    @AppStorage("systemAppearance") private var systemAppearance: Int = AppearanceType.allCases.first!.rawValue
    
    @State private var isAllNotiEnabled: Bool = true
    @State private var isDeclinedNotiEnabled: Bool = true
    @State private var isAcceptedNotiEnabled: Bool = true
//    @State private var appearanceText: String = "Automatic"
//
//
    var appearanceText: String? {
        guard let appearance = AppearanceType(rawValue: systemAppearance) else { return nil }
        
        switch appearance {
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        default:
            return "Automatic"
        }
    }
    
    
    var body: some View {
            List {
                
                /*
                // 연구 중
                Section {
                    NavigationLink {
                        StarGuideView()
                    } label: {
                        HStack(spacing: 10) {
                            
                            Image("GitSpace-Star")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 50)
                            
                            VStack(alignment: .leading) {
                                GSText.CustomTextView(
                                    style: .title3,
                                    string: "Star")
                                
                                GSText.CustomTextView(
                                    style: .caption1,
                                    string: "다시 보고 싶은 레포지토리\nStar 해봅시다!")
                                .multilineTextAlignment(.leading)
                            }
                            
                            Spacer()
                        } // HStack
                    } // NavigationLink
                }
                
                Section {
                    NavigationLink {
                        StarGuideView()
                    } label: {
                        HStack(spacing: 10) {
                            
                            Image("GitSpace-Activity")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 50)
                            
                            VStack(alignment: .leading) {
                                GSText.CustomTextView(
                                    style: .title3,
                                    string: "Activity")
                                
                                GSText.CustomTextView(
                                    style: .caption1,
                                    string: "Follow한 유저들의 활동 보기")
                                .multilineTextAlignment(.leading)
                            }
                            
                            VStack {
                                Text("")
                            }
                            
                            Spacer()
                        } // HStack
                    } // NavigationLink
                }
                
                Section {
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
                                    string: "정중한 대화의 시작,\n노크에 대한 모든 것")
                                .multilineTextAlignment(.leading)
                            }
                            
                            VStack {
                                Text("")
                            }
                            
                            Spacer()
                        } // HStack
                    } // NavigationLink
                }
                
                Section {
                    NavigationLink {
                        KnockGuideView()
                    } label: {
                        HStack(spacing: 10) {
                            
                            Image("GitSpace-Chat")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 60)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                GSText.CustomTextView(
                                    style: .title3,
                                    string: "Chat")
                                
                                GSText.CustomTextView(
                                    style: .caption1,
                                    string: "Star한 레포의 기여자들과 대화 나누기")
                                .multilineTextAlignment(.leading)
                            }
                            
                            Spacer()
                        } // HStack
                    } // NavigationLink
                }
                // 연구 중
                */
                
                // MARK: - USER SETTINGS
                Section {
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            Image(systemName: "person.crop.square")
                                .foregroundColor(.gsGray2)
                            
                            Text("Account")
                        }
                    }
                    
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            Image(systemName: "checkerboard.shield")
                                .foregroundColor(.gsGray2)
                            
                            Text("Privacy & Safety")
                        }
                    }
                }
                
                // MARK: - APP SETTINGS
                Section {
                    
                    NavigationLink {
                        SetAppearanceView()
                    } label: {
                        HStack {
                            Image(systemName: "paintpalette")
                                .foregroundColor(.gsGray2)
                            
                            Text("Appearance")
                            
                            Spacer()
                            
                            Text("\(appearanceText ?? "Automatic")")
                                .font(.subheadline)
                                .foregroundColor(.gsGray2)
                        }
                    }
                    
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            Image(systemName: "hand.raised.circle")
                                .foregroundColor(.gsGray2)
                            
                            Text("Accessibility")
                        }
                    }
                    
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            Image(systemName: "globe")
                                .foregroundColor(.gsGray2)
                            
                            Text("Language")
                            
                            Spacer()
                            
                            Text("\("English, US")")
                                .font(.subheadline)
                                .foregroundColor(.gsGray2)
                        }
                    }
                    
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            Image(systemName: "captions.bubble")
                                .foregroundColor(.gsGray2)
                            
                            Text("Text & Media")
                        }
                    }
                    
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            Image(systemName: "bell.badge.fill")
                                .foregroundColor(.gsGray2)
                            
                            Text("Notifications")
                        }
                    }
                    
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            Image(systemName: "hand.wave")
                                .foregroundColor(.gsGray2)
                            
                            Text("Knock Controls")
                        }
                    }
                    
                } header: {
                    Text("APP SETTINGS")
                }
                
                // MARK: - LEGAL
                Section {
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            
                            Text("Licenses")
                        }
                    }
                    
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            
                            Text("Terms of Service")
                        }
                    }
                    
                } header: {
                    Text("LEGAL")
                }
                
                // MARK: - APP MANAGEMENT
                Section {
                    Button(role: .cancel) {
                        print("모든 캐시를 ;;삭제할거임")
                    } label: {
                        HStack {
                            Text("Clear cache")
                            Spacer()
                            Text("\(10) MB")
                                .foregroundColor(.gsGray2)
                        }
                    }
                } header: {
                    Text("app Management")
                }
                
            } // List
            //.listStyle(GroupedListStyle())
            .navigationBarTitle("Settings", displayMode: .inline)
        
    } // body
}

struct SetMainView_Previews: PreviewProvider {
    static var previews: some View {
        SetMainView()
    }
}
