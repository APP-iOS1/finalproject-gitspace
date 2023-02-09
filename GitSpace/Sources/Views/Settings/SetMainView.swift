//
//  SetMainView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/08.
//

import SwiftUI

struct SetMainView: View {
    
    @AppStorage("systemAppearance") private var systemAppearance: Int = AppearanceType.allCases.first!.rawValue
    
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
                // MARK: - USER SETTINGS
                Section {
                    // MARK: Account Settings
                    /// 계정
                    NavigationLink {
                        SetAccountView()
                    } label: {
                        HStack {
                            Image(systemName: "person.crop.square")
                                .foregroundColor(.gsGray2)
                            
                            Text("Account")
                        }
                    }
                    
                    // MARK: Privacy & Safety Settings
                    /// 개인정보 보호 및 보안
                    NavigationLink {
                        SetPrivacySafetyView()
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
                    // MARK: Appearance Settings
                    /// 디스플레이
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
                    
//                    // MARK: Accessibility Settings
//                    /// 접근성
//                    NavigationLink {
//
//                    } label: {
//                        HStack {
//                            Image(systemName: "hand.raised.circle")
//                                .foregroundColor(.gsGray2)
//
//                            Text("Accessibility")
//                        }
//                    }
                    
                    // MARK: Language Settings
                    /// 언어
                    NavigationLink {
                        SetLanguageView()
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
                    
                    // MARK: Text & Media Settings
                    /// 텍스트 및 미디어
                    NavigationLink {
                        SetTextMediaView()
                    } label: {
                        HStack {
                            Image(systemName: "captions.bubble")
                                .foregroundColor(.gsGray2)
                            
                            Text("Text & Media")
                        }
                    }
                    
                    // MARK: Notifications Settings
                    /// 알림
                    NavigationLink {
                        SetNotificationsView()
                    } label: {
                        HStack {
                            Image(systemName: "bell.badge.fill")
                                .foregroundColor(.gsGray2)
                            
                            Text("Notifications")
                        }
                    }
                    
                    // MARK: Knock Controls
                    /// 노크 제어
                    NavigationLink {
                        //KnockSettingView 
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
                    // MARK: Licenses
                    /// 라이센스
                    NavigationLink {
                        
                    } label: {
                            Text("Licenses")
                    }
                    
                    // MARK: Terms of Service
                    /// 이용약관
                    NavigationLink {
                        
                    } label: {
                            Text("Terms of Service")
                    }
                    
                } header: {
                    Text("LEGAL")
                }
            } // List
            .navigationBarTitle("Settings", displayMode: .inline)
        
    } // body
}

struct SetMainView_Previews: PreviewProvider {
    static var previews: some View {
        SetMainView()
    }
}
