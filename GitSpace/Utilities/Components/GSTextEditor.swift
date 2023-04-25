// MARK: -Process
/// 1. TextEditor에 쓰일 Font를 전달받는다
/// 2. Font를 UIFont로 변환한 연산 프로퍼티를 통해 텍스트 한 줄의 높이를 계산한다 (lineHeight)
/// 3. 행간을 추가로 max 높이에 더해주기 위해 줄 간격을 필수 파라미터로 받는다
/// 4. Font 높이, 라인 갯수, 행간, 여유공간을 모두 더해서 TextEditor 높이를 실시간으로 업데이트한다
///

// MARK: -Memo
/// 1. Font 이니셜라이저를 통해 UIFont -> Font 타입으로 변환
///     Font.init(font: CTFont(UIFont 타입))
/// 2. Font -> UIFont 타입으로 변환
///     UIFont.preferredFont(from: Font(스유 Font 타입))

import SwiftUI

struct GSTextEditor {
    
    // MARK: Style Enum
    enum GSTextEditorStyle {
        case message
    }
    
    // MARK: -View
    struct CustomTextEditorView : View {
        
        // MARK: -Properties
        // MARK: Stored Properties
        let const = Constant.TextEditorConst.self
        
        // MARK: TextEditor 관련 프로퍼티
        let style: GSTextEditorStyle
        let text: Binding<String>
        let font: Font
        let lineSpace: CGFloat
        let isBlocked: Bool
        
        // MARK: SendButton 관련 프로퍼티
        let sendableImage: String
        let unSendableImage: String
        let action: () -> Void
        
        
        @State private var textEditorHeight: CGFloat = 0
        @State private var stateTextWidth: CGFloat = 0
        
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
            return mainFontLineHeight * CGFloat(const.TEXTEDITOR_MAX_LINE_COUNT)
        }
        
        /// 현재 text가 몇 줄인지 반환하는 프로퍼티
        /// 개행문자 갯수 + 1 = maxLineCount
        /// 개행문자가 maxNewLineCount개 초과일 때, 해당 갯수로 고정
        /// 입력이 없을 때도 한 줄에 대한 최소 높이가 필요하므로 + 1
        private var newLineCounter: Int {
            let currentText: String = text.wrappedValue
            let currentNewLineCount: Int = currentText.filter{$0 == "\n"}.count
            let maxNewLineCount: Int = const.TEXTEDITOR_MAX_LINE_COUNT - 1
            return (currentNewLineCount > maxNewLineCount
                    ? maxNewLineCount
                    : currentNewLineCount) + 1
        }
        
        // 현재 텍스트의 길이를 계산하는 프로퍼티
        private var textWidth: CGFloat {
            let lastLinetext = text.wrappedValue
            let label = UILabel()
            label.font = .fontToUIFont(from: font)
            label.text = lastLinetext
            label.sizeToFit()
            return label.frame.width
        }
        
        // 메세지 문자열이 비어있는지, 공백으로만 이루어져있는지를 체크해서 메시지 전송 가능 여부를 반환하는 연산 프로퍼티
        private var isMessageSendable: Bool {
            let messageText = text.wrappedValue
            guard messageText.isEmpty == false else { return false }
            let pattern: String = "^[ \n]*$"
            if messageText.range(of: pattern,
                                 options: .regularExpression) != nil {
                return false
            }
            return true
        }
        
        // MARK: -Methods
        // MARK: Method - 시작 textEditor 높이를 세팅해주는 메서드
        private func setTextEditorStartHeight() {
            textEditorHeight = mainFontLineHeight + const.TEXTEDITOR_FRAME_HEIGHT_FREESPACE
        }
        
        // MARK: Method - line count를 통해 textEditor 현재 높이를 계산해서 업데이트하는 메서드
        // TextEditor (줄 갯수 * 폰트 높이) + (줄 갯수 * 자간) + 잘림 방지 여유 공간
        private func updateTextEditorCurrentHeight(textEditorWidth: CGFloat) {
            
            // 개행문자 갯수
            let floatNewLineCounter = CGFloat(newLineCounter)
            
            // 텍스트 길이에 의한 자동 줄바꿈 갯수
            let floatAutoLineBreakCount = CGFloat(
                autoLineBreakCount(textEditorWidth: textEditorWidth)
            )
            
            // 총 라인 갯수
            let floatTotalLineCount = floatNewLineCounter + floatAutoLineBreakCount
            
            // 라인 갯수로 계산한 현재 Editor 높이
            let tempTextEditorHeight = (floatTotalLineCount * mainFontLineHeight)
            + floatTotalLineCount * lineSpace
            + const.TEXTEDITOR_FRAME_HEIGHT_FREESPACE
            
            // 최대 줄 갯수
            let floatMaxLineCount = CGFloat(const.TEXTEDITOR_MAX_LINE_COUNT)
            
            // 최대 줄 갯수 기준 Editor 높이
            let maxHeight = mainFontLineHeight * floatMaxLineCount
            + lineSpace * floatMaxLineCount
            + const.TEXTEDITOR_FRAME_HEIGHT_FREESPACE

            // 계산한 Editor 높이가 최대 Editor 높이보다 크면 최대 Editor 높이로 고정
            textEditorHeight = tempTextEditorHeight > maxHeight
            ? maxHeight
            : tempTextEditorHeight
        }
        
        // MARK: Method - 개행 문자 기준으로 텍스트를 분리하고, 각 텍스트 길이가 Editor 길이를 초과하는지 계산하여 필요한 줄바꿈 수를 반환하는 메서드
        private func autoLineBreakCount(textEditorWidth: CGFloat) -> Int {
            var counter: Int = 0
            text.wrappedValue.components(separatedBy: "\n").forEach { line in
                let label = UILabel()
                label.font = .fontToUIFont(from: font)
                label.text = line
                label.sizeToFit()
                if label.frame.width > textEditorWidth {
                    counter = Int(label.frame.width / textEditorWidth)
                }
            }
            return counter
        }

        // MARK: -Initializer
        /// 파라미터 font = .body, lineSpace = 2 기본값 지정
        init (
            style: GSTextEditorStyle,
            text: Binding<String>,
            font: Font = .body,
            lineSpace: CGFloat = 2,
            isBlocked: Bool,
            sendableImage: String,
            unSendableImage: String,
            action: @escaping () -> Void
        ) {
            self.style = style
            self.text = text
            self.font = font
            self.lineSpace = lineSpace
            self.isBlocked = isBlocked
            self.sendableImage = sendableImage
            self.unSendableImage = unSendableImage
            self.action = action
        }
        
        
        // MARK: -View
        var body: some View {
            switch style {
            case .message:
                
                if isBlocked {
                    TextEditor(
                        text: .constant(const.TEXTEDITOR_BLOCKED_LABEL)
                    )
                    .modifier(
                        GSTextEditorLayoutModifier(
                            font: font,
                            color: .gsGray1,
                            lineSpace: lineSpace,
                            maxHeight: textEditorHeight,
                            horizontalInset: const.TEXTEDITOR_INSET_HORIZONTAL,
                            bottomInset: const.TEXTEDITOR_INSET_BOTTOM
                        )
                    )
                    .disabled(true)
                    .overlay {
                        RoundedRectangle(cornerRadius: const.TEXTEDITOR_STROKE_CORNER_RADIUS)
                            .stroke()
                            .foregroundColor(.gsGray2)
                            .background(
                                Color.gsGray3.opacity(0.7)
                            )
                            .cornerRadius(const.TEXTEDITOR_STROKE_CORNER_RADIUS)
                    }
                    .onAppear {
                        setTextEditorStartHeight()
                    }
                    
                } else {
                    HStack {
                        GeometryReader { proxy in
                            TextEditor(text: text)
                                .modifier(
                                    GSTextEditorLayoutModifier(
                                        font: font,
                                        color: .primary,
                                        lineSpace: lineSpace,
                                        maxHeight: textEditorHeight,
                                        horizontalInset: const.TEXTEDITOR_INSET_HORIZONTAL,
                                        bottomInset: const.TEXTEDITOR_INSET_BOTTOM
                                    )
                                )
                                .overlay {
                                    RoundedRectangle(cornerRadius: const.TEXTEDITOR_STROKE_CORNER_RADIUS)
                                        .stroke()
                                        .foregroundColor(.gsGray2)
                                }
                                .onAppear {
                                    setTextEditorStartHeight()
                                }
                                .onChange(of: text.wrappedValue) { n in
                                    // FIXME: 현재 버퍼값으로는 텍스트 길이와 에디터 길이 사이의 공식을 정확하게 구하지 못함 -> 당장 작동은 하지만 정확한 값을 구해서 수정 필요 By. 태영
                                    let textEditorWidth = proxy.size.width - (const.TEXTEDITOR_INSET_HORIZONTAL * 2 + 10)
                                    let autoLineBreakCounter = autoLineBreakCount(textEditorWidth: textEditorWidth)
                                    let multiTextEditorWidth = textEditorWidth - CGFloat(autoLineBreakCounter * 2)
                                    
                                    updateTextEditorCurrentHeight(textEditorWidth: multiTextEditorWidth)
                                }
                                .onChange(of: textWidth) { newValue in
                                    stateTextWidth = newValue
                                }
                        }
                        .frame(maxHeight: textEditorHeight)
                        
                        Button {
                            action()
                        } label: {
                            Image(
                                systemName: isMessageSendable
                                ? sendableImage
                                : unSendableImage
                            )
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(
                                width: const.TEXTEDITOR_SEND_BUTTON_SIZE,
                                height: const.TEXTEDITOR_SEND_BUTTON_SIZE
                            )
                            .foregroundColor(
                                isMessageSendable
                                ? .primary
                                : .gsGray2
                            )
                        }
                        .disabled(!isMessageSendable)
                    }
                }
            }
        }
    }
}


