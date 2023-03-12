//
//  GSTextField.swift
//  GitSpace
//
//  Created by 원태영, 이다혜, 최한호 on 2023/02/03.
//

// TODO: Namespace 학습해서 GS 접두어 뺄 수 있는 구조로 만들기

import SwiftUI

// MARK: -Memo
/// 1. Field 스타일 두 개가 HStack과 TextField라서 한 extension으로 Modifier를 만들 수 없음
/// 2. placeHolder는 컬러를 따로 지정해줄 수 없음
/// 3. 다크모드에서 백그라운드가 .white면 좀 밝은 것 같아서 으니한테 물어보기. 이거 placeHolder가 다크모드 기준으로 색이 더 연함
/// 4. 돋보기 아이콘이 일반 앱에서 보통 깜박이 커서랑 같은 회색인데 블랙으로 갈지
/// 5. 텍스트필드에서 제네릭을 따로 안써도 되는데 가지고 있어야 함? 제네릭 선언해두고 안넣어주면 빌드가 안됨 됌?

struct GSTextField {
    
	enum GSTextFieldStyle {
		case searchBarField
        case addTagField
	}
	
    struct CustomTextFieldView: View {
        
        public let const = Constant.TextFieldConst.self
        public let style: GSTextFieldStyle
        public let text: Binding<String>
        @Environment(\.colorScheme) var colorScheme
        
        init(style: GSTextFieldStyle, text: Binding<String>) {
            self.style = style
            self.text = text
        }
        
        var body: some View {
            switch style {
                
                // MARK: SearchBar
            case .searchBarField:
                HStack(spacing: const.SEARCHBAR_SYMBOL_PLACEHOLDER_SPACE) {
                    Image(systemName: const.SEARCHBAR_FIELD_SYMBOL_NAME)
                    TextField(const.SEARCHBAR_FIELD_PLACEHOLDER, text: text)
                }
                .modifier(GSTextFieldLayoutModifier(style: style))
                
            case .addTagField:
                TextField(const.ADDTAG_FIELD_PLACEHOLDER, text: text)
                    .modifier(GSTextFieldLayoutModifier(style: style))
            }
        }
	}
}


struct Test: View {
    @State var text1: String = ""
    @State var text2: String = ""
	
	var body: some View {
		VStack {
            GSTextField.CustomTextFieldView.init(style: .searchBarField,
                                         text: $text1)
            
            GSTextField.CustomTextFieldView.init(style: .addTagField,
                                         text: $text2)
		}
	}
}
 

struct Test_: PreviewProvider {
	@State static var text = "112"
	
	static var previews: some View {
		Test()
	}
}
 
