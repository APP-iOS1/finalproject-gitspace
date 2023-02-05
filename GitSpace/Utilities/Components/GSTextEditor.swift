import SwiftUI

struct GSTextEditor {
    enum GSTextEditorStyle {
        case message
    }
    
    // MARK: -Properties
    // MARK: Stored Properties
    let style: GSTextEditorStyle
    let text: Binding<String>
    let font: Font
    let lineSpace: CGFloat?
    
    // MARK: Computed Properties
    // font 사이즈 관련 프로퍼티를 활용하기 위해 Font -> UIFont로 변환
    private var mainUIFont: UIFont {
        return UIFont.fontToUIFont(from: .body)
    }
    
    // font의 한 줄 높이를 계산하는 프로퍼티
    private var mainFontLineHeight: CGFloat {
        return mainUIFont.lineHeight
    }
    
    // TextEditor가 5줄을 초과했는지 검사하기 위한 프로퍼티
    private var maxTextEditorHeight: CGFloat {
        return mainFontLineHeight * 5
    }
    
    init (
        style: GSTextEditorStyle,
        text: Binding<String>,
        font: Font = .body,
        lineSpace: CGFloat? = 2
    ) {
        self.style = style
        self.text = text
        self.font = font
        self.lineSpace = lineSpace
    }
    
    
}

