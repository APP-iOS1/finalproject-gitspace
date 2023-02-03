//
//  GSTextEdior.swift
//  GitSpace
//
//  Created by 원태영 on 2023/02/03.
//

import SwiftUI

struct GSTextEdior: View {
    
    let multipleValue: Int = 25
    @State var text: String = ""
    @State var textEditorHeight: CGFloat = 25
    
    
    var body: some View {
        
        VStack {
            TextEditor(text: $text)
                .frame(maxHeight: textEditorHeight)
                .padding(.horizontal, 5)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke()
                }
                .padding(30)
            
            Button {
                print(text)
            } label: {
                Text("텍스트 출력")
            }

        }
        .onChange(of: text) { newValue in
            let enterCount = newValue.filter{$0 == "\n"}.count + 1
            textEditorHeight = CGFloat(enterCount * multipleValue)
        }
        .onChange(of: textEditorHeight) { newValue in
            if newValue > CGFloat(multipleValue * 5) {
                textEditorHeight = CGFloat(multipleValue * 5)
            }
        }
    }
}

struct GSTextEdior_Previews: PreviewProvider {
    static var previews: some View {
        GSTextEdior()
    }
}
