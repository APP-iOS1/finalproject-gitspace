import SwiftUI

struct GSTextEditor {
    enum GSTextEditorStyle {
        case message
    }
    
    // MARK: -Properties
    let style: GSTextEditorStyle
    let text: Binding<String>
    let font: Font?
    let lineSpace: CGFloat?
    
    init (
        style: GSTextEditorStyle,
        text: Binding<String>,
        font: Font? = .body,
        lineSpace: CGFloat? = 2
    ) {
        self.style = style
        self.text = text
        self.font = font
        self.lineSpace = lineSpace
    }
    
}

