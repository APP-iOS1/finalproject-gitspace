//
//  AuthFiles.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/23.
//

import SwiftUI

// Models --------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------
// MARK: -유저 인포 모델

// ----------------------------------------------------------------------------------------------------------------------------------
// MARK: -스크롤 모델
import Foundation

struct ScrollModel : Identifiable {
    let id : String
    let title : String
    let content : String
}

// ViewModels --------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------
// MARK: -로그인 회원가입 뷰모델

import Firebase
import FirebaseAuth
import FirebaseFirestore

class AuthStore: ObservableObject {
    
    @Published var currentUser: Firebase.User?
    @Published var isLogin = false
    let database = Firestore.firestore()
    
    init() {
        currentUser = Auth.auth().currentUser
    }
    
    // MARK: -Auth : 로그인 함수
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error : \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.currentUser = result?.user
                self.isLogin = true
            }
        }
    }
    
    // MARK: -Auth : 로그아웃 함수
    func logout() {
        currentUser = nil
        self.isLogin = false
        try? Auth.auth().signOut()
    }
    
    // MARK: -Auth : 계정 생성
    func registerUser(name: String, email: String, password: String, userBirthday : Date) {
        Auth.auth().createUser(withEmail: email, password: password) { [self] result, error in
            if let error = error {
                print("Error : \(error.localizedDescription)")
                return
            }
            
            guard let authUser = result?.user else { return }
            
            let user = UserInfo(id: authUser.uid,
                                name: name,
                                email: email,
                                signUpDate: Date().timeIntervalSince1970)
            addUserInfo(user)
            // 회원가입 시, 해당 유저 정보로 로그인 되는 문제 해결을 위해 로그아웃 호출
            self.logout()
        }
    }
    
    // MARK: -Method : User Create
    func addUserInfo(_ userInfo: UserInfo) {
        database.collection("UserInfo")
            .document(userInfo.id)
            .setData(["id" : userInfo.id,
                      "name" : userInfo.name,
                      "email" : userInfo.email,
                      "signUpDate" : userInfo.signUpDate])
    }
}

// MARK: -Extension : 로그인 / 회원가입 관련 함수 익스텐션
extension AuthStore {
    // MARK: -Regexp : 회원가입 텍스트필드 체크 정규식
    func checkNameRule(name : String) -> Bool {
        let regExp = "^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]{2,8}$"
        return name.range(of: regExp, options: .regularExpression) != nil
    }
    
    func checkEmailRule(email : String) -> Bool {
        let regExp = #"^[a-zA-Z0-9+-\_.]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]{2,3}+$"#
        return email.range(of: regExp, options: .regularExpression) != nil
    }
    
    func checkPasswordRule(password : String) -> Bool {
        let regExp = "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,20}$"
        return password.range(of: regExp, options: .regularExpression) != nil
    }
    
    // MARK: - 이메일 중복 검사
    /// 사용자가 입력한 이메일이 이미 사용하고 있는지 검사합니다.
    /// 입력받은 이메일이 DB에 이미 있다면 false를, 그렇지 않다면 true를 반환합니다.
    /// - Parameter currentemail: 입력받은 사용자 이메일
    /// - Returns: 중복된 이메일이 있는지에 대한 Boolean 값
    @MainActor
    func isEmailDuplicated(currentEmail: String) async -> Bool {
        do {
            let document = try await database.collection("UserInfo")
                .whereField("email", isEqualTo: currentEmail)
                .getDocuments()
            return !(document.isEmpty)
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    // MARK: - 닉네임 중복 검사
    /// 사용자가 입력한 닉네임이 이미 사용하고 있는지 검사합니다.
    /// 입력받은 닉네임이 DB에 이미 있다면 false를, 그렇지 않다면 true를 반환합니다.
    /// - Parameter currentName: 입력받은 사용자 닉네임
    /// - Returns: 중복된 닉네임이 있는지에 대한 Boolean 값
    @MainActor
    func isNameDuplicated(currentName: String) async -> Bool {
        do {
            let document = try await database.collection("UserInfo")
                .whereField("name", isEqualTo: currentName)
                .getDocuments()
            return !(document.isEmpty)
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    
    // MARK: -Method : Date 타입의 날짜를 받아서 지정 형식(데이터베이스 저장 형태) 문자열로 반환하는 함수
    func getStringDate(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter.string(from: date)
    }
}
// ----------------------------------------------------------------------------------------------------------------------------------
// MARK: -스크롤 뷰모델


import Foundation

class ScrollViewModel : ObservableObject {
    @Published var scrollModels: [ScrollModel]
    
    init(scrollModels: [ScrollModel] = []) {
        self.scrollModels = scrollModels
    }
}

let scrollModel1 = ScrollModel(
    id : UUID().uuidString,
    title: "사이트 소유권 - 이용 약관 동의",
    content: "본 이용 약관('이용 약관')은 www.apple.com의 Apple 웹 사이트 및 전 세계 Apple 사이트 등 Apple과 그 자회사 및 관계회사에 의해 www.apple.com에 연결된 모든 사이트(총칭 '사이트')에 적용됩니다.\n 사이트는 Apple Inc.('Apple') 및 그 사용권 부여자의 재산입니다. 사이트를 사용하면 본 이용 약관에 동의하는 것입니다. 동의하지 않는 경우 사이트를 사용하지 마십시오.\n\n\nApple은 단독 재량에 따라 언제든지 본 이용 약관의 일부를 변경, 수정, 추가 또는 제거할 권리를 가집니다. 본 이용 약관에 변경 사항이 있는지 주기적으로 확인할 책임은 귀하에게 있습니다. 변경 사항 게시 후 사이트를 계속 사용하면 변경 사항에 동의하는 것입니다. 귀하가 본 이용 약관을 준수하는 경우에 한해 Apple은 귀하에게 사이트에 접속하고 사이트를 사용할 수 있는 개인적이고 비독점적이며 양도 불가능하고 제한된 권한을 부여합니다.")

let scrollModel2 = ScrollModel(
    id : UUID().uuidString,
    title: "콘텐츠",
    content: "사이트에 포함된 모든 텍스트, 그래픽, 사용자 인터페이스, 시각적 인터페이스, 사진, 상표, 로고, 사운드, 음악, 아트워크 및 컴퓨터 코드(총칭 '콘텐츠')는 해당 콘텐츠의 디자인, 구조, 선택, 조정, 표현, '외관과 느낌(look and feel)' 및 배열을 포함하되 이에 국한되지 않으며 Apple이 소유 또는 통제하거나 사용권을 부여하거나 사용권을 가지고, 트레이드 드레스, 저작권, 특허 및 상표법과 기타 다양한 지적 재산권 및 불공정 경쟁법으로 보호됩니다.\n\n\n본 이용 약관에 명시적으로 규정된 경우를 제외하고 Apple의 명시적 사전 서면 동의 없이 사이트의 일부 및 콘텐츠를 다른 컴퓨터, 서버, 웹 사이트, 기타 게시 또는 배포 미디어나 기업체용 미디어에 어떤 식으로든('미러링' 포함) 복사, 재생산, 재발행, 업로드, 게시, 공개 전시, 인코딩, 번역, 전송 또는 배포해서는 안 됩니다.\n\n\n귀하는 (1) 해당 문서의 모든 사본에 포함된 소유권 고지 문구를 제거하지 않고 (2) 해당 정보를 개인적이고 비상업적인 정보 목적으로만 사용하며 해당 정보를 네트워크에 연결된 컴퓨터에 복사 또는 게시하거나 어떠한 매체에도 방송하지 않고 (3) 해당 정보를 수정하지 않고 (4) 해당 문서에 대한 추가 진술 또는 보증을 하지 않는 경우 Apple이 사이트에서 다운로드할 수 있도록 의도적으로 제공한 Apple 제품 및 서비스에 대한 정보(예: 데이터 시트, 기술 문서 및 유사한 자료)를 사용할 수 있습니다.")

let scrollModel3 = ScrollModel(
    id : UUID().uuidString,
    title: "귀하의 사이트 사용",
    content: "'딥 링크', '페이지 스크랩', '로봇', '스파이더' 또는 기타 자동 기기, 프로그램, 알고리즘 또는 방법론이나 그와 유사하거나 동등한 수동 절차를 사용하여 사이트 또는 콘텐츠의 일부에 접근하거나 이를 취득, 복사 또는 모니터링하거나, 사이트 또는 콘텐츠의 탐색 구조나 표현을 어떤 식으로든 복제하거나 우회함으로써 사이트를 통해 의도적으로 제공되지 않은 수단으로 자료, 문서 또는 정보를 획득하거나 획득하려고 시도해서는 안 됩니다. Apple은 해당 활동을 금지할 권리를 가집니다.\n\n\n해킹, 암호 '마이닝' 또는 기타 불법적인 수단을 통해 사이트의 일부나 기능, 사이트나 Apple 서버에 연결된 기타 시스템이나 네트워크, 사이트에서 또는 사이트를 통해 제공되는 서비스에 대한 무단 접근 권한을 얻으려고 시도해서는 안 됩니다.\n\n\n사이트 또는 사이트에 연결된 네트워크의 취약성을 탐지, 검사 또는 테스트하거나, 사이트 또는 사이트에 연결된 네트워크에 대한 보안 또는 인증 수단을 위반해서는 안 됩니다. 자신의 소유가 아닌 Apple 계정을 포함하여 사이트의 다른 사용자나 방문자 또는 Apple의 다른 고객에 대한 정보를 그 소스까지 역조회, 추적 또는 추적 시도하거나, 본인 정보를 제외하고 사이트에 의해 제공된 개인 신원 또는 정보를 포함하되 이에 국한되지 않는 정보를 공개할 목적으로 어떤 식으로든 사이트를 이용하거나 사이트에서 또는 사이트를 통해 사용할 수 있거나 제공되는 서비스 또는 정보를 이용해서는 안 됩니다.\n\n\n귀하는 사이트 또는 Apple의 시스템이나 네트워크, 사이트나 Apple에 연결된 시스템 또는 네트워크의 인프라에 부당하게 또는 형평에 맞지 않게 과도한 부하를 가하는 행위를 하지 않는 데 동의합니다.\n\n\n귀하는 기기, 소프트웨어 또는 루틴을 사용하여 사이트의 적절한 작동 또는 사이트에서 이루어지는 모든 거래 또는 다른 사람의 사이트 사용을 방해하거나 방해하려고 시도하지 않는 데 동의합니다.\n\n\n사이트에서 또는 사이트를 통해 전송하거나 사이트에서 또는 사이트를 통해 제공되는 서비스를 통해 Apple에 전송하는 메시지나 전송의 출처를 감추기 위해 제목을 위조하거나 다른 방식으로 식별자를 조작해서는 안 됩니다. 다른 사람으로 가장하거나 다른 사람을 대표한다고 가장하거나 다른 개인 또는 단체를 사칭해서는 안 됩니다.\n\n\n사이트 또는 콘텐츠를 불법적이거나 본 이용 약관에서 금지하는 목적으로 사용하거나 불법적인 활동 또는 Apple이나 타인의 권리를 침해하는 그 밖의 활동을 권유하기 위해 사용해서는 안 됩니다.")


let scrollModel4 = ScrollModel(
    id : UUID().uuidString,
    title: "피드백 및 정보",
    content: "이 사이트에서 귀하가 제공하는 모든 피드백은 기밀 정보가 아닌 것으로 간주됩니다. Apple은 해당 정보를 제한 없이 자유롭게 사용할 수 있습니다.\n\n이 웹 사이트에 포함된 정보는 예고 없이 변경될 수 있습니다.\n\nCopyright © 1997-2009 Apple Inc. 모든 권리 보유.\n\nApple Inc., One Apple Park Way, Cupertino, CA 95014, USA.\n\n2009년 11월 20일에 Apple 법무 팀이 업데이트함")


// Views --------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------
// MARK: -로그인 뷰


import SwiftUI

struct LoginView: View {
    
    // MARK: -Properties
    var isFieldEmpty : Bool {
        return emailField.isEmpty || passwordField.isEmpty
    }
    
    // MARK: -State
    @EnvironmentObject var authStore: AuthStore
    @State var emailField = ""
    @State var passwordField = ""
    @State var naviLinkActive : Bool = false
    @State private var isVisible : Bool = false
    @State private var isLoginClicked : Bool = false
    
    var body: some View {
        VStack(spacing : 30) {
            Image("MyDiaryLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width : 200)
                .padding(.bottom, 40)
                .overlay(alignment : .bottom) {
                    if isLoginClicked {
                        ProgressView {
                            Text("로그인 중이에요...")
                                .bold()
                        }
                    }
                }
                .offset(y: 50)
            
            
            emailFiledSection
            passwordFieldSection
            loginButton
                .padding(.vertical, 40)
            LoginOptionButtonField
            
            Spacer()
                .frame(height : 30)
            
        }
        .padding()
        
    }
    
    
    // MARK: -View : 이메일 입력 필드
    private var emailFiledSection : some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "envelope")
                Text("이메일")
            }
            .modifier(CategoryTextModifier())
            
            TextField("이메일을 입력해주세요", text: $emailField)
                .modifier(LoginTextFieldModifier())
        }
    }
    
    // MARK: -View : 패스워드 입력 필드
    private var passwordFieldSection : some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "key")
                Text("비밀번호")
                Button {
                    isVisible.toggle()
                } label: {
                    Image(systemName: isVisible
                          ? "eye" : "eye.slash")
                }
            }
            .modifier(CategoryTextModifier())
            .padding(.top)
            
            if isVisible {
                TextField("비밀번호를 입력해주세요", text: $passwordField)
                    .modifier(LoginTextFieldModifier())
            } else {
                SecureField("비밀번호를 입력해주세요", text: $passwordField)
                    .modifier(LoginTextFieldModifier())
            }
            
        }
    }
    
    
    // MARK: -Button : 로그인 버튼
    private var loginButton : some View {
        Button {
            authStore.login(email: emailField, password: passwordField)
            isLoginClicked = true
        } label: {
            Text("로그인")
            
        }
        .modifier(ButtonModifier())
        .disabled(isLoginClicked || isFieldEmpty)
    }
    
    // MARK: -Button : 회원가입 버튼
    private var registerButton : some View {
        NavigationLink(isActive : $naviLinkActive) {
            TermsConditionView(naviLinkActive: $naviLinkActive)
                .modifier(NavigationTitleModifier(title: "이용약관"))
        } label: {
            Text("회원가입")
        }
        
    }
    
    
    // MARK: -View : 아이디 / 비밀번호 찾기, 회원가입 버튼 Stack
    private var LoginOptionButtonField : some View {
        HStack {
            Button {
                print("아이디 찾기 버튼 클릭")
            } label: {
                Text("아이디 찾기")
            }
            
            Text(" | ")
            
            Button {
                print("비밀번호 찾기 버튼 클릭")
            } label: {
                Text("비밀번호 찾기")
            }
            
            Text(" | ")
            
            registerButton
        }
        .modifier(CategoryTextModifier())
    }
}



// ----------------------------------------------------------------------------------------------------------------------------------
// MARK: -회원가입 뷰
import SwiftUI

// TODO: -
/// 1. 가입 완료 텍스트 띄워주고 1초 후 나가기 - [완료]
/// 2. 하단 중복확인 텍스트 안내 방식 변경
/// 3. 텍스트필드 포커스 문제 해결
/// 4. infoCheck 상수 추가 - [완료]
/// 5. navititle modifier로 묶기 - [완료]
/// 6. if문으로 offset 내리기
/// 7. placeHolder를 라벨로 이동시키기
/// 8. 입력 완료 상수 추가 - [완료]
/// 9. 주석 작업
/// 10. 네비게이션 타이틀 Modifier - [완료]
/// 11. 비밀번호 visible 버튼 라벨 옆으로 이동 - [완료]
/// 12. 로그인 버튼 클릭 후 disable - [완료]

enum HelpDescription : String {
    case name = "이름을 알려주세요!\n"
    case email = "이메일을 입력해주세요!\n"
    case password = "비밀번호를 입력해주세요!\n"
    case passwordCheck = "비밀번호를 한번 더 입력해주세요!"
    case infoCheck = "님! 이 정보가 맞나요?"
    case registSuccess = "회원가입이 완료되었어요. 반가워요 "
}

enum RegisterDepth {
    case name, email, password, passwordCheck, infoCheck, registSuccess
}

enum Field : String, Hashable {
    case name = "이름"
    case email = "이메일"
    case password = "패스워드"
    case passwordCheck = "패스워드 확인"
}

struct RegisterView: View {
    // MARK: -Properties
    let progressButtonText : String = "입력 완료"
    
    // MARK: --State
    @EnvironmentObject var authStore : AuthStore
    @FocusState private var focusedField : Field?
    
    // 회원가입 진행 Depth
    @State private var helpDescription : HelpDescription = .name
    @State private var registerDepth : RegisterDepth = .name
    
    // 중복확인 안내 문구
    @State private var nameDuplicateDescription : String = "\n"
    @State private var emailDuplicateDescription : String = "\n"
    
    @State private var isPasswordVisible : Bool = false
    @State private var isPasswordCheckVisible : Bool = false
    
    @State private var nameField : String = ""
    @State private var confirmName: String = ""
    @State private var emailField : String = ""
    @State private var confirmEmail: String = ""
    @State private var passwordField : String = ""
    @State private var passwordCheckField : String = ""
    @State private var nameCheck = false
    @State private var emailCheck = false
    @State private var showingAlert = false
    @Binding var naviLinkActive : Bool
    
    // MARK: --Computed Properties
    /// 이름 정규식 체크
    var isNameRule: Bool {
        return authStore.checkNameRule(name: nameField)
    }
    /// 이메일 정규식 체크
    var isEmailRule : Bool {
        return authStore.checkEmailRule(email: emailField)
    }
    /// 비밀번호 정규식 체크
    var isPasswordRule : Bool {
        return authStore.checkPasswordRule(password: passwordField)
    }
    /// 비밀번호 & 비밀번호 확인 일치 여부 체크
    var isPasswordsSame : Bool {
        return !passwordField.isEmpty && passwordField == passwordCheckField
    }
    /// 현재 이름 & 중복 체크 완료 이름 일치 여부 체크
    var isConfirmName : Bool {
        return confirmName == nameField
    }
    /// 현재 이메일 & 중복 체크 완료 이메일 일치 여부 체크
    var isConfirmEmail : Bool {
        return confirmEmail == emailField
    }
    /// 모든 조건 체크
    var isAllTrue : Bool {
        return isNameRule && isEmailRule && isPasswordRule &&
        isPasswordsSame && isConfirmName && isConfirmEmail
    }
    
    
    // MARK: -Main View
    var body: some View {
        
        VStack(alignment: .leading, spacing: 30) {
            
            // 최상단 안내 문구
            HStack {
                switch helpDescription {
                case .infoCheck:
                    Text(nameField + helpDescription.rawValue)
                case .registSuccess:
                    Text(helpDescription.rawValue + nameField + "님!")
                default:
                    Text(helpDescription.rawValue)
                }
                Spacer()
            }
            .modifier(LargeDescriptionModifier())
            
            
            
            withAnimation {
                
                Group {
                    switch registerDepth {
                    case .name:
                        nameFiledSection
                    case .email:
                        emailFiledSection
                        nameFiledSection
                    case .password:
                        passwordFieldSection
                        emailFiledSection
                        nameFiledSection
                    case .passwordCheck:
                        passwordCheckFieldSection
                        passwordFieldSection
                        emailFiledSection
                        nameFiledSection
                    case .infoCheck:
                        Spacer()
                        passwordCheckFieldSection
                        passwordFieldSection
                        emailFiledSection
                        nameFiledSection
                    case .registSuccess:
                        EmptyView()
                    }
                }
            }
            Spacer()
        }
        .onAppear {
            focusedField = .name
        }
        .padding(30)
        .overlay(alignment : .bottom) {
            switch registerDepth {
            case .name:
                nameButtonGroup
            case .email:
                emailButtonGroup
            case .password:
                passwordApplyButton
            case .passwordCheck:
                passwordCheckApplyButton
            case .infoCheck:
                signUpButton
            case .registSuccess:
                EmptyView()
            }
        }
        .padding(.bottom, 80)
    }
    
    
    // MARK: 이름 관련 Components
    
    // MARK: -View : 이름 입력 필드
    private var nameFiledSection : some View {
        VStack(alignment: .leading) {
            // 라벨링
            SectionLabel(systemImage: "person.fill",
                         labelText: "이름")
            
            // 텍스트 필드
            HStack {
                if registerDepth == .name {
                    TextField("ex.원태영", text: $nameField)
                        .onChange(of: nameField) { value in
                            if nameField != confirmName {
                                nameDuplicateDescription = "\n"
                                nameCheck = false
                            }
                        }
                        .modifier(RegisterTextFieldModifier(targetField: $nameField))
                } else {
                    Text(nameField)
                }
            }
            .font(.title3)
            
            Spacer()
                .frame(height : 20)
            
            if registerDepth == .name {
                if isNameRule {
                    Text("사용 가능한 이름이에요.\n")
                        .foregroundColor(Color.captionGreen)
                        .font(.subheadline)
                    
                } else if nameField.isEmpty == false {
                    
                    Text("이름은 2~8자의 공백, 특수기호를 제외한 문자로만 가능해요.\n")
                        .foregroundColor(Color.captionRed)
                        .font(.subheadline)
                    
                } else {
                    Text("\n")
                        .font(.subheadline)
                }
            }
            
        }
    }
    
    // MARK: 이메일 관련 Components
    
    // MARK: -View : 이메일 입력 필드
    private var emailFiledSection : some View {
        VStack(alignment: .leading) {
            SectionLabel(systemImage: "envelope",
                         labelText: "이메일")
            
            HStack {
                if registerDepth == .email {
                    TextField("ex.example@test.com", text: $emailField)
                        .focused($focusedField, equals: .email)
                        .onChange(of: emailField) { value in
                            if emailField != confirmEmail {
                                emailDuplicateDescription = "\n"
                                emailCheck = false
                            }
                        }
                        .modifier(RegisterTextFieldModifier(targetField: $emailField))
                } else {
                    Text(emailField)
                }
            }
            .font(.title3)
            
            Spacer()
                .frame(height : 20)
            
            if registerDepth == .email {
                if isEmailRule {
                    Text("사용 가능한 이메일이에요.\n")
                        .foregroundColor(Color.captionGreen)
                        .font(.subheadline)
                    
                } else if emailField.isEmpty == false {
                    Text("유효하지 않은 이메일 형식이에요.\n")
                        .foregroundColor(Color.captionRed)
                        .font(.subheadline)
                } else {
                    Text("\n")
                        .font(.subheadline)
                }
            }
        }
    }
    
    
    
    // MARK: -View : 패스워드 입력 필드
    private var passwordFieldSection : some View {
        VStack(alignment: .leading) {
            
            HStack {
                SectionLabel(systemImage: "key",
                             labelText: "비밀번호")
                Button {
                    isPasswordVisible.toggle()
                } label: {
                    Image(systemName: isPasswordVisible
                          ? "eye" : "eye.slash")
                    .modifier(CategoryTextModifier())
                }
            }
            
            HStack {
                if registerDepth == .password {
                    Group {
                        if isPasswordVisible {
                            TextField("비밀번호", text: $passwordField)
                        } else {
                            SecureField("비밀번호", text: $passwordField)
                        }
                    }
                    .modifier(RegisterTextFieldModifier(targetField: $passwordField))
                } else {
                    Text(isPasswordVisible
                         ? passwordField
                         : String(repeating: "●",
                                  count: passwordField.count))
                }
                Spacer()
            }
            .font(.title3)
            
            Spacer()
                .frame(height : 20)
            
            Group {
                if registerDepth == .password {
                    if isPasswordRule {
                        Text("사용 가능한 비밀번호에요.\n")
                            .foregroundColor(Color.captionGreen)
                    } else if passwordField.isEmpty == false {
                        Text("비밀번호는 영문, 숫자, 특수문자를 포함하여 8~20자로 구성되어야해요.")
                            .foregroundColor(Color.captionRed)
                    } else {
                        Text("\n")
                    }
                }
            }
            .font(.subheadline)
        }
    }
    
    // MARK: -View : 패스워드 확인 입력 필드
    private var passwordCheckFieldSection : some View {
        VStack(alignment: .leading) {
            HStack {
                SectionLabel(systemImage: "key.fill",
                             labelText: "비밀번호 확인")
                
                Button {
                    isPasswordCheckVisible.toggle()
                } label: {
                    Image(systemName: isPasswordCheckVisible
                          ? "eye" : "eye.slash")
                    .modifier(CategoryTextModifier())
                }
            }
            
            HStack {
                
                if registerDepth == .passwordCheck {
                    Group {
                        if isPasswordCheckVisible {
                            TextField("비밀번호 확인",
                                      text: $passwordCheckField)
                        } else {
                            SecureField("비밀번호 확인",
                                        text: $passwordCheckField)
                        }
                    }
                    .modifier(RegisterTextFieldModifier(targetField: $passwordCheckField))
                } else {
                    Text(isPasswordCheckVisible
                         ? passwordCheckField
                         : String(repeating: "●",
                                  count: passwordCheckField.count))
                }
                
            }
            .font(.title3)
            
            Spacer()
                .frame(height : 20)
            
            Group {
                if registerDepth == .passwordCheck {
                    if isPasswordsSame {
                        Text("일치하는 비밀번호에요.\n")
                            .foregroundColor(Color.captionGreen)
                    } else if passwordCheckField.isEmpty == false {
                        
                        Text("비밀번호가 일치하지 않아요.\n")
                            .foregroundColor(Color.captionRed)
                        
                    } else {
                        Text("")
                    }
                }
            }
            .font(.subheadline)
        }
        
    }
    
    // MARK: -하단 Depth 진행 버튼 그룹
    // MARK: -Button : 이름 중복 확인 버튼
    private var nameDuplicateCheckButton : some View {
        Button {
            Task {
                if await !authStore.isNameDuplicated(currentName: nameField) {
                    nameDuplicateDescription = "[\(nameField)]은(는) 사용 가능한 이름이에요!"
                    nameCheck.toggle()
                    confirmName = nameField
                } else {
                    nameDuplicateDescription = "[\(nameField)]은(는) 중복된 이름이에요.다른 이름을 사용해주세요!"
                }
            }
        } label: {
            Text("중복 확인")
                .modifier(ButtonModifier())
        }
        .disabled(nameField.isEmpty || !isNameRule)
    }
    
    // MARK: -Button : 이름 확인 버튼
    private var nameApplyButton : some View {
        Button {
            helpDescription = .email
            registerDepth = .email
            focusedField = .email
            nameDuplicateDescription = "\n"
        } label : {
            Text(progressButtonText)
                .modifier(ButtonModifier())
        }
    }
    
    // MARK: -ButtonGroup : 이름 Depth 진행
    private var nameButtonGroup : some View {
        Group {
            if nameCheck {
                nameApplyButton
            } else {
                nameDuplicateCheckButton
            }
        }
        .overlay {
            Text(nameDuplicateDescription)
                .offset(y: -60)
                .frame(maxWidth : .infinity, alignment : .leading)
        }
    }
    
    // MARK: -Button : 이메일 중복 확인 버튼
    private var emailDuplicateCheckButton : some View {
        Button {
            Task {
                if await !authStore.isEmailDuplicated(currentEmail: emailField) {
                    emailDuplicateDescription = "[\(emailField)]은(는) 사용 가능한 이메일이에요!"
                    emailCheck.toggle()
                    confirmEmail = emailField
                } else {
                    emailDuplicateDescription = "[\(emailField)]은(는) 이미 가입이 된 이메일이에요!"
                }
            }
        } label: {
            Text("중복 확인")
        }
        .disabled(emailField.isEmpty || !isEmailRule)
        .modifier(ButtonModifier())
    }
    
    // MARK: -Button : 이메일 확인 버튼
    private var emailApplyButton : some View {
        Button {
            helpDescription = .password
            registerDepth = .password
            focusedField = .password
            emailDuplicateDescription = "\n"
        } label : {
            Text(progressButtonText)
        }
        .modifier(ButtonModifier())
    }
    
    // MARK: -ButtonGroup : 이메일 Depth 진행
    private var emailButtonGroup : some View {
        Group {
            if emailCheck {
                emailApplyButton
            } else {
                emailDuplicateCheckButton
            }
        }
        .overlay {
            Text(emailDuplicateDescription)
                .offset(y: -60)
                .frame(maxWidth : .infinity, alignment : .leading)
        }
    }
    
    // MARK: -Button : 패스워드 확인 버튼
    private var passwordApplyButton : some View {
        Button {
            helpDescription = .passwordCheck
            registerDepth = .passwordCheck
            focusedField = .passwordCheck
            
        } label : {
            Text(progressButtonText)
                .modifier(ButtonModifier())
        }
        .disabled(!isPasswordRule)
    }
    
    // MARK: -Button : 패스워드 체크 확인 버튼
    private var passwordCheckApplyButton : some View {
        Button {
            helpDescription = .infoCheck
            registerDepth = .infoCheck
        } label : {
            Text(progressButtonText)
                .modifier(ButtonModifier())
        }
        .disabled(!isPasswordsSame)
    }
    
    
    // MARK: -Button : 회원가입 시도 버튼
    private var signUpButton : some View {
        
        Button {
            authStore.registerUser(name: nameField,
                                   email: emailField,
                                   password: passwordField,
                                   userBirthday: Date())
            helpDescription = .registSuccess
            registerDepth = .registSuccess
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                naviLinkActive = false
            }
        } label: {
            Text("네! 가입할게요")
                .modifier(ButtonModifier())
        }
    }
}

// MARK: -Label : Section 라벨링
struct SectionLabel : View {
    let systemImage : String
    let labelText : String
    
    var body: some View {
        Label(labelText, systemImage: systemImage)
            .modifier(CategoryTextModifier())
    }
    
}
// ----------------------------------------------------------------------------------------------------------------------------------
// MARK: -약관동의 뷰
import SwiftUI

struct TermsConditionView: View {
    
    let IDList : [Int] = [0,1,2,3]
    
    @ObservedObject var scrollViewModel : ScrollViewModel = ScrollViewModel(
        scrollModels: [scrollModel1, scrollModel2, scrollModel3, scrollModel4]
    )
    @State private var currentID : Int = 0
    @State private var isAgreeDone : Bool = false
    @Binding var naviLinkActive : Bool
    
    var body: some View {
        VStack {
            // MARK: -ScrollView : proxy로 스크롤을 조절할 수 있는 ScrollView
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment : .leading) {
                        ForEach(scrollViewModel.scrollModels.indices) { index in
                            Text(scrollViewModel.scrollModels[index].title)
                                .font(.largeTitle.bold())
                                .padding(.bottom, 20)
                                .id(IDList[index])
                            
                            Text(scrollViewModel.scrollModels[index].content)
                                .font(.body)
                                .padding(.bottom, 60)
                            
                        }
                        .padding(.horizontal, 20)
                    }
                }
                Group {
                    // MARK: -Overlay : 화면 하단에 고정 위치로 존재하는 버튼 파트
                    if let lastID = IDList.last {
                        if currentID < lastID {
                            Button {
                                increaseID()
                                withAnimation {
                                    proxy.scrollTo(IDList[currentID], anchor : .top)
                                }
                            } label: {
                                Text("아래로 스크롤하기")
                                    .modifier(ButtonModifier())
                            }
                        } else {
                            agreeButton
                        }
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .padding(.top, 20)
    }
    
    // MARK: -Button : 동의하기 버튼
    private var agreeButton : some View {
        
        NavigationLink {
            RegisterView(naviLinkActive: $naviLinkActive)
                .modifier(NavigationTitleModifier(title: "회원가입"))
                .navigationBarBackButtonHidden(true)
        } label: {
            Text("네! 동의합니다")
        }
        .modifier(ButtonModifier())
        .disabled(isAgreeDone)
    }
    
    // MARK: -Func : 현재 proxy ID를 1씩 증가시키는 함수
    private func increaseID() {
        self.currentID += 1
    }
    
}


import SwiftUI

// MARK: -Text Modifiers
// Plain Text Modifier
struct BodyTextModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
    }
}

struct TitleTextModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.textAccent)
            .font(.title3.bold())
    }
}

// Section Labeling Modifier
struct CategoryTextModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.textAccent)
    }
}

// Title Text Modifier
struct LargeDescriptionModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Pretendard-Bold", size: 28).bold())
    }
}


// MARK: -Modifier : 네비게이션 타이틀, 모드 속성
struct NavigationTitleModifier : ViewModifier {
    let title : String
    func body(content: Content) -> some View {
        content
            .font(.custom("Pretendard-Bold", size: 18))
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: -Button Modifiers
// Priority 1 Button Modifier
struct ButtonModifier : ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(width: 280, height: 50)
            .background(Color.backAccent)
            .foregroundColor(.black)
            .cornerRadius(15)
    }
}

struct DisabledButtonModifier : ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(width: 280, height: 50)
            .cornerRadius(15)
    }
}





// MARK: -TextField Modifier
// LoginView TextField Modifier
struct LoginTextFieldModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Pretendard-SemiBold", size: 18))
            .frame(width: 300, height: 20)
            .textInputAutocapitalization(.never)
            .foregroundColor(.black)
            .overlay(Rectangle().frame(height: 2).padding(.top, 40))
            .foregroundColor(Color.accentColor)
    }
}


// RegisterView TextField Modifier
struct RegisterTextFieldModifier : ViewModifier {
    @Binding var targetField : String
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth : .infinity)
            .frame(height : 20)
            .font(.custom("Pretendard-SemiBold", size: 18))
            .textInputAutocapitalization(.never)
            .foregroundColor(.black)
            .overlay(Rectangle().frame(height: 2).padding(.top, 40))
            .foregroundColor(Color.accentColor)
            .overlay(alignment : .trailing) {
                Button {
                    targetField = ""
                } label: {
                    Image(systemName: "xmark.circle")
                }
            }
    }
}
