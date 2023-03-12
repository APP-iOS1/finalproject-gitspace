//
//  GSTextFieldLayoutModifier.swift
//  GitSpace
//
//  Created by 원태영, 이다혜, 최한호 on 2023/02/03.
//

import SwiftUI

struct GSTextFieldLayoutModifier: ViewModifier {
    
    public let style: GSTextField.GSTextFieldStyle
    public let const = Constant.TextFieldConst.self
    
    func body(content: Content) -> some View {
        switch style {
        case .searchBarField:
            content
                .foregroundColor(.primary)
                .padding(EdgeInsets(top: const.SEARCHBAR_INSET_VERTICAL,
                                    leading: const.SEARCHBAR_INSET_HORIZONTAL,
                                    bottom: const.SEARCHBAR_INSET_VERTICAL,
                                    trailing: const.SEARCHBAR_INSET_HORIZONTAL))
                // FIXME: gsGray3 추가 후 변경 필요
                .background(colorScheme == .light
                            ? Color.gsGray3
                            : Color.primary)
                .cornerRadius(const.SEARCHBAR_CORNER_RADIUS)
            
        case .addTagField:
            content
                .foregroundColor(.primary)
                .padding(EdgeInsets(top: const.ADDTAG_INSET_VERTICAL,
                                    leading: const.ADDTAG_INSET_HORIZONTAL,
                                    bottom: const.ADDTAG_INSET_VERTICAL,
                                    trailing: const.ADDTAG_INSET_HORIZONTAL))
            // FIXME: gsGray3 추가 후 변경 필요
                .background(colorScheme == .light
                            ? Color.gsLightGray2
                            : .gsLightGray1)
                .cornerRadius(const.ADDTAG_CORNER_RADIUS)
        }
        
    }
}

