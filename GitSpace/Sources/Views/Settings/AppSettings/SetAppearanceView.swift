//
//  SetAppearanceView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/08.
//

import SwiftUI

enum AppearanceType: Int, Identifiable, CaseIterable {
    var id: Self { self }
    case auto
    case light
    case dark
}

extension AppearanceType {
    var appearance: String {
        switch self {
        case .auto:
            return "Automatic"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
}

struct SetAppearanceView: View {
    
    @AppStorage("systemAppearance") private var systemAppearance: Int = AppearanceType.allCases.first!.rawValue

    var selectedAppearance: ColorScheme? {
        guard let appearance = AppearanceType(rawValue: systemAppearance) else { return nil }
        
        switch appearance {
        case .light:
            return .light
        case .dark:
            return .dark
        default:
            return nil
        }
    }
    
    var body: some View {
        
        List(AppearanceType.allCases) { item in
            Button {
                appearancePrint(item: item)
                systemAppearance = item.rawValue
            } label: {
                HStack {
                    Text("\(item.appearance)")
                        .tag(item.rawValue)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if systemAppearance == item.rawValue {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
        .navigationBarTitle("Appearance", displayMode: .inline)
    } // body
    
    
    func appearancePrint(item: AppearanceType) {
        switch item {
        case .auto:
            print("[Appearance] Automatic: 시스템 설정을 따릅니다.")
        case .light:
            print("[Appearance] Light 모드로 변경합니다.")
        case .dark:
            print("[Appearance] Dark 모드로 변경합니다.")
        }
    }
}

struct SetAppearanceView_Previews: PreviewProvider {
    static var previews: some View {
        SetAppearanceView()
    }
}


